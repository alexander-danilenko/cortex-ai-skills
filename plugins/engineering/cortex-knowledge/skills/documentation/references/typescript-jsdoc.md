# TypeScript Documentation

Uses Microsoft contract-first conventions (TSDoc-aligned). **A doc comment states the contract — what something does and why — never how it is implemented.** Implementation detail (algorithms, caching, side effects) goes in inline `//` comments in the body, not in the doc comment.

When Context7 MCP is available, query `websites/tsdoc` for the up-to-date tag reference.

**Do not use `@example` blocks.** Tooling does not execute them, so they drift out of sync with the code and become misleading. Cover behaviour with the test suite instead, where examples stay honest because they run.

## Bare Minimum — Do Not Restate the Signature

The signature already carries the name, parameter names and types, return type, and modifiers (`readonly`, `?`, `async`). A doc comment adds only what the signature cannot: intent, units, ranges, defaults, edge-value meaning, error cases, invariants, the "why" of the API.

Every public member still gets a one-line summary so generated docs and IDE tooltips have content — but the summary adds intent, it never paraphrases the name. Use third-person voice ("Calculates…", "Finds…").

```typescript
// WRONG — every word is already in the signature.
/**
 * Calculates the total cost from items and a tax rate, and returns a number.
 */
function calculateTotal(items: Item[], taxRate: number): number;

// CORRECT — adds semantics the signature cannot express, on one line.
/**
 * Applies tax once at the order level, rounded to two decimals.
 *
 * The rounding matches the invoicing system, so totals reconcile with invoices.
 */
function calculateTotal(items: Item[], taxRate: number): number;
```

### `@param` and `@returns` — only when they add information

Include `@param`/`@returns` only when they carry something the signature cannot. A tag earns its keep when it answers one of:

- **Unit** — ms, bytes, a decimal fraction
- **Range / clamp** — "1-100", "values above 10 are clamped"
- **Default behaviour** — "defaults to `DEFAULT_OPTIONS` when omitted"
- **Edge-value meaning** — "`0` disables the timeout", "`-1` = unlimited", "empty array = all"
- **`null` / empty result meaning** — "`null` when no user matches; never rejects"

If none apply, drop the tag — a name-and-type echo is noise. `@throws` is the opposite default: include it whenever a function can throw, because the throw set is invisible from the signature.

```typescript
// WRONG — tags restate the types.
/**
 * Finds a user by ID.
 *
 * @param id - The user's ID, as a string.
 * @returns The user as a `User` object, or `null`.
 */
function findById(id: string): Promise<User | null>;

// CORRECT — summary plus the one non-obvious fact.
/**
 * Finds a user by ID.
 *
 * @returns `null` when no user matches. Never rejects on a miss.
 */
function findById(id: string): Promise<User | null>;
```

```typescript
// CORRECT — @param earns its keep: the unit, clamp, and cap are not in the types.
/**
 * Computes the next backoff delay.
 *
 * @param attempt - Zero-based. Values above 10 are clamped.
 * @returns Delay in milliseconds, capped at 30 s.
 */
function nextDelay(attempt: number): number;
```

This rule holds on interfaces too: an interface method keeps `@throws` and any return-semantics note, but `@param id - User's unique identifier.` adds nothing over `id: string` and is dropped.

## Formatting Rules

Every `/**` block puts its body on a new line; one-line `/** ... */` comments are not allowed, because they are hard to extend and visually inconsistent.

```typescript
// WRONG — one-line doc comment
/** Unique user identifier. */
id: string;

// CORRECT — body on a new line
/**
 * Stable for the entity's lifetime, so it is safe to use as a map key.
 */
id: string;
```

TSDoc has two tag syntaxes. **Block tags** (`@param`, `@returns`, `@throws`, `@remarks`, `@inheritDoc`) start their own line and take no braces. **Inline tags** (`{@link}`) sit inside running text and require braces. `{@param}` with braces is invalid.

### Length budget

The block opens with **one summary line**, and that line is what an IDE tooltip and a review diff show. Below it, after a blank line, an optional detail passage runs **three lines at most** and states only primary ideas. Everything past that — branch behaviour, edge cases, the reasoning behind a constraint — is `@remarks`.

The width is the project's, so measure after Prettier (or the project's formatter) has reflowed the block, counting the leading asterisk and its indent. A summary that comes back on two lines is over budget; cut words rather than accepting the wrap, and never let the overflow become a second sentence.

