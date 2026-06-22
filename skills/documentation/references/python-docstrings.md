# Python Docstrings

## Google Style (Recommended)

```python
def calculate_total(items: list[Item], tax_rate: float = 0.0) -> float:
    """Calculate total cost including tax.

    Args:
        items: List of items to calculate total for.
        tax_rate: Tax rate as decimal (e.g., 0.08 for 8%).

    Returns:
        Total cost including tax.

    Raises:
        ValueError: If tax_rate is negative or items is empty.

    Example:
        >>> calculate_total([Item(10), Item(20)], 0.1)
        33.0
    """
```

## NumPy Style

```python
def calculate_total(items: list[Item], tax_rate: float = 0.0) -> float:
    """
    Calculate total cost including tax.

    Parameters
    ----------
    items : list[Item]
        List of items to calculate total for.
    tax_rate : float, optional
        Tax rate as decimal (e.g., 0.08 for 8%). Default is 0.0.

    Returns
    -------
    float
        Total cost including tax.

    Raises
    ------
    ValueError
        If tax_rate is negative or items is empty.

    Examples
    --------
    >>> calculate_total([Item(10), Item(20)], 0.1)
    33.0
    """
```

## Sphinx Style

```python
def calculate_total(items: list[Item], tax_rate: float = 0.0) -> float:
    """Calculate total cost including tax.

    :param items: List of items to calculate total for.
    :type items: list[Item]
    :param tax_rate: Tax rate as decimal (e.g., 0.08 for 8%).
    :type tax_rate: float
    :returns: Total cost including tax.
    :rtype: float
    :raises ValueError: If tax_rate is negative or items is empty.

    .. code-block:: python

        >>> calculate_total([Item(10), Item(20)], 0.1)
        33.0
    """
```

## Class Documentation

```python
class UserService:
    """Service for managing user operations.

    This service handles CRUD operations for users and
    integrates with the authentication system.

    Attributes:
        db: Database session for queries.
        cache: Redis client for caching.

    Example:
        >>> service = UserService(db, cache)
        >>> user = await service.create_user(data)
    """

    def __init__(self, db: AsyncSession, cache: Redis) -> None:
        """Initialize UserService.

        Args:
            db: Database session for queries.
            cache: Redis client for caching.
        """
```

## Data Classes — Describe WHAT

A `dataclass`, `NamedTuple`, `TypedDict`, or Pydantic model that exists to _hold_ data answers what each field **is** — its meaning, units, format, and constraints the annotation can't carry — not **why** the field exists. Keep the `Attributes:` block to the _what_; design rationale belongs with the behavior that produces or consumes the value, not on the field.

```python
@dataclass
class ShippingAddress:
    """A postal destination for an order.

    Attributes:
        postal_code: ZIP or ZIP+4; validated against the country's format.
        country: ISO 3166-1 alpha-2 code, uppercase.
    """

    postal_code: str
    country: str
```

`postal_code` and `country` each state what the value is and the constraint the type can't express — not why an address is stored.

## Quick Reference

| Style  | Args Format          | Returns Format    |
| ------ | -------------------- | ----------------- |
| Google | `Args:` block        | `Returns:` block  |
| NumPy  | `Parameters` section | `Returns` section |
| Sphinx | `:param name:`       | `:returns:`       |

## Sections Available

| Section    | Google        | NumPy        | Sphinx            |
| ---------- | ------------- | ------------ | ----------------- |
| Parameters | `Args:`       | `Parameters` | `:param:`         |
| Returns    | `Returns:`    | `Returns`    | `:returns:`       |
| Raises     | `Raises:`     | `Raises`     | `:raises:`        |
| Examples   | `Example:`    | `Examples`   | `.. code-block::` |
| Notes      | `Note:`       | `Notes`      | `.. note::`       |
| Attributes | `Attributes:` | `Attributes` | `:ivar:`          |
