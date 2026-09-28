# Jest Contract Testing Standards (NestJS Backend)

> Read `nestjs-jest-common.md` first. Its rules apply here and are not repeated — file placement, naming, TSDoc, import ordering, type safety, assertion philosophy.

## Purpose

Contract tests verify that an **external** API still behaves as this application expects — response shape, status codes, error format, pagination. They exist to catch an upstream breaking change before production does. They do not test internal logic; that is what unit tests are for.

## What to test

- Assert the response envelope: fields, types, nullability.
- Assert a known-entity lookup returns the expected data.
- Assert the error response structure.
- Cover input parameter behaviour (filters, wildcards, offsets) and edge cases (limit boundaries, empty results, mismatched criteria).

## What NOT to test

- Don't test internal service logic or branching.
- Don't assert exact counts for broad queries — use `toBeGreaterThanOrEqual`. Live data changes, and a hard count turns into a failing build on someone else's edit.
- Don't assert volatile fields (addresses, phone numbers, dates).
- Don't test latency or performance — network variance makes it noise.

## No-mock policy

The value of a contract test is that it hits the real thing. A mock anywhere in the path makes it a unit test with a slower runtime.

| Concern | Do | Do not |
| --- | --- | --- |
| Service under test | Real class in `providers` | `useValue` mock |
| External API calls | Let them hit the real API | `jest.spyOn` intercept |
| Helper utilities | Plain functions | `jest.fn()` wrappers |
| Service import | Value import in `__setup__/` | `import type` (DI needs the runtime reference) |
| `jest.mock()` | — | Never in contract tests |

## Lifecycle — one call, many assertions

Use `beforeAll`/`afterAll`, never `beforeEach`/`afterEach`. Make a single API call, cache the response, and assert against the cache from every `it()`. With `beforeEach` you make one live call per test, which multiplies runtime and your rate-limit exposure for no additional coverage.

```typescript
beforeAll(async () => {
  const ctx = await createExternalApiModule();
  module = ctx.module;
  service = ctx.service;
  response = await service.search(buildInput({ id: KnownRecord.id }));
}, API_TIMEOUT);

afterAll(async () => {
  await module.close();
});
```

A `describe` block can have its own `beforeAll` when it needs a different query.

## Timeouts

- Export `API_TIMEOUT` (recommend `15_000`) from the `__setup__/` file.
- Pass it as the third argument to every `it()` making a live call, and as the second to any `beforeAll` that does.
- Don't set a global Jest timeout — it would hide slow unit tests too.

```typescript
it(
  "should return the exact record when searching by ID alone",
  async () => {
    const result = await service.search(buildInput({ id: KnownRecord.id }));
    expect(result.result_count).toBe(1);
  },
  API_TIMEOUT,
);
```

## Known fixture pattern

Anchor assertions on a stable, well-known entity, stored in `__fixtures__/` as an `as const` object. Include only immutable or slow-changing fields, and document where it came from so the next person can re-verify it rather than guess whether a failure is a real regression.

```typescript
/**
 * Known record fixture for contract test assertions.
 *
 * @remarks
 * - Source: https://api.example.com/registry
 * - Record "ABC-12345" is a stable public entry; classification and name were
 *   pinned on 2026-03-19 and may change if the record is updated upstream.
 * - Re-verify with `npm run test:contract`.
 */
export const KnownRecord = {
  id: "ABC-12345",
  lastName: "SMITH",
  state: "NY",
  classification: "General Practice",
} as const;
```

## Setup helpers

Export from `__setup__/`: the module factory, `API_TIMEOUT`, an input builder with sensible defaults, and any index/lookup helper that turns a scan into an O(1) assertion.

```typescript
export function buildInput(overrides: Partial<SearchInput>): SearchInput {
  const input = new SearchInput();
  input.record_type = RecordType.Individual;
  input.limit = 10;
  Object.assign(input, overrides);
  return input;
}
```

Type `Promise.all` tuples with `satisfies`, not `as`:

```typescript
const [withFilter, withoutFilter] = (await Promise.all([
  service.search(buildInput({ include_aliases: true, limit: 200 })),
  service.search(buildInput({ include_aliases: false, limit: 200 })),
])) satisfies [SearchResponse, SearchResponse];
```

Assertion helpers for repetitive shape checks live at the top of the spec file itself (not `__setup__/`), with explicit return types:

```typescript
function isAbsent(value: unknown): value is null | undefined {
  return null === value || undefined === value;
}

function expectStringOrAbsent(value: unknown): void {
  expect(isAbsent(value) || "string" === typeof value).toBe(true);
}
```

## Flaky upstreams

- Tag flaky tests `@flaky` in the description and exclude them from CI — a red build nobody trusts is worse than a known gap.
- Don't put retry logic inside an `it()`.
- `jest.retryTimes(2)` at `describe` level is acceptable for a known-unstable endpoint, with a comment saying which one and why.

## Checklist (`.contract-spec.ts` only)

- [ ] `.contract-spec.ts` suffix.
- [ ] `beforeAll`/`afterAll`, single cached API call.
- [ ] `API_TIMEOUT` on every live-call `it()` and `beforeAll`.
- [ ] No mocks on the service under test.
- [ ] Fixture is stable and documents how to re-verify.
- [ ] Assertion helpers have explicit return types.
- [ ] `npm run test:contract && npm run lint && npm run typecheck` pass.
