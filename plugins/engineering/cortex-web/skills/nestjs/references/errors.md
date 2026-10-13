# Errors

One base class and one filter make every domain error catchable by name and readable by a client.

```ts
export class DomainException extends Error {
  public status: number = HttpStatus.INTERNAL_SERVER_ERROR;
  public type: string = "internal"; // `{module}.{reason}` — the stable code clients branch on
  public details: Record<string, unknown> = {};
}
```

## Conventions

- **Each module owns its exceptions** (`exception/shipment-already-dispatched.exception.ts`), setting `status`, a dot-namespaced `type`, and non-PII `details`. The `type` is what a client branches on: an HTTP status alone can't tell "already dispatched" from "carrier rejected the address".
- **One global `@Catch` filter renders them.** A controller that catches its own exception to reshape the response splits the contract across two places, and only one of them gets updated.
- **Framework exceptions are fine where nothing needs to branch** (`NotFoundException`, `ConflictException`). A bare `Error` is not — it becomes a 500, so a legitimate "not found" pages someone.
- **Messages are declarative third-person statements of fact**, sentence case, ending with a period, stating the condition and not the remedy: "The shipment has already been dispatched." Compose them from a fixed base sentence plus an appended detail clause rather than authoring a fresh sentence per call site, and interpolate only non-PII tokens — the message lands in logs, in an error tracker, and sometimes in front of a user.

## Filter mechanics

- **Filters resolve from the lowest scope up**: route, then controller, then global — the reverse of guards and pipes. A route-scoped filter shadows the global one for that handler.
- `@Catch()` with no arguments catches everything. Declare a catch-all **before** type-specific filters, or the specific ones never see their exception.
- **Register the global filter with `APP_FILTER`, not `app.useGlobalFilters()`**, whenever it needs to inject anything (a logger, a config service). The `useGlobalFilters` instance is constructed outside any module and gets no DI. It also does not apply to gateways or hybrid applications.
- Extending `BaseExceptionFilter` to delegate unknown errors is fine, with one caveat: a method- or controller-scoped subclass must be bound **by class** so the framework instantiates it. Only a global one may be `new`-ed, and then it needs the HTTP adapter passed in.
- In a platform-agnostic filter, resolve `HttpAdapterHost` inside `catch()` rather than in the constructor — the adapter may not exist yet at construction time.
