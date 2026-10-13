# Nest 11 and Express 5

Changes that compile cleanly and fail at runtime. Check these first when reviewing code written against v10, or when a route that "obviously works" returns 404.

## Route syntax (Express 5 / path-to-regexp v8)

```ts
@Get("files/*")        → @Get("files/*splat")     // wildcards must be named
@Get(":file?")         → @Get(":file{.:ext}")     // `?` is gone
forRoutes("*")         → forRoutes("{*splat}")    // same in middleware
```

`abcd/*splat` requires at least one character after the slash; `abcd/{*splat}` also matches `abcd/`.

## Query parsing

Express 5 defaults to the `simple` parser, so `?filter[status]=new` and `?ids[]=1&ids[]=2` stop producing objects and arrays. Restore the old behaviour explicitly:

```ts
app.set("query parser", "extended");
```

## `@nestjs/config` v4

- Internal configuration now takes precedence over `process.env` — the reverse of v3.
- `ignoreEnvVars` → `validatePredefined: false`.
- New `skipProcessEnv` blocks `process.env` access entirely.

## `@nestjs/cache-manager` v3 / cache-manager v6

```ts
// before
const store = await redisStore({ socket: { host, port } });
return { store };

// after
return { stores: [new KeyvRedis(`redis://${host}:${port}`)] };
```

Stored values are wrapped as `{ value, expires }`, and a miss returns `undefined` rather than `null`.

## Terminus

Custom health indicators inject `HealthIndicatorService` and call `check(key).up()` / `.down()` instead of extending `HealthIndicator` and throwing `HealthCheckError`.

## Reflector types

- `getAllAndOverride()` now returns `T | undefined` — the absent case is no longer implicitly `any`.
- `getAllAndMerge()` returns an object for object metadata, where it previously returned a single-element array.

## Ordering

- Termination hooks (`onModuleDestroy`, `beforeApplicationShutdown`, `onApplicationShutdown`) run in **reverse** initialization order.
- Global middleware runs before module-bound middleware regardless of the module graph.

## Module resolution

Dynamic modules no longer dedupe by a predictable hash. Assign a shared dynamic module to a variable and reuse it rather than calling `forRoot()` twice and assuming one instance. In tests, `module.select()` and `module.get(Target, { each: true })` cover the cases where the old behaviour was doing the work.

## Runtime

Node.js 20 is the minimum; 16 and 18 are unsupported.
