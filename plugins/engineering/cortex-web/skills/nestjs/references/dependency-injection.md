# Dependency injection

Wiring, tokens, scopes, and the lifecycle the container runs.

## Wiring

- **A directory of providers exports them as an array from its own `all.ts`**, and the module spreads it. Adding a provider is then a new file plus one line inside that directory, and the module file stops being the merge conflict every branch touches.

  ```ts
  // command/all.ts
  export const allCommandHandlers: Provider[] = [
    CancelShipmentHandler,
    ReprintLabelHandler,
  ];

  // shipment.module.ts
  providers: [ShipmentService, ...allCommandHandlers];
  ```

- **Interchangeable implementations register under a string DI key** — `{module}.{role}.{discriminator}` — and a facade resolves one with `ModuleRef.get(token, { strict: false })`. Adding an implementation is a new file plus one registration; the resolver never learns its name and there is no lookup table to keep in sync. Convert the resolution failure into a domain exception at that boundary, so an unserved case reads as "we don't cover that" instead of as a DI crash.

  ```ts
  export const carrierToken = (carrier: Carrier): string =>
    `shipment.carrier.${carrier}`;

  // in the facade
  try {
    return this.moduleRef.get<CarrierAdapterInterface>(carrierToken(carrier), {
      strict: false,
    });
  } catch {
    throw new CarrierUnsupportedException(carrier);
  }
  ```

- **Inject by class token, type by interface**: `@Inject(RateService) private readonly rates: RateServiceInterface`. Nest still resolves the concrete provider, while the consumer's compile-time surface is the contract alone — so a test substitutes a plain object, and refactoring the service's internals can't break a caller.
- **Put the invariant in an abstract base and leave only the variation abstract.** A public method that validates and then calls a `protected abstract` step means no subclass can reach the outside world before its input was checked, however many subclasses get added later.

  ```ts
  public async quote(request: QuoteRequest): Promise<Quote[]> {
    await this.validate(request)
    return await this.fetchRates(request) // protected abstract — the only part a subclass writes
  }
  ```

## Custom providers

- `useValue` for a constant or a pre-built instance, `useClass` to swap implementation by condition, `useFactory` when construction needs other providers, `useExisting` to alias a second token onto the same instance.
- **`inject` is positional**: entries map to factory parameters in order. An entry can be `{ token, optional: true }`, and an unresolved optional dependency arrives as `undefined` — handle it rather than assuming.
- **A non-class token needs `@Inject()` at every consumer.** Strings and symbols carry no design-time type metadata, so the container has nothing to infer from.
- **An async `useFactory` blocks bootstrap until it resolves.** Nothing that injects the token is constructed and no request is served until the promise settles — that is the point (a connection is ready or the app never starts), but a slow or hanging factory is an app that never boots rather than one that boots degraded.
- Export a custom provider by its token, or by the whole provider object, in `exports`.

## Injection scopes

- **`Scope.REQUEST` bubbles up the injection chain.** One request-scoped service quietly turns every consumer above it — including the controller — into per-request instantiation. `Scope.TRANSIENT` does not bubble: a singleton injecting a transient provider simply gets its own copy.
- **Singleton is the default and the right answer almost always.** The docs put a well-designed request-scoped tree at roughly 5% latency cost, which is the ceiling, not the floor — the real cost is that request scope is contagious.
- **Some places forbid it outright**: WebSocket gateways must be singletons, and `@OnEvent` listeners cannot be request-scoped. A circular dependency combined with `Scope.REQUEST` yields `undefined` dependencies rather than an error.
- **Durable providers** (`{ scope: Scope.REQUEST, durable: true }` plus a `ContextIdStrategy`) let a multi-tenant app reuse one DI sub-tree per tenant instead of per request. The docs warn this is unsuitable for a large number of tenants — each distinct context id keeps a sub-tree alive.
- The `REQUEST` provider (or `CONTEXT` under GraphQL) is inherently request-scoped and can't be given an explicit scope.

## ModuleRef

- **`get()` returns singletons only; scoped providers need `resolve()`.** `resolve()` creates a fresh DI sub-tree per call, so two calls return two different instances unless you pass the same context id.
- `ContextIdFactory.create()` mints a context id you can reuse across `resolve()` calls to share a sub-tree; `ContextIdFactory.getByRequest(req)` derives the one an in-flight request is using.
- A manually created context id has **no `REQUEST` provider** — it resolves to `undefined` until you call `moduleRef.registerRequestByContextId()`.
- `moduleRef.create(SomeClass)` instantiates a class that was never registered as a provider, for genuinely runtime-conditional construction.

## Global enhancers and DI

`app.useGlobalPipes()`, `useGlobalGuards()`, `useGlobalInterceptors()`, and `useGlobalFilters()` bind **outside any module context**, so those instances get no injection at all. Register through the `APP_PIPE` / `APP_GUARD` / `APP_INTERCEPTOR` / `APP_FILTER` tokens in a module's `providers` instead, and the enhancer becomes an ordinary injectable.

Two consequences worth knowing before you debug them:

- To override a globally registered enhancer in a test, declare it as `{ provide: APP_GUARD, useExisting: RolesGuard }` with `RolesGuard` also in `providers`. With `useClass`, `overrideProvider(RolesGuard)` has nothing to bind to and the real guard keeps running.
- `useGlobalFilters()` does not apply to gateways or to hybrid applications.

## Circular dependencies

Prefer a port and an adapter. The module that needs the behaviour declares the interface it wants plus a `Symbol` token in a `port/` directory; the module that has the behaviour implements it in an `adapter/` directory. Both now depend on the token rather than on each other, so there is no cycle left to defer — and a second source of the same behaviour is just a second adapter bound to the same token.

`forwardRef` only makes the cycle compile; every ordering hazard survives. If you inherit one, know the rules: it must be applied on **both** sides (provider and provider, or module and module), instantiation order is explicitly indeterminate, and `ModuleRef` on one side removes the need for it entirely.

## Lifecycle hooks

Initialization runs `onModuleInit` → `onApplicationBootstrap`, in module import order, awaiting each hook. Termination runs `onModuleDestroy` → `beforeApplicationShutdown` → `onApplicationShutdown`; on Nest 11 these fire in **reverse** initialization order.

- Init hooks only fire if you call `app.init()` or `app.listen()`. Termination hooks only fire on `app.close()` or a signal — and signals require `app.enableShutdownHooks()`.
- **`app.close()` does not exit the process.** It runs the hooks and closes connections; an open interval or a long-running task keeps Node alive. Clear them in `onModuleDestroy`.
- `enableShutdownHooks()` attaches process listeners. Running many Nest apps in one process (parallel Jest suites) trips Node's max-listeners warning.
- Use `onModuleInit` for work that only needs this module's own dependencies, and `onApplicationBootstrap` for anything that assumes the whole graph exists — emitting an event, warming a cache, connecting a `ClientProxy`.
