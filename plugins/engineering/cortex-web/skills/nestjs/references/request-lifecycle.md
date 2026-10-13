# Request lifecycle

Execution order, enhancer selection, and the response boundary.

## Execution order

```text
request
  → middleware            global, then module-bound, in binding order
  → guards                global → controller → route
  → interceptors (pre)    global → controller → route
  → pipes                 global → controller → route → parameter
  → handler → service
  → interceptors (post)   route → controller → global   (reversed)
  → filters               route → controller → global   (only on an uncaught throw)
  → response
```

Three of these invert the intuition and are worth checking in review:

- **Filters resolve from the lowest level up.** A route-scoped filter wins over a controller-scoped one, which wins over the global one — the opposite of guards and pipes. A catch-all filter must be declared **before** type-specific filters for both to work.
- **Interceptors unwind first-in-last-out.** The global interceptor runs first on the way in and last on the way out, so an envelope interceptor wraps whatever a route interceptor produced, not the other way round.
- **Parameter-level pipes run last parameter to first.** Never let one parameter's pipe depend on another's having already run.

On Nest 11, global middleware runs before module-bound middleware regardless of where the module sits in the dependency graph.

Filters only fire on an exception that escapes the handler. A `try/catch` in a controller that reshapes the response splits the contract across two places, and only one of them gets updated.

## Choosing the primitive

Guards decide access, interceptors shape the request/response cycle, pipes transform and validate input, filters map exceptions to responses. A guard doing transformation runs at the wrong point in the lifecycle and won't see what it expects.

- **Bind by class, not instance** (`@UseGuards(RolesGuard)`), so the framework constructs it and DI works. Pass an instance only when you need constructor options.
- Pipes run inside the exceptions zone, so a throw from `transform()` is handled by the filter chain like any other.
- An interceptor's route handler does not execute until `handle()` is called. Returning `of(cached)` instead short-circuits the handler entirely — that is how caching and feature-flag interceptors work.
- `timeout(ms)` piped onto `handle()` cancels processing and throws `RequestTimeoutException`; add cleanup before the throw if the handler holds resources.

## Reading metadata

- `Reflector.createDecorator<T>()` gives a typed decorator and typed reads; `SetMetadata` still works but carries no type.
- `getAllAndOverride()` when the handler should be able to override the controller (roles, public routes). `getAllAndMerge()` when both levels contribute. Plain `get()` only when a single level is meaningful.
- On Nest 11, `getAllAndOverride()` returns `T | undefined` — handle the absent case rather than asserting.
- `host.getType()` and `host.switchToHttp()` are what make a guard or filter reusable across HTTP, RPC, and GraphQL. Prefer them to `getArgByIndex()`.

## Custom decorators

- `createParamDecorator((data, ctx) => …)` for extracting from the request. Compose whole cross-cutting concerns — metadata plus guards plus Swagger — into one decorator with `applyDecorators()`. `@ApiHideProperty()` is the known exception: it is not composable.
- **`ValidationPipe` ignores custom param decorators unless `validateCustomDecorators: true`.** A `@CurrentUser()` value therefore reaches the handler unvalidated by default.

## Middleware

- Middleware is registered in `configure(consumer)`, never in `providers`. Functional middleware and anything passed to `app.use()` get no DI; a class-based middleware bound through `MiddlewareConsumer` does.
- `exclude()` removes routes even when `forRoutes()` names a controller.
- Express registers `json` and `urlencoded` body parsers by default. Replacing them means `bodyParser: false` at `NestFactory.create()` — which also disables the `rawBody` feature below.
- Security middleware is order-sensitive: `helmet` must be applied before any other `app.use()` or setup call that itself calls `app.use()`, or the routes registered earlier go unprotected. On Fastify it is a plugin (`app.register(helmet)`), not middleware.

## The response boundary

- **`@Res()` opts the handler out of the framework's response handling.** `@HttpCode()`, `@Header()`, serialization, and every response interceptor stop applying. Use `@Res({ passthrough: true })` when you only need to set a cookie or header and still want Nest to send the body.
- Default status is 200, except `@Post` which is 201. Handlers may return a value, a `Promise`, or an `Observable` — all three are resolved for you.
- **Return a `StreamableFile` rather than piping into `@Res()`.** Piping skips the post-handler interceptors; `StreamableFile` keeps them and behaves the same on Express and Fastify. It is HTTP-only, and `ClassSerializerInterceptor` does not apply to it.
- **Webhook signature checks need the unparsed body**: create the app with `{ rawBody: true }` and read `req.rawBody` through `RawBodyRequest<Request>`. It requires the built-in body parser, so it is incompatible with `bodyParser: false`. Default limits are 100 kb (Express) and 1 MiB (Fastify).
- **Wrap the response envelope in one decorator** instead of hand-writing `allOf` / `$ref` per route. When an interceptor wraps every response in `{ status, data }`, one house `@ApiSuccessResponse(Dto)` keeps the generated client and the actual payload in step; per-route schemas drift the moment the envelope changes.

## Versioning

`app.enableVersioning()` supports URI, header, media-type, and custom extractors. Two facts decide most bugs:

- **A controller or route with no version returns 404 once versioning is on** — there is no unversioned fallback. Set `defaultVersion`, or mark the route `VERSION_NEUTRAL` so it answers with or without a version.
- Route-level version overrides controller-level. The URI version sits after the global prefix and before controller paths.

## Fastify and hybrid apps

- Under `FastifyAdapter`, middleware receives the **raw** `req`/`res`, not Fastify's wrappers; redirects need `res.status(302).redirect(url)`; sub-domain routing (`@Controller({ host })`) is unsupported — stay on Express if you need it. Any Express-specific recipe should be assumed broken until checked.
- In a hybrid app, `connectMicroservice()` does **not** inherit the HTTP app's global pipes, guards, interceptors, or filters. Pass `{ inheritAppConfig: true }`, or the transport layer silently runs unvalidated and unguarded.
