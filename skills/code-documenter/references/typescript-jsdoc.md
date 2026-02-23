# TypeScript Documentation

Uses Microsoft Code Documentation style (TSDoc-aligned). Documentation describes
the contract — what something does and why — not how it's implemented internally.

When Context7 MCP is available, query `websites/tsdoc` for up-to-date TSDoc tag
reference and syntax rules.

## Formatting Rules

Every `/**` comment block places its body on a new line. One-line doc comments
are not allowed because they become hard to extend and visually inconsistent.

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

## Release Tags

Tags like `@public`, `@beta`, `@alpha`, `@internal` are omitted by default.
Only include them when the user explicitly requests release-stage annotations.

## Interface Documentation

Interfaces represent abstractions — the *contract*, not the machinery behind it.
Document what the consumer needs to know: purpose, parameters, return values,
thrown errors, and usage examples. Never describe implementation details such as
internal caching strategies, database queries, retry logic, or algorithmic
choices. Those belong in the implementation.

```typescript
/**
 * Service for managing user lifecycle operations.
 *
 * @example
 * ```typescript
 * const user = await userService.create(userData);
 * ```
 */
interface IUserService {
  /**
   * Create a new user account.
   *
   * @param data - Required fields for account creation.
   * @returns The newly created user.
   * @throws {ValidationError} If required fields are missing or invalid.
   */
  create(data: CreateUserDto): Promise<User>;

  /**
   * Find a user by their unique identifier.
   *
   * @param id - User's unique identifier.
   * @returns The user, or `null` if not found.
   */
  findById(id: string): Promise<User | null>;
}
```

## Interface Property Documentation

```typescript
/**
 * Data transfer object for user creation.
 */
interface CreateUserDto {
  /**
   * User's email address.
   * Must be unique across the system.
   */
  email: string;

  /**
   * User's display name.
   */
  name: string;

  /**
   * Optional phone number in E.164 format.
   */
  phone?: string;
}
```

## Implementation Documentation — `@inheritDoc` and DRY

When a class implements an interface, do not repeat documentation that already
exists on the interface. The implementation doc starts with `{@inheritDoc}` on
the first line, followed by a blank line, and then only implementation-specific
details that a maintainer of this class would need.

**Important:** TSDoc does not allow a declaration reference inside `{@inheritDoc}`.
The tag always inherits from the parent declaration automatically.

```typescript
// WRONG — declaration reference is not valid TSDoc
/** 
 * {@inheritDoc IUserService.create} 
 */

// CORRECT — no arguments
/**
 * {@inheritDoc} 
 */
```

If there is nothing implementation-specific to add, `@inheritDoc` alone is
sufficient.

```typescript
class UserService implements IUserService {
  /**
   * {@inheritDoc}
   *
   * Validates the DTO with Zod before inserting into the `users` table.
   * Hashes the password with bcrypt (cost factor 12).
   */
  async create(data: CreateUserDto): Promise<User> {
    // ...
  }

  /**
   * {@inheritDoc}
   */
  async findById(id: string): Promise<User | null> {
    // ...
  }
}
```

Key points:
- `{@inheritDoc}` must be the first line of the comment body.
- A blank line separates `@inheritDoc` from any additional notes.
- Only add details specific to *this* implementation — algorithms, storage
  mechanisms, side effects not visible through the interface contract.
- Do not re-state parameter descriptions, return types, or thrown errors already
  documented on the interface.

## Function Documentation

Standalone functions (not implementing an interface) are documented fully.

```typescript
/**
 * Calculate total cost including tax.
 *
 * @param items - Line items to sum.
 * @param taxRate - Tax rate as a decimal (e.g., 0.08 for 8%).
 * @returns Total cost with tax applied.
 * @throws {Error} If taxRate is negative or items is empty.
 *
 * @example
 * ```typescript
 * const total = calculateTotal(items, 0.08);
 * console.log(total); // 108.00
 * ```
 */
function calculateTotal(items: Item[], taxRate = 0): number {
```

## Class Documentation

```typescript
/**
 * Connection pool with automatic health checks.
 *
 * @example
 * ```typescript
 * const pool = new ConnectionPool(config);
 * const conn = await pool.acquire();
 * ```
 */
class ConnectionPool {
  /**
   * Create a new pool instance.
   *
   * @param config - Pool configuration options.
   */
  constructor(private readonly config: PoolConfig) {}
}
```

