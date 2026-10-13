# Ecosystem packages

Behaviour in the first-party packages that differs from what the API name suggests.

## `@nestjs/axios`

`HttpService` methods return an **`Observable<AxiosResponse>`**, not a promise. Wrap with `firstValueFrom` and pipe `catchError` before converting, so the failure is handled inside the stream:

```ts
const { data } = await firstValueFrom(
  this.http.get<Rate[]>(url).pipe(
    catchError((error: AxiosError) => {
      throw new CarrierUnavailableException(error.message);
    }),
  ),
);
```

`HttpModule` is not global — import it in each module that needs it. `httpService.axiosRef` reaches the underlying instance when the module options aren't enough.

## `@nestjs/event-emitter`

- **`@OnEvent` swallows listener errors by default** (`suppressErrors: true`). A failing listener disappears silently. Set `suppressErrors: false` on anything whose failure matters, and log inside the listener regardless.
- **Listeners cannot be request-scoped.**
- Events emitted before `onApplicationBootstrap` completes can be lost — gate the emit with `EventEmitterReadinessWatcher.waitUntilReady()`.
- Wildcards (`order.*`, `order.**`) need `EventEmitterModule.forRoot({ wildcard: true })`; the delimiter defaults to `.`.
- `emitAsync()` awaits listeners, which makes a listener part of the caller's latency and failure surface. If you need that coupling, a command handler is the more honest primitive.

## `@nestjs/bullmq`

- **There is no `@Process('jobName')`.** A `@Processor()` class extends `WorkerHost` and implements one `process(job)`; branch on `job.name` inside it. Register the class as a provider or it is never discovered.
- **A separate-process processor has no DI container.** Anything it needs must be constructed inside the processor file.
- Queues are shared by anything pointing at the same Redis database with the same credentials — including other environments, if the prefix is the same.
- Worker-level events use `@OnWorkerEvent()` inside the processor; queue-level events need a separate `@QueueEventsListener()` class.
- A request-scoped consumer is instantiated per job; reach the job through the `JOB_REF` token.

## `@nestjs/throttler`

- **`ttl` is milliseconds.** Use the `seconds()` / `minutes()` helpers rather than writing the number.
- **The default storage is per-process memory**, so behind more than one replica the effective limit is the configured limit times the replica count. Use the Redis storage adapter for a real limit.
- **Behind a proxy or load balancer, `req.ip` is the proxy.** Enable `trust proxy` on the adapter _and_ override `getTracker()` to read the forwarded header, or you rate-limit your ingress instead of your callers.
- Named throttlers let one route carry several windows (`@Throttle({ short: { … }, long: { … } })`); `@SkipThrottle({ default: false })` re-enables a single route inside a skipped controller.
- WebSockets and GraphQL need a subclass overriding `handleRequest()` / `getRequestResponse()`; the guard cannot be registered globally for gateways.

## `@nestjs/cache-manager`

- **`CacheInterceptor` caches `GET` only**, and does nothing on a handler using `@Res()`.
- **TTL is milliseconds, and the default `ttl: 0` means never expire** — not "don't cache".
- Method-level `@CacheKey` / `@CacheTTL` override controller-level.
- On Nest 11 the store is configured through Keyv: `{ stores: [new KeyvRedis(url)] }` rather than a `store` instance. The stored envelope is now `{ value, expires }`, and a miss returns `undefined` where cache-manager v5 returned `null`.
- Cache queries, never operations. An endpoint that changes state is not a cache candidate however idempotent it looks.

## `@nestjs/schedule`

- `@Cron(expr, { name, timeZone, utcOffset, disabled, waitForCompletion })`. **`waitForCompletion: true` skips overlapping runs** — without it a job slower than its interval runs concurrently with itself, which is how duplicate side effects happen.
- Declarative jobs run on **every replica**. Anything that must happen once needs a lock, a leader election, or a queue.
- `SchedulerRegistry` adds, stops, and inspects jobs at runtime by name — which is also how you disable a job per environment without a code branch.

## Microservices

- **`@MessagePattern` is request/response; `@EventPattern` is fire-and-forget** and returns nothing. Using a message pattern for a notification pays for a reply channel nobody reads.
- **`ClientProxy.send()` returns a cold Observable** — nothing is sent until something subscribes. `emit()` is hot and dispatches immediately.
- The proxy connects lazily on first use; call `connect()` in `onApplicationBootstrap` if you want a connection failure to surface at startup rather than on the first request.
- Throw `RpcException` from a microservice handler; HTTP exceptions do not translate.
- See `request-lifecycle.md` for hybrid apps and `inheritAppConfig`.
