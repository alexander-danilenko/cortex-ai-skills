# DTOs, validation, and OpenAPI

## Validation

- **Every request body, query, and param goes through a DTO with `class-validator`**, behind a `ValidationPipe` configured `whitelist: true`, `forbidNonWhitelisted: true`, `transform: true`. Whitelisting is the part that matters: without it, an unexpected property rides through into your persistence layer. If the app opts routes in individually instead, treat a route without the pipe as a bug, not as evidence it isn't needed.
- **DTOs are classes, never interfaces.** TypeScript erases interfaces at compile time, so the pipe sees `metatype === Object` and validates nothing. For the same reason, `import type { CreateShipmentDto }` removes the runtime reference the pipe needs — import it normally.
- **`@ValidateNested()` needs `@Type(() => Child)` beside it.** class-transformer can't infer the target class from the TypeScript type, so without `@Type` the nested object stays a plain object and its rules never run — the request passes validation while carrying unvalidated data. Same for arrays, with `{ each: true }`.
- **A top-level array body needs `ParseArrayPipe({ items: CreateItemDto })`** or a wrapper DTO. `@Body() items: CreateItemDto[]` alone validates nothing.
- Generics are invisible to the metadata reflection too — a DTO typed through a generic parameter will not be validated as you expect.
- `enableImplicitConversion` in `transformOptions` will coerce by the declared TypeScript type, which is convenient for query params and hazardous for anything where `"0"`, `""`, or `"false"` should not become a primitive. Prefer explicit `@Type(() => Number)`.
- Parse pipes (`ParseIntPipe`, `ParseUUIDPipe`, `ParseBoolPipe`) throw on `null`/`undefined`, so an optional param needs `DefaultValuePipe` in front of them.
- Reach for `exceptionFactory` when the client contract needs a specific error shape, `stopAtFirstError` to cut noisy responses, and `disableErrorMessages` in production if the messages leak field semantics.

## Serialization

- **`ClassSerializerInterceptor` only transforms class instances.** Returning `{ user: new UserEntity() }` — a plain object wrapping an instance — skips `@Exclude()` entirely, and the excluded field ships. Return the instance itself, or declare `@SerializeOptions({ type: UserDto })` so the plain object is converted first.
- `@Exclude()` for secrets, `@Expose()` for aliases and computed values, `@Transform()` for reshaping, `@SerializeOptions({ groups })` when one entity serves several audiences.
- It does not apply to `StreamableFile` responses.

## Response DTOs

- **Response DTOs are what leaves the process.** Returning an entity directly leaks whatever a future migration adds to the table — password hashes, internal flags, soft-delete columns — with no code change to notice. A `@Exclude()` on the entity is a second line of defence, not a substitute.

## OpenAPI

- **DTO class names are globally unique across the codebase.** Swagger keys schemas by class name, so two `CreateInput` classes in different modules silently merge into one schema and the generated client is wrong in a way nothing type-checks. Prefix by module: `ShipmentCreateInput`.
- **Take `PartialType` / `OmitType` / `PickType` from `@nestjs/swagger`**, not `@nestjs/mapped-types`. Both exist and both compile; the mapped-types version silently drops the `@ApiProperty` metadata, so derived DTOs vanish from your OpenAPI schema.
- **Enable the Swagger CLI plugin before hand-writing `@ApiProperty` anywhere.** It reads the TypeScript AST and derives `type`, `enum`, array-ness, required vs optional, and default values, mirrors your `class-validator` decorators into the schema, and turns JSDoc comments into descriptions and `@example` values.

  ```jsonc
  // nest-cli.json
  "plugins": [
    {
      "name": "@nestjs/swagger",
      "options": { "introspectComments": true }
    }
  ]
  ```

  It only inspects files matching `dtoFileNameSuffix` (default `['.dto.ts', '.entity.ts']`) and `controllerFileNameSuffix` (default `.controller.ts`) — a DTO in a file named something else gets no metadata and no error. An explicit `@ApiProperty()` still wins, and the plugin documents but never validates: `class-validator` decorators are still required for the pipe to do anything.

- **Swagger decorators on every endpoint** (`@ApiOperation`, `@ApiResponse`). The generated spec is what clients build against; an undocumented endpoint is one nobody can consume without reading your source.