## Generic Types

```typescript
/**
 * Paginated response wrapper.
 *
 * @template T - Type of items in the data array.
 */
interface PaginatedResponse<T> {
  /**
   * Items for the current page.
   */
  data: T[];

  /**
   * Total number of items across all pages.
   */
  total: number;

  /**
   * Current page number (1-indexed).
   */
  page: number;

  /**
   * Number of items per page.
   */
  limit: number;
}
```

## Async Functions

```typescript
/**
 * Fetch user by ID from the database.
 *
 * @param id - User's unique identifier.
 * @returns The user, or `null` if not found.
 * @throws {DatabaseError} If the connection fails.
 */
async function findUserById(id: string): Promise<User | null> {
```

## `@remarks` — Reasoning and Context

Use `@remarks` to explain **why** something exists or **what to keep in mind** —
design rationale, constraints, trade-offs, or historical context. It supplements
the summary with information a reader needs when they dig deeper.

`@remarks` is not for describing implementation logic. Details like which
algorithm is used, how data flows internally, or what side effects occur belong
in implementation comments or `{@inheritDoc}` notes — not in `@remarks`.

Remarks are formatted as markdown bullet points. When a bullet wraps to a new
line, indent the continuation to align with the text after the dash:

```typescript
/**
 * Determine whether a user account is considered active.
 *
 * @remarks
 * - Accounts are soft-deleted rather than removed, so "active" is the
 *   primary way to distinguish current users from former ones.
 * - The 90-day inactivity window was chosen to align with the
 *   data-retention policy (see compliance docs).
 *
 * @param user - The user to evaluate.
 * @returns `true` if the account is active.
 */
function isActiveUser(user: User): boolean {
```

```typescript
/**
 * Rate limiter for outbound API calls.
 *
 * @remarks
 * - The upstream provider enforces a 100 req/s hard cap with no burst
 *   allowance. Exceeding it results in a 24-hour ban.
 * - The limiter is intentionally conservative at 80 req/s to stay
 *   safely under the cap.
 */
class ApiRateLimiter {
```

```typescript
// WRONG — implementation details do not belong in @remarks
/**
 * Fetch user preferences.
 *
 * @remarks
 * - Uses a Redis LRU cache with a 5-minute TTL, falling back to a
 *   PostgreSQL query via the read replica.
 */
```

## Quick Reference

| Tag | Purpose | Example |
|-----|---------|---------|
| `@param` | Parameter description | `@param name - User's name.` |
| `@returns` | Return value | `@returns The user object.` |
| `@throws` | Exception thrown | `@throws {Error} If invalid.` |
| `@example` | Usage example | Code block |
| `@remarks` | Reasoning and context | Design rationale, constraints |
| `@see` | Cross-reference | `@see UserService` |
| `@deprecated` | Mark deprecated | `@deprecated Use v2 instead.` |
| `@template` | Generic type param | `@template T - Item type.` |
| `@readonly` | Read-only property | Cannot modify |
| `{@inheritDoc}` | Inherit interface docs | `{@inheritDoc}` (no arguments) |
| `{@link}` | Link to symbol or URL | `{@link IUserService}` |

## `{@link}` Usage

Link to a code symbol — rendered as a clickable reference by documentation tools:

```typescript
/**
 * Default implementation of {@link IUserService}.
 *
 * @see {@link CreateUserDto} for the expected input shape.
 */
class UserService implements IUserService {
```

Link to an external URL — use the pipe (`|`) separator for display text:

```typescript
/**
 * Validates input against the schema defined in
 * {@link https://zod.dev/ | Zod documentation}.
 */
function validate(input: unknown): Result {
```

## Common Patterns

```typescript
// Optional parameters
/**
 * @param options - Optional configuration.
 */

// Default values
/**
 * @param limit - Items per page (default: 10).
 */

// Callback parameters
/**
 * Predicate for filtering items.
 *
 * @param item - Item to evaluate.
 * @returns Whether the item passes the filter.
 */
type FilterFn<T> = (item: T) => boolean;
```
