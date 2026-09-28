# REST API Documentation

The bare-minimum rule applies to API schemas too. A `description` / `help_text` / `@ApiProperty` string is rendered to consumers, but the schema already shows them the field name and type — so the text must add what the schema cannot: constraints, units, format, uniqueness, role. Never restate the field name.

Two things differ from code-symbol docs:

- **Operation `summary` keeps the imperative** — "Create a new user", not "Creates a new user". This is the OpenAPI convention and what every consumer's tooling expects.
- **Always document the error responses a route can return.** They are invisible from the signature and they are what a client actually has to handle.

## Keep each schema in one place

The same habit that governs doc comments governs specs: define shared shapes, parameters, and error responses once under `components:` and `$ref` them. A hand-written spec that repeats the `Error` object on every operation drifts field by field, and the consumers generating clients from it get a different type per endpoint.

```yaml
components:
  schemas:
    Error:
      {
        type: object,
        properties: { code: { type: string }, message: { type: string } },
      }
  parameters:
    Page:
      {
        name: page,
        in: query,
        schema: { type: integer, default: 1, minimum: 1 },
      }
  responses:
    NotFound:
      description: No resource with that ID
      content:
        { application/json: { schema: { $ref: "#/components/schemas/Error" } } }
```

Decorator-driven frameworks (below) get this for free — the DTO class _is_ the single definition.

## NestJS — `@nestjs/swagger`

Decorators are explicit; nothing is inferred from types.

```typescript
@ApiTags("Users")
@ApiBearerAuth()
@Controller("users")
export class UsersController {
  @Post()
  @ApiOperation({ summary: "Create a new user" })
  @ApiResponse({ status: 201, type: UserDto })
  @ApiResponse({ status: 400, description: "Invalid input data" })
  @ApiResponse({ status: 409, description: "Email already registered" })
  async create(@Body() dto: CreateUserDto): Promise<UserDto> {}
}

export class CreateUserDto {
  @ApiProperty({ description: "Shown across the UI.", maxLength: 100 })
  @IsString()
  name: string;

  @ApiProperty({ description: "Unique, with case-insensitive lookups." })
  @IsEmail()
  email: string;

  @ApiPropertyOptional({ description: "Absolute HTTPS URL to the avatar." })
  avatarUrl?: string;
}
```

Each `description` adds the constraint or role the schema omits — never "The user's name as a string".

## FastAPI

The schema comes from type hints and Pydantic `Field`s, so the docstring carries only what they can't.

```python
@app.post("/users", response_model=UserResponse,
          status_code=status.HTTP_201_CREATED,
          summary="Create a new user", tags=["Users"])
async def create_user(user: UserCreate) -> UserResponse:
    """Create a new user account.

    Raises:
        HTTPException: 400 if the email already exists.
    """
```

No `Args:` or `Returns:` block — `user: UserCreate` and the return annotation already carry them. Only the error case earns prose.

## Django REST Framework — drf-spectacular

```python
class UserSerializer(serializers.ModelSerializer):
    name = serializers.CharField(
        help_text="Shown across the UI.", max_length=100)
    email = serializers.EmailField(
        help_text="Unique, with case-insensitive lookups.")


@extend_schema(
    summary="Get current user",
    responses={200: UserSerializer, 401: OpenApiTypes.OBJECT},
)
@action(detail=False, methods=["get"])
def me(self, request): ...
```

## Express — swagger-jsdoc

Route annotations live in a `@swagger` JSDoc block; put shared shapes in `components/schemas` and `$ref` them so a field's description exists in exactly one place.

```javascript
/**
 * @swagger
 * /users/{id}:
 *   get:
 *     summary: Get user by ID
 *     tags: [Users]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: string }
 *     responses:
 *       200:
 *         description: User found
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/User' }
 *       404:
 *         description: No user with that ID
 */
router.get("/users/:id", getUser);
```
