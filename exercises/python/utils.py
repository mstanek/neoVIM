"""
Utility functions for common operations.

Mix of simple and complex functions for Vim navigation practice.
"""

from __future__ import annotations

import hashlib
import re
import secrets
import string
import time
from datetime import datetime
from functools import wraps
from typing import Any, Callable, Optional, TypeVar

T = TypeVar("T")


def format_currency(amount: float, currency: str = "USD", locale: str = "en") -> str:
    """Format a numeric amount as a currency string.

    Args:
        amount: The monetary value to format.
        currency: ISO 4217 currency code.
        locale: Locale for formatting (en, pl, de).

    Returns:
        Formatted currency string.
    """
    symbols = {"USD": "$", "EUR": "\u20ac", "PLN": "z\u0142", "GBP": "\u00a3"}
    symbol = symbols.get(currency, currency)
    if locale == "pl":
        return f"{amount:,.2f} {symbol}".replace(",", " ").replace(".", ",")
    return f"{symbol}{amount:,.2f}"


def validate_email(email: str) -> bool:
    """Validate an email address using a regex pattern.

    Args:
        email: The email address to validate.

    Returns:
        True if the email is valid, False otherwise.
    """
    pattern = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
    return bool(re.match(pattern, email))


def slugify(text: str, separator: str = "-") -> str:
    """Convert a text string into a URL-friendly slug.

    Args:
        text: The input string.
        separator: Character to use as word separator.

    Returns:
        Lowercased, stripped slug string.
    """
    text = text.lower().strip()
    text = re.sub(r"[^\w\s-]", "", text)
    text = re.sub(r"[\s_]+", separator, text)
    text = re.sub(f"{re.escape(separator)}+", separator, text)
    return text.strip(separator)


def paginate(items: list[T], page: int = 1, per_page: int = 20) -> dict[str, Any]:
    """Paginate a list of items.

    Args:
        items: The full list of items.
        page: Current page number (1-indexed).
        per_page: Number of items per page.

    Returns:
        Dictionary with paginated data and metadata.
    """
    total = len(items)
    total_pages = max(1, (total + per_page - 1) // per_page)
    page = max(1, min(page, total_pages))
    start = (page - 1) * per_page
    end = start + per_page

    return {
        "items": items[start:end],
        "page": page,
        "per_page": per_page,
        "total": total,
        "total_pages": total_pages,
        "has_next": page < total_pages,
        "has_prev": page > 1,
    }


def retry_with_backoff(
    max_retries: int = 3,
    base_delay: float = 1.0,
    backoff_factor: float = 2.0,
    exceptions: tuple[type[Exception], ...] = (Exception,),
) -> Callable:
    """Decorator that retries a function with exponential backoff.

    Args:
        max_retries: Maximum number of retry attempts.
        base_delay: Initial delay between retries in seconds.
        backoff_factor: Multiplier for delay after each retry.
        exceptions: Tuple of exception types to catch.

    Returns:
        Decorated function with retry logic.
    """

    def decorator(func: Callable[..., T]) -> Callable[..., T]:
        @wraps(func)
        def wrapper(*args: Any, **kwargs: Any) -> T:
            delay = base_delay
            last_exception: Optional[Exception] = None
            for attempt in range(max_retries + 1):
                try:
                    return func(*args, **kwargs)
                except exceptions as exc:
                    last_exception = exc
                    if attempt < max_retries:
                        time.sleep(delay)
                        delay *= backoff_factor
            raise last_exception  # type: ignore[misc]

        return wrapper

    return decorator


def parse_date(date_string: str) -> Optional[datetime]:
    """Try to parse a date string in common formats.

    Args:
        date_string: Date string to parse.

    Returns:
        Parsed datetime or None if no format matched.
    """
    formats = [
        "%Y-%m-%d",
        "%Y-%m-%dT%H:%M:%S",
        "%Y-%m-%dT%H:%M:%SZ",
        "%d/%m/%Y",
        "%d.%m.%Y",
        "%m/%d/%Y",
        "%B %d, %Y",
    ]
    for fmt in formats:
        try:
            return datetime.strptime(date_string, fmt)
        except ValueError:
            continue
    return None


def sanitize_html(html: str) -> str:
    """Remove all HTML tags from a string, keeping text content.

    Args:
        html: Input string potentially containing HTML.

    Returns:
        Plain text with HTML tags stripped.
    """
    clean = re.sub(r"<[^>]+>", "", html)
    clean = re.sub(r"&nbsp;", " ", clean)
    clean = re.sub(r"&amp;", "&", clean)
    clean = re.sub(r"&lt;", "<", clean)
    clean = re.sub(r"&gt;", ">", clean)
    clean = re.sub(r"&quot;", '"', clean)
    return clean.strip()


def generate_token(length: int = 32, include_special: bool = False) -> str:
    """Generate a secure random token.

    Args:
        length: Desired length of the token.
        include_special: Whether to include special characters.

    Returns:
        A random token string.
    """
    alphabet = string.ascii_letters + string.digits
    if include_special:
        alphabet += "!@#$%^&*"
    return "".join(secrets.choice(alphabet) for _ in range(length))


def compute_checksum(data: str, algorithm: str = "sha256") -> str:
    """Compute a hash checksum for the given string.

    Args:
        data: Input string to hash.
        algorithm: Hash algorithm (md5, sha1, sha256, sha512).

    Returns:
        Hex digest of the hash.
    """
    hasher = hashlib.new(algorithm)
    hasher.update(data.encode("utf-8"))
    return hasher.hexdigest()
