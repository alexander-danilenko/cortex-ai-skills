# TypeScript Documentation

Uses Microsoft Code Documentation style (TSDoc-aligned). **Documentation describes the contract — what something does and why — not how it's implemented internally.** Implementation details (algorithms, internal caching, side effects) belong in inline `//` comments inside the body, never in the doc comment.

When Context7 MCP is available, query `websites/tsdoc` for up-to-date TSDoc tag reference and syntax rules.

**Do not use `@example` blocks.**

## Bare Minimum — Do Not Restate the Signature

The signature already tells the reader the symbol's name, parameter names, parameter types, return type, and modifiers (`readonly`, `?`, `async`). Documentation must add what the reader **cannot** infer from that — semantic intent, units, ranges, defaults, edge-value meaning, error cases, invariants, the "why" of the API's existence.

Every public member still gets a brief summary so generated docs and IDE tooltips have content — but keep it to one short sentence that adds intent, never one that paraphrases the signature. For `@param` and `@returns`, drop the tag entirely when it would only restate the signature; the summary plus the type are enough.

Use third-person descriptive voice in summaries — "Calculates…", "Finds…", "Returns…" — to match the Microsoft API reference style. Save the imperative mood for inline `//` comments on procedural steps.

### Summary block

The free-text body before any `@`-tag carries **intent, not restatement**. Do not paraphrase the symbol's name, list its parameters, or describe the shape of its return — those are already visible. Write what the reader cannot infer.

```typescript
// WRONG — every word is already in the signature.
/**
 * Calculates the total cost from items and a tax rate, and returns a number.
 */
function calculateTotal(items: Item[], taxRate: number): number;

// CORRECT — adds semantics the signature cannot express.
/**
 * Applies tax once at the order level and rounds to two decimals so totals
 * reconcile with the invoicing system.
 */
function calculateTotal(items: Item[], taxRate: number): number;
```

```typescript
// WRONG — the name and type already say "user's email".
/**
 * The user's email address as a string.
 */
email: string;

// CORRECT — adds the constraint that isn't in the type.
/**
 * Unique across the system; lookups are case-insensitive.
 */
email: string;
```

When a property name plus its type really do say everything, write the shortest line that adds intent — a usage hint, a constraint, the role the value plays — rather than dropping the comment.

### `@param`, `@returns`

Include a `@param` or `@returns` **only when it adds information the signature does not already carry** — units, ranges, defaults, the meaning of edge values (e.g. "0 disables the cap"), or the meaning of `null` / empty results. If the parameter name and type already make the contract obvious, drop the tag.

`@throws` is the opposite default: include it whenever a function can throw, because the throw set is invisible from the signature.

```typescript
// WRONG — every tag restates the type.
/**
 * Finds a user by ID.
 *
 * @param id - The user's ID, as a string.
 * @returns The user as a `User` object, or `null`.
 */
function findById(id: string): Promise<User | null>;

// CORRECT — only the non-obvious bit is documented.
/**
 * Finds a user by ID.
 *
 * @returns `null` when no user matches; never rejects on missing.
 */
function findById(id: string): Promise<User | null>;
```

```typescript
// CORRECT — `@param` earns its keep by adding units and clamping behaviour.
/**
 * Computes the next backoff delay.
 *
 * @param attempt - Zero-based; values above 10 are clamped.
 * @returns Delay in milliseconds, capped at 30 s.
 */
function nextDelay(attempt: number): number;
```

A `@param` is worth writing when it answers at least one of:

- What unit is this in? (ms, bytes, decimal fraction, …)
- What range or clamp applies?
- What default is used when the argument is omitted?
- What does an edge value mean? (`0` disables, `-1` = unlimited, empty array = "all", …)
- What does a `null` / empty return signify, versus an exception?

If none of those apply, the tag is noise.

**Interfaces are not an exception to this rule.** Interface methods still need `@throws` and any return-semantics note (e.g. "`null` means not found"), but a `@param id - User's unique identifier.` adds nothing over `id: string` and should be dropped.

## Formatting Rules

Every `/**` comment block places its body on a new line. One-line doc comments are not allowed because they become hard to extend and visually inconsistent.

```typescript
// WRONG — one-line doc comment
/** Unique user identifier. */
id: string;

// CORRECT — body on new line
/**
 * Unique user identifier.
 */
id: string;
```

