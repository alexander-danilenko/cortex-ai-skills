# Configuration and logging

## ConfigModule

- **`ConfigModule` with a validated schema, injected via `ConfigService`.** Reading `process.env` inside a service makes the value untestable and defers a missing-config failure to whenever that line first runs — usually in production.
- **Config that controls money, entitlement, or a loop bound is untrusted input.** A remotely editable value is typed by nobody and reviewed by nobody, so validate it at the read site against a ceiling that lives in code — the one bound an operator can't edit. Skip and log the offending key rather than failing the whole operation or silently coercing.
- **`registerAs('database', () => ({ … }))` for namespaced config**, read as `config.get('database.host')` or injected type-safely with `@Inject(databaseConfig.KEY)`. Namespacing is what stops a flat `.env` from becoming a shared mutable global.
- **A custom `validate()` function must be synchronous.** An async one leaves the app unable to bootstrap.
- **A custom config factory is not covered by `validationSchema`.** Validation and coercion inside a `load` factory are your job.

Behaviours that surprise people:

- `envFilePath: ['.env.dev.local', '.env.dev']` — **first match wins**.
- On `@nestjs/config` v4 (Nest 11), internal configuration takes precedence over `process.env`. On v3 it was the other way round. `ignoreEnvVars` became `validatePredefined`, and `skipProcessEnv` blocks `process.env` entirely.
- `${OTHER_VAR}` stays a literal string unless `expandVariables: true`. Nothing warns you.
- `cache: true` avoids repeated `process.env` reads, which are slow enough to matter in a hot path.
- `ConfigService<EnvVars, true>` with `{ infer: true }` types the keys and drops `undefined` from returns under `strictNullChecks`.
- `isGlobal: true` removes the import everywhere, at the cost of an invisible dependency — the module compiles in a test only if the test also registers config.
- Config read via `forFeature()` may not be present in a constructor; read it in `onModuleInit`.
- Anything needed **before** the container exists (a `createMicroservice` transport config) has no `ConfigService`. Use Node's `--env-file`, or `app.get(ConfigService)` after `NestFactory.create()` in `main.ts`.

## Logging

- **`NestFactory.create(AppModule, { bufferLogs: true })` then `app.useLogger(app.get(MyLogger))`.** Without buffering, everything logged during bootstrap — including the errors that explain a failed boot — goes to the default logger and is formatted differently or lost.
- **A logger injected for per-class context must be `Scope.TRANSIENT`.** A singleton logger means `setContext()` from one service overwrites every other service's context.
- `ConsoleLogger` takes `json: true` for aggregation-friendly output (which also disables colours), `logLevels` (cascading — enabling `'log'` implies `warn`/`error`/`fatal`), `timestamp`, and `prefix`. Extend it and call `super` rather than reimplementing `LoggerService`, so Nest's internal log calls keep working.
- Application instantiation happens outside any module context, so a logger you intend to use during bootstrap has to be reachable from the root module.
