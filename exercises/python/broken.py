"""
Intentionally broken Python code for practicing LSP diagnostics.

Keybindings to practice:
  [d / ]d    - navigate between diagnostics
  <leader>ld - list all diagnostics (Trouble)
  <leader>ca - code actions (quick fix)
  K          - hover documentation
"""

import os
import json  # noqa: F401 - unused import (intentional)
from typing import Optional
from collections import OrderedDict  # noqa: F401 - unused import


# ERROR: missing import for 'math' module
def calculate_hypotenuse(a: float, b: float) -> float:
    """Calculate the hypotenuse of a right triangle."""
    return math.sqrt(a ** 2 + b ** 2)


# ERROR: undefined variable 'config'
def get_database_url() -> str:
    """Get database URL from config."""
    host = config["database"]["host"]
    port = config["database"]["port"]
    return f"postgresql://{host}:{port}/mydb"


# ERROR: wrong argument count
def greet(name: str, greeting: str, punctuation: str) -> str:
    """Generate a greeting message."""
    return f"{greeting}, {name}{punctuation}"

message = greet("Alice")  # missing 2 required arguments


# ERROR: type mismatch
def add_numbers(a: int, b: int) -> int:
    """Add two integers."""
    return a + b

result: int = add_numbers("hello", "world")  # wrong types


# ERROR: attribute does not exist
class User:
    def __init__(self, name: str, email: str) -> None:
        self.name = name
        self.email = email

user = User("Jan", "jan@example.com")
print(user.phone)  # 'User' has no attribute 'phone'


# ERROR: incompatible return type
def get_active_users() -> list[str]:
    """Should return a list of strings but returns None."""
    users = ["Alice", "Bob", "Charlie"]
    if len(users) > 0:
        return None  # should return users


# ERROR: unreachable code
def process_data(data: Optional[str]) -> str:
    """Process data string."""
    if data is None:
        raise ValueError("Data cannot be None")
        print("This line is unreachable")  # unreachable
    return data.strip()


# ERROR: variable used before assignment
def compute_average(numbers: list[float]) -> float:
    """Compute average of a list."""
    if len(numbers) > 0:
        total = sum(numbers)
    return total / len(numbers)  # 'total' possibly unbound


# ERROR: wrong dict key type
scores: dict[str, int] = {"alice": 95, "bob": 87}
value = scores[42]  # key should be str, not int