TSDoc has two tag syntaxes. **Block tags** (`@param`, `@returns`, `@throws`, `@remarks`, `@inheritDoc`, etc.) start their own line and never use curly braces. **Inline tags** (`{@link}`) appear inside running text and require curly braces. Writing `{@param}` with braces is invalid.

**Project convention:** `@inheritDoc` is written as a bare block tag without curly braces and without a declaration reference — always `@inheritDoc` alone, never `{@inheritDoc}` or `{@inheritDoc Foo.bar}`. This diverges from the strict TSDoc spec but keeps the form consistent with other block tags in the codebase.

## Inline Implementation Comments

Doc comments (`/** */`) describe the **contract** — what something does and why, for the consumer. Inline `//` comments inside a function or method body briefly explain **how** a non-trivial block works, so both human and AI readers can grasp the key idea at a glance.

Use them sparingly — only when the block is genuinely complex enough that a reader would otherwise have to puzzle out the intent line-by-line. Keep each comment short; one line is ideal.

```typescript
// CORRECT — doc comment describes the contract; inline comment summarises
// how the body achieves it.
/**
 * Computes the next backoff delay in milliseconds.
 *
 * @param attempt - Zero-based retry attempt number.
 */
function nextDelay(attempt: number): number {
  // Full jitter: cap exponential growth at 30 s, then pick a random point
  // in [0, cap] to spread retries across clients.
  const cap = Math.min(30_000, 1_000 * 2 ** attempt);
  return Math.floor(Math.random() * cap);
}

// WRONG — implementation detail leaked into the doc comment
/**
 * Computes the next backoff delay using full jitter, capping the
 * exponential at 30 s and seeding from Math.random.
 */
```

## Release Tags

Tags like `@public`, `@beta`, `@alpha`, `@internal` are omitted by default. Only include them when the user explicitly requests release-stage annotations.

## Interface Documentation

Interfaces represent abstractions — the _contract_, not the machinery behind it. Document what the consumer needs to know: purpose, parameters, return values, and thrown errors. Never describe implementation details such as internal caching strategies, database queries, retry logic, or algorithmic choices. Those belong in the implementation.

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
```

The `@param` lines that used to live on `create` and `findById` only echoed the parameter names and types — they're gone. `@throws` stays because exceptions are invisible from the signature, and the `@returns` on `findById` stays because "`null` means not found" is a contract detail the type alone cannot express.

## Interface Property Documentation

```typescript
/**
 * Data transfer object for user creation.
 */
interface CreateUserDto {
  /**
   * Unique across the system; lookups are case-insensitive.
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

Each property gets a single short line. `email` notes the uniqueness constraint the type can't carry. `name` adds where the value is used — not the fact that it's a string. `phone` records the format requirement; the `?` already conveys "optional", so the comment doesn't repeat it.

## Implementation Documentation — `@inheritDoc` and DRY

When a class implements an interface, do not repeat documentation that already exists on the interface. The implementation doc starts with `@inheritDoc` on the first line, followed by a blank line, and then only implementation-specific details that a maintainer of this class would need — expressed exclusively through TSDoc block tags such as `@remarks` or `@see`.

**Untagged prose after `@inheritDoc` overrides the inherited description** rather than supplementing it, because TSDoc treats the free-text portion of a comment as the summary. Any note that would otherwise live as a bare paragraph must be placed inside a tag block — most commonly `@remarks` — so the inherited summary is preserved and the implementation note is additive.

**Form:** write the tag bare — no curly braces, no declaration reference. The tag always inherits from the parent declaration automatically, so references like `@inheritDoc IUserService.create` are never needed and must not be used.

```typescript
// WRONG — curly braces
/**
 * {@inheritDoc}
 */

// WRONG — declaration reference
/**
 * @inheritDoc IUserService.create
 */

// CORRECT — bare tag, no arguments
/**
 * @inheritDoc
 */
```

Always use the multi-line form, even when the comment is only `@inheritDoc`. One-line `/** @inheritDoc */` is not allowed — this keeps the form consistent with every other doc comment in the codebase:

```typescript
// WRONG — one-line doc comment
/** @inheritDoc */

// CORRECT — body on a new line
/**
 * @inheritDoc
 */
```

If there _are_ implementation notes to add, place them after a blank line inside a TSDoc tag block — never as a bare paragraph. Reach for `@remarks` only when truly necessary (see the `@remarks` section below):

```typescript
class UserService implements IUserService {
  /**
   * @inheritDoc
   *
   * @remarks
   * - The bcrypt cost factor is pinned at 12 to satisfy the SOC 2
   *   control; lowering it will fail the next audit.
   */
  async create(data: CreateUserDto): Promise<User> {
    // ...
  }