```typescript
// WRONG — the summary wraps, and the detail passage is really branch notes.
/**
 * Acquires a pooled connection, waiting for a free slot when the pool is
 * saturated, and reports pool pressure to the metrics sink.
 *
 * When the pool is empty the caller queues in FIFO order. When the queue is
 * also full the call rejects immediately. When a slot frees the oldest waiter
 * wins it. Health checks run against the connection before it is handed back,
 * and a failing connection is discarded and replaced.
 */

// CORRECT — one summary line, detail within three, branches demoted.
/**
 * Acquires a pooled connection, queueing when the pool is saturated.
 *
 * Waiters are served FIFO. Every connection is health-checked before it is
 * handed to the caller, so an acquire can outlast the pool's idle timeout.
 *
 * @remarks
 * - The queue itself is bounded: once it is full, acquire rejects rather than
 *   waiting, which keeps a stalled upstream from consuming the whole request
 *   pool.
 * - A connection that fails its health check is discarded and replaced, so a
 *   caller never observes the failed one.
 */
```

## Interfaces and Properties

An interface is the consumer-facing abstraction — document purpose, return semantics, and thrown errors; never implementation detail (caching, queries, retries, algorithms). Each property gets one short line that adds what the type cannot.

```typescript
/**
 * Service for managing user lifecycle operations.
 */
interface IUserService {
  /**
   * Creates a new user account.
   *
   * @throws {ValidationError} If required fields are missing or invalid.
   */
  create(data: CreateUserDto): Promise<User>;

  /**
   * Finds a user by their unique identifier.
   *
   * @returns The user, or `null` if not found.
   */
  findById(id: string): Promise<User | null>;
}

/**
 * Data transfer object for user creation.
 */
interface CreateUserDto {
  /**
   * Unique across the system, with case-insensitive lookups.
   */
  email: string;

  /**
   * Display name shown across the UI.
   */
  name: string;

  /**
   * Must be in E.164 format.
   */
  phone?: string;
}
```

The `@param` lines that only echoed names and types are gone. `@throws` stays (exceptions are invisible from the signature); `findById`'s `@returns` stays because "`null` means not found" is a contract detail the type can't carry. Each property adds the constraint, role, or format the type omits — never "the user's email as a string", and the `?` already conveys "optional".

## Data Shapes — WHAT, Not WHY

A DTO, value object, record, or any `interface`/`type` that exists to _hold_ data documents what each member **is** — meaning, units, format, allowed values, constraints the type can't carry. It does not justify **why** the field exists: a data field is read at the point of use, where design rationale rots and belongs instead with the behavior that produces or consumes the value.

```typescript
// WRONG — justifies why the field is stored.
/**
 * Kept so the billing service can reconcile invoices at month end.
 */
externalCustomerId: string;

// CORRECT — what the value is, plus the constraint the type can't carry.
/**
 * Stripe customer ID, stable for the account's lifetime.
 */
externalCustomerId: string;
```

The rare exception — a non-obvious constraint a maintainer must not break — is a sparing `@remarks`, not the default voice of a data shape.

## `@inheritDoc` and DRY

When a class implements an interface, do not repeat the interface's documentation. Start the implementation doc with a bare `@inheritDoc`, then add only implementation-specific notes.

- Write `@inheritDoc` **bare** — no braces, no declaration reference. It always inherits from the parent automatically, so `{@inheritDoc}` and `@inheritDoc IUserService.create` are both wrong.
- It is the **first line** of the body, in multi-line form even when it is the only content (one-line `/** @inheritDoc */` is not allowed).
- Any extra note goes **inside a tag block** (usually `@remarks`) after a blank line. Untagged prose after `@inheritDoc` silently **overrides** the inherited summary instead of supplementing it.

```typescript
class UserService implements IUserService {
  /**
   * @inheritDoc
   *
   * @remarks
   * - The bcrypt cost factor is pinned at 12 to satisfy the SOC 2 control.
   *   Lowering it fails the next audit.
   */
  async create(data: CreateUserDto): Promise<User> {
    // ...
  }

  /**
   * @inheritDoc
   */
  async findById(id: string): Promise<User | null> {
    return this.db.users.findUnique({ where: { id } });
  }
}
```

## Functions, Classes, and Delegators

Standalone functions and classes document their contract — what + why — never the implementation, and never what the signature already says. A class summary earns its keep by naming a behaviour the class name does not reveal.

```typescript
/**
 * Applies tax once at the order level, rounded to two decimals.
 *
 * @param taxRate - Decimal fraction, so `0.08` represents 8 %. Defaults to `0`.
 * @throws {Error} If `taxRate` is negative or `items` is empty.
 */
function calculateTotal(items: Item[], taxRate = 0): number {}

/**
 * Connection pool with automatic health checks.
 */
class ConnectionPool {
  /**
   * Initializes a new pool.
   *
   * Health checks start on the first acquire, not at construction.
   */
  constructor(private readonly config: PoolConfig) {}
}
```

