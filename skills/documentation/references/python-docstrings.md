# Python Docstrings

Uses Microsoft contract-first conventions: a docstring describes **what** a callable does and **why** — the contract — not how it works inside. Implementation detail belongs in `#` comments in the body, never in the docstring.

## Bare Minimum — Do Not Restate the Signature

Type hints are part of the signature. Given `def calculate_total(items: list[Item], tax_rate: float = 0.0) -> float`, the reader already sees every name, every type, the default, and the return type. The docstring adds only what those cannot carry: intent, units, ranges, the meaning of edge values, what `None` or an empty result signifies, and which exceptions escape.

Because the annotations carry the types, **do not repeat them in the docstring.** Drop the `(float)` / `: float` type echoes that older NumPy and Sphinx snippets show, and drop any `Args:` entry whose text only re-says the parameter name.

```python
# WRONG — every line restates the signature.
def find_user(user_id: str) -> User | None:
    """Find a user by id.

    Args:
        user_id: The user's id, as a string.

    Returns:
        The user object, or None.
    """

# CORRECT — only the non-obvious contract is documented.
def find_user(user_id: str) -> User | None:
    """Find a user by id.

    Returns:
        None when no user matches; the lookup never raises on a miss.
    """
```

### When an `Args:` Entry Earns Its Keep

Document a parameter only when the text answers something the annotation cannot:

- What unit is it in? (ms, bytes, a decimal fraction, …)
- What range or clamp applies?
- What default behaviour applies when it is omitted?
- What does an edge value mean? (`0` disables, `-1` = unlimited, empty list = "all", …)
- What does `None` or an empty value signify, versus raising?

If none apply, omit the entry — a name-and-type echo is noise. `Raises:` is the opposite default: document it whenever the function can raise, because the exception set is invisible from the signature.

```python
def next_delay(attempt: int) -> float:
    """Compute the exponential backoff delay.

    Args:
        attempt: Zero-based; values above 10 are clamped.

    Returns:
        Delay in seconds, capped at 30.
    """
```

`attempt` earns its `Args:` line because "zero-based" and the clamp are not in `int`. `Returns:` earns its line because the unit (seconds) and the cap are not in `float`.

## Styles Differ in Syntax, Not in Discipline

Pick one style per project. They lay the sections out differently; the bare-minimum rule applies to all three, and with type hints present none of them repeat the type.

### Google Style (Recommended)

```python
def calculate_total(items: list[Item], tax_rate: float = 0.0) -> float:
    """Calculate the order total, tax included.

    Args:
        tax_rate: Decimal fraction; 0.08 is 8%. Defaults to no tax.

    Raises:
        ValueError: If tax_rate is negative or items is empty.
    """
```

`items` has no `Args:` entry — the name and `list[Item]` say everything. `tax_rate` keeps one for the unit and default behaviour. `Returns:` is omitted because the summary already states the result.

### NumPy Style

```python
def calculate_total(items: list[Item], tax_rate: float = 0.0) -> float:
    """Calculate the order total, tax included.

    Parameters
    ----------
    tax_rate
        Decimal fraction; 0.08 is 8%. Defaults to no tax.

    Raises
    ------
    ValueError
        If tax_rate is negative or items is empty.
    """
```

No `tax_rate : float` type line — the annotation carries the type.

### Sphinx Style

```python
def calculate_total(items: list[Item], tax_rate: float = 0.0) -> float:
    """Calculate the order total, tax included.

    :param tax_rate: Decimal fraction; 0.08 is 8%. Defaults to no tax.
    :raises ValueError: If tax_rate is negative or items is empty.
    """
```

Drop the `:type:` and `:rtype:` fields entirely when type hints are present.

## Class Documentation

Document what the class is for. Do not re-document a constructor parameter on both the class `Attributes:` block and `__init__` — that is the same DRY rule the interface/implementation split enforces elsewhere. Give the constructor a docstring only when its arguments need meaning beyond their names; otherwise omit it.

```python
class UserService:
    """Manage the user lifecycle, backed by a write-through cache.

    Reads are served from the cache; writes update both stores.
    """

    def __init__(self, db: AsyncSession, cache: Redis) -> None: ...
```

The class summary earns its keep by naming a behaviour the class name does not reveal — the write-through cache. `db` and `cache` get no `Args:` block; their names and types are self-explanatory, and the cache's role is stated once, on the class.

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

## Examples Belong in Tests

Ship a doctest only when it is run — via `pytest --doctest-modules` or a doctest CI step. A doctest that is never executed drifts and misleads exactly like any other stale comment, so when an example would not be run, leave it out.

```python
def slugify(text: str) -> str:
    """Convert text to a URL-safe slug.

    Example:
        >>> slugify("Hello, World!")
        'hello-world'
    """
```

Keep the `Example:` block only when that doctest runs in the suite.

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