  /**
   * @inheritDoc
   */
  async findById(id: string): Promise<User | null> {
    // ...
  }
}
```

Untagged prose below `@inheritDoc` silently replaces the inherited summary, so the following is incorrect even though it looks reasonable:

```typescript
// WRONG — untagged prose overrides the inherited description
/**
 * @inheritDoc
 *
 * Some documentation clarification.
 */

// CORRECT — clarification lives inside a TSDoc tag block
/**
 * @inheritDoc
 *
 * @remarks
 * - Any other documentation clarification.
 */
```

Key points:

- `@inheritDoc` is always bare: no braces, no reference.
- `@inheritDoc` must be the first line of the comment body.
- A blank line separates `@inheritDoc` from any additional notes.
- Any additional notes must live inside a TSDoc tag block (`@remarks` or `@see`). Untagged prose overrides the inherited summary instead of supplementing it.
- Only add notes specific to _this_ implementation when the constraint is genuinely non-obvious — never restate the contract.
- Do not re-state parameter descriptions, return types, or thrown errors already documented on the interface.

## Function Documentation

Standalone functions document their contract — what + why — never the implementation, and never information the signature already conveys. Keep the summary focused on intent; reach for `@param` / `@returns` only when they add something the types cannot.

```typescript
/**
 * Applies tax once at the order level and rounds to two decimals so totals
 * reconcile with the invoicing system.
 *
 * @param taxRate - Decimal fraction; `0.08` represents 8 %. Defaults to `0`.
 * @throws {Error} If `taxRate` is negative or `items` is empty.
 */
function calculateTotal(items: Item[], taxRate = 0): number {
```

`items` has no `@param` — the name and `Item[]` type are self-explanatory. `taxRate` keeps one because the unit (decimal fraction, not percent) and the default behaviour are not visible from `taxRate = 0`. `@returns` is omitted; the summary already states that the function produces the tax-inclusive total.

## Class Documentation

Describe the contract of the class — what it represents and why it exists — not how it works internally.

```typescript
/**
 * Connection pool with automatic health checks.
 */
class ConnectionPool {
  /**
   * Initializes a new pool. Health checks start on first acquire.
   */
  constructor(private readonly config: PoolConfig) {}
}
```

The class summary earns its keep by adding "automatic health checks" — a behaviour the class name alone doesn't reveal. The constructor summary is brief, follows the Microsoft "Initializes a new …" convention, and adds the non-obvious timing of when health checks begin.

## Simple Mappers and Delegators

When a **class method or standalone function** is a simple mapper or merely delegates to another function or service, a single-line summary is enough — but always include that one line so generated docs and IDE tooltips have something to show. Do not add `@param`/`@returns` to pad out a trivial signature; redundancy is worse than a missing tag.

**Interface methods still document genuine contract details** — `@throws`, return-semantics notes (e.g. "`null` if not found") — because the interface is the consumer-facing boundary. They do not, however, need `@param` lines that only restate names and types.

```typescript
// CORRECT — interface method: only the non-obvious return semantics is documented.
interface IUserRepository {
  /**
   * Finds a user by ID.
   *
   * @returns The user, or `null` if not found.
   */
  findById(id: string): Promise<User | null>;
}

// CORRECT — class method that simply delegates: `@inheritDoc` is enough.
class UserRepository implements IUserRepository {
  /**
   * @inheritDoc
   */
  findById(id: string): Promise<User | null> {
    return this.db.users.findUnique({ where: { id } });
  }
}

// CORRECT — standalone delegator: one short summary line, no tag padding.
/**
 * Formats a user's first and last name into a single display string.
 */
const formatName = (u: User): string => formatPersonName(u.first, u.last);

// WRONG — needlessly re-documents every parameter for a trivial delegator.
/**
 * Formats a user's display name.
 *
 * @param u - The user whose name to format.
 * @returns The formatted display name.
 */
const formatNameVerbose = (u: User): string =>
  formatPersonName(u.first, u.last);
```

## Generic Types

A single-letter type parameter named alongside an obvious carrier (`T` in `Box<T>`, `K`/`V` in a map) is self-explanatory; `@template` only earns its keep when the relationship between multiple type parameters isn't obvious from the signature.

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

  /**
   * Maximum number of items per page.
   */
  limit: number;
}
```

`@template T - Type of items in the data array.` would only restate what `data: T[]` already shows; it's gone. Each property gets a short line that adds the piece the type cannot carry — "current page" versus "all pages", "zero-based" versus "one-based", "maximum" versus "actual" — not a paraphrase of its name.

## `@remarks` — Use Sparingly

`@remarks` is **not** a must-have. Avoid it unless absolutely necessary. It is the **only** way to flag that an implementation behaves in a tricky or non-obvious way and to describe the **why** behind that behaviour — never the how. If a reader could reasonably infer the same information from the signature, the summary, or the code itself, omit `@remarks` entirely.

When you do use it, the body is **always a markdown bullet list** — even if there is only one point. This keeps the form consistent so additional points can be added later without restructuring, and makes it visually obvious which parts of a docblock are remarks. When a bullet wraps to a new line, indent the continuation to align with the text after the dash.

```typescript
/**
 * Rate limiter for outbound API calls.
 *
 * @remarks
 * - The upstream provider enforces a 100 req/s hard cap with no burst
 *   allowance. Exceeding it results in a 24-hour ban, so the limiter is
 *   intentionally pinned at 80 req/s to stay safely under the cap.
 */
class ApiRateLimiter {
```

```typescript
/**
 * Session token used for short-lived authentication.
 *
 * @remarks
 * - The 15-minute lifetime is mandated by the security review; do not
 *   extend it without re-approval.
 */
interface SessionToken {
```

```typescript
// WRONG — @remarks body written as a bare paragraph
/**
 * Session token used for short-lived authentication.
 *
 * @remarks
 * The 15-minute lifetime is mandated by the security review.
 */

// WRONG — implementation details do not belong in @remarks
/**
 * Fetches user preferences.
 *
 * @remarks
 * - Uses a Redis LRU cache with a 5-minute TTL, falling back to a
 *   PostgreSQL query via the read replica.
 */
```

## Quick Reference

| Tag | Purpose | Example |
| --- | --- | --- |
| `@param` | Parameter description | `@param name - User's name.` |
| `@returns` | Return value | `@returns The user object.` |
| `@throws` | Exception thrown | `@throws {Error} If invalid.` |
| `@remarks` | Tricky "why", use sparingly | Always a bullet list, even with one item |
| `@see` | URLs and cross-references | `@see https://example.com` |
| `@deprecated` | Mark deprecated | `@deprecated Use v2 instead.` |
| `@template` | Generic type param | `@template T - Item type.` |
| `@readonly` | Read-only property | Cannot modify |
| `@inheritDoc` | Inherit interface docs | `@inheritDoc` (bare, no braces, no reference) |
| `{@link}` | Symbol cross-link, use sparingly | `{@link IUserService}` |

## `{@link}` Usage

Use `{@link Something}` **sparingly — only when absolutely necessary.** Most cross-references read fine as plain text and clutter quickly when every type name becomes a link. Reserve `{@link}` for cases where the relationship is genuinely non-obvious from the surrounding prose.

```typescript
/**
 * Default implementation of {@link IUserService}.
 */
class UserService implements IUserService {
```

**URLs always go in `@see`, never in `{@link}`.** `@see` is the dedicated tag for external references, and tooling renders it more reliably than an inline URL link.

```typescript
/**
 * Validates input against a Zod schema.
 *
 * @see https://zod.dev/
 */
function validate(input: unknown): Result {
```

## When a `@param` Earns Its Keep

Each of these adds information the signature cannot carry on its own, so the tag is worth writing:

```typescript
// Default value behaviour — invisible from `options?: Options`.
/**
 * @param options - Defaults to `DEFAULT_OPTIONS` when omitted.
 */

// Unit / range — invisible from `limit: number`.
/**
 * @param limit - Items per page; 1-100, defaults to 10.
 */

// Edge-value semantics — invisible from `timeout: number`.
/**
 * @param timeout - Milliseconds before aborting; `0` disables the timeout.
 */
```

Callback type aliases also get a short summary, but make it carry something the shape cannot — most often the polarity of a boolean return, the call frequency, or a purity guarantee. A line like "Predicate for filtering items." restates `(item: T) => boolean` and adds nothing.

```typescript
// CORRECT — minimal alias doc: polarity, which the type can't express.
/**
 * Returns `true` to keep the item.
 */
type FilterFn<T> = (item: T) => boolean;

// CORRECT — alias with a non-obvious calling contract; add the why.
/**
 * Returns `true` to keep the item. Called once per element per render pass.
 */
type FilterFn<T> = (item: T) => boolean;
```