`items` needs no `@param`; `taxRate` keeps one for the unit and default. The constructor's detail line adds the non-obvious timing of when health checks begin.

A simple mapper or delegator needs only its one-line summary — never `@param`/`@returns` padding for a trivial signature.

```typescript
// CORRECT — delegator: one short summary line, no tag padding.
/**
 * Formats a user's first and last name into a single display string.
 */
const formatName = (u: User): string => formatPersonName(u.first, u.last);
```

## Generic Types

A single-letter type parameter beside an obvious carrier (`T` in `Box<T>`, `K`/`V` in a map) is self-explanatory; `@template` only earns its keep when the relationship between several type parameters is not obvious. Each property gets a line that adds what the type omits — "zero-based", "across all pages" — not a paraphrase of its name.

```typescript
/**
 * Paginated response wrapper.
 */
interface PaginatedResponse<T> {
  /**
   * Items on the current page.
   */
  data: T[];

  /**
   * Total number of items across all pages.
   */
  total: number;

  /**
   * Zero-based current page index.
   */
  page: number;
}
```

A callback type alias gets a doc block that carries what the shape cannot — the polarity of a boolean return, the call frequency, a purity guarantee — not "Predicate for filtering items.", which just restates `(item: T) => boolean`.

```typescript
/**
 * Returns `true` to keep the item.
 *
 * Called once per element per render pass.
 */
type FilterFn<T> = (item: T) => boolean;
```

## `@remarks` — Use Sparingly

`@remarks` is not a must-have. Use it only to flag tricky or non-obvious behaviour and the **why** behind it — never the how, and never something a reader could infer from the signature, summary, or code. The body is **always a markdown bullet list**, even with one point, so points can be added later without restructuring; indent wrapped lines to align after the dash.

```typescript
/**
 * Rate limiter for outbound API calls.
 *
 * @remarks
 * - The upstream provider enforces a 100 req/s hard cap with no burst
 *   allowance. Exceeding it triggers a 24-hour ban, so the limiter is pinned
 *   at 80 req/s to stay safely under the cap.
 */
class ApiRateLimiter {}

// WRONG — bare paragraph, and an implementation detail that does not belong here.
/**
 * Fetches user preferences.
 *
 * @remarks
 * Uses a Redis LRU cache with a 5-minute TTL, falling back to Postgres.
 */
```

## Inline Implementation Comments

Inline `//` comments inside a body briefly explain **how** a non-trivial block works. Use them sparingly — only when a reader would otherwise have to puzzle out the intent line by line.

**One line is the target, three the ceiling**, measured after the formatter at the project's width. A comment that needs a fourth line is describing something the code should carry itself: extract a named helper or a named constant, and the comment shrinks with it.

```typescript
function nextDelay(attempt: number): number {
  // Full jitter: cap exponential growth at 30 s, then pick a random point
  // in [0, cap] to spread retries across clients.
  const cap = Math.min(30_000, 1_000 * 2 ** attempt);
  return Math.floor(Math.random() * cap);
}
```

## Release Tags

`@public`, `@beta`, `@alpha`, `@internal` are omitted by default; include them only when the user explicitly asks for release-stage annotations.

## `{@link}` and `@see`

Use `{@link Something}` **sparingly** — most cross-references read fine as plain text and clutter quickly when every type name becomes a link. Reserve it for genuinely non-obvious relationships. **URLs always go in `@see`**, never in `{@link}` — `@see` is the dedicated tag and tooling renders it more reliably.

```typescript
/**
 * Default implementation of {@link IUserService}.
 *
 * @see https://zod.dev/
 */
class UserService implements IUserService {}
```

## Quick Reference

| Tag | Purpose | Note |
| --- | --- | --- |
| `@param` | Parameter info | Only when it adds unit/range/default/edge meaning |
| `@returns` | Return info | Only when it adds meaning beyond the type |
| `@throws` | Exception thrown | Always, when a function can throw |
| `@remarks` | Tricky "why" | Sparingly; always a bullet list |
| `@see` | URLs / cross-refs | `@see https://example.com` |
| `@deprecated` | Mark deprecated | `@deprecated Use v2 instead.` |
| `@template` | Generic type param | Only when the relationship isn't obvious |
| `@inheritDoc` | Inherit interface docs | Bare — no braces, no reference |
| `{@link}` | Symbol cross-link | Sparingly; never for URLs |
