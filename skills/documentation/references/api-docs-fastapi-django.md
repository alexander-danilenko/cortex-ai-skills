# API Documentation: FastAPI & Django

The bare-minimum rule applies here too. A `summary`/`description`/`help_text` is rendered to API consumers, but the schema already shows them each field name and type — so make the text add what the schema cannot (constraints, units, format, uniqueness, role), never restate the field name. Operation `summary` fields keep the imperative convention ("Create a new user"). Always document the errors a route can return, since those are invisible from the signature.

## FastAPI (Auto-generates from types)

FastAPI automatically generates OpenAPI documentation from type hints and docstrings.

### Endpoint Documentation

```python
from fastapi import FastAPI, HTTPException, status
from pydantic import BaseModel, Field

class UserCreate(BaseModel):
    """User creation request body."""

    name: str = Field(..., min_length=1, max_length=100, example="John Doe")
    email: str = Field(..., example="john@example.com")

class UserResponse(BaseModel):
    """User response with generated ID."""

    id: int = Field(..., example=1)
    name: str
    email: str

@app.post(
    "/users",
    response_model=UserResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create a new user",
    tags=["Users"],
)
async def create_user(user: UserCreate) -> UserResponse:
    """Create a new user account.

    Raises:
        HTTPException: 400 if the email already exists.
    """
    # No Args:/Returns: blocks — `user: UserCreate` and the `UserResponse`
    # return type already carry them. Only the error case is documented.
```

### Router with Tags

```python
from fastapi import APIRouter

router = APIRouter(
    prefix="/users",
    tags=["Users"],
    responses={404: {"description": "Not found"}},
)

@router.get(
    "/{user_id}",
    response_model=UserResponse,
    summary="Get user by ID",
)
async def get_user(user_id: int) -> UserResponse:
    """Retrieve a user by their unique identifier."""
```

## Django REST Framework (drf-spectacular)

### ViewSet Documentation

```python
from rest_framework import viewsets, status
from rest_framework.decorators import action
from drf_spectacular.utils import extend_schema, OpenApiParameter

class UserViewSet(viewsets.ModelViewSet):
    """
    ViewSet for managing user accounts.

    list: Get all users with pagination.
    create: Create a new user account.
    retrieve: Get a specific user by ID.
    update: Update all user fields.
    partial_update: Update specific user fields.
    destroy: Delete a user account.
    """

    queryset = User.objects.all()
    serializer_class = UserSerializer

    @extend_schema(
        summary="Get current user",
        description="Returns the authenticated user's profile",
        responses={200: UserSerializer},
    )
    @action(detail=False, methods=["get"])
    def me(self, request):
        """Get the authenticated user's profile."""
        serializer = self.get_serializer(request.user)
        return Response(serializer.data)
```

### Serializer Documentation

```python
from rest_framework import serializers

class UserSerializer(serializers.ModelSerializer):
    """Serializer for user model with validation."""

    class Meta:
        model = User
        fields = ["id", "name", "email", "created_at"]
        read_only_fields = ["id", "created_at"]

    name = serializers.CharField(
        help_text="Shown across the UI.",
        max_length=100,
    )
    email = serializers.EmailField(
        help_text="Unique; lookups are case-insensitive.",
    )
```

### Custom Schema

```python
from drf_spectacular.utils import extend_schema, OpenApiExample

@extend_schema(
    request=UserCreateSerializer,
    responses={
        201: UserSerializer,
        400: OpenApiTypes.OBJECT,
    },
    examples=[
        OpenApiExample(
            "Valid request",
            value={"name": "John", "email": "john@example.com"},
        ),
    ],
)
def create(self, request):
    """Create a new user."""
```

## Quick Reference

| Framework | Documentation Source          | Output          |
| --------- | ----------------------------- | --------------- |
| FastAPI   | Type hints + docstrings       | Auto Swagger UI |
| DRF       | Serializers + drf-spectacular | Auto Swagger UI |

| FastAPI Decorator | Purpose                    |
| ----------------- | -------------------------- |
| `summary`         | Short endpoint description |
| `description`     | Detailed description       |
| `tags`            | Group endpoints            |
| `response_model`  | Response schema            |
| `responses`       | Additional response codes  |

| DRF Decorator      | Purpose           |
| ------------------ | ----------------- |
| `@extend_schema`   | Customize schema  |
| `OpenApiParameter` | Query/path params |
| `OpenApiExample`   | Request examples  |
