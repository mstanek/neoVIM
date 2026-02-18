"""
Calculator module with full arithmetic operations, memory, and history.

Used as exercise for Vim motions, text objects, and LSP navigation.
"""

from __future__ import annotations

import math
from dataclasses import dataclass, field
from enum import Enum
from typing import Optional


class Operation(Enum):
    """Supported calculator operations."""

    ADD = "add"
    SUBTRACT = "subtract"
    MULTIPLY = "multiply"
    DIVIDE = "divide"
    POWER = "power"
    SQRT = "sqrt"


@dataclass
class HistoryEntry:
    """Single entry in calculator history."""

    operation: Operation
    operands: tuple[float, ...]
    result: float
    timestamp: Optional[str] = None

    def __str__(self) -> str:
        ops = ", ".join(str(o) for o in self.operands)
        return f"{self.operation.value}({ops}) = {self.result}"


class CalculatorError(Exception):
    """Base exception for calculator errors."""

    pass


class DivisionByZeroError(CalculatorError):
    """Raised when attempting to divide by zero."""

    pass


class NegativeSqrtError(CalculatorError):
    """Raised when attempting square root of negative number."""

    pass


class MemoryEmptyError(CalculatorError):
    """Raised when recalling from empty memory."""

    pass


@dataclass
class Calculator:
    """A feature-rich calculator with memory and history tracking.

    Attributes:
        precision: Number of decimal places for rounding results.
        memory: Stored value for memory operations.
        _history: List of all performed operations.
    """

    precision: int = 10
    memory: Optional[float] = None
    _history: list[HistoryEntry] = field(default_factory=list)

    def _record(self, op: Operation, operands: tuple[float, ...], result: float) -> float:
        """Record operation in history and return rounded result."""
        result = round(result, self.precision)
        entry = HistoryEntry(operation=op, operands=operands, result=result)
        self._history.append(entry)
        return result

    def add(self, a: float, b: float) -> float:
        """Add two numbers together.

        Args:
            a: First operand.
            b: Second operand.

        Returns:
            Sum of a and b.
        """
        return self._record(Operation.ADD, (a, b), a + b)

    def subtract(self, a: float, b: float) -> float:
        """Subtract b from a.

        Args:
            a: Number to subtract from.
            b: Number to subtract.

        Returns:
            Difference of a and b.
        """
        return self._record(Operation.SUBTRACT, (a, b), a - b)

    def multiply(self, a: float, b: float) -> float:
        """Multiply two numbers.

        Args:
            a: First factor.
            b: Second factor.

        Returns:
            Product of a and b.
        """
        return self._record(Operation.MULTIPLY, (a, b), a * b)

    def divide(self, a: float, b: float) -> float:
        """Divide a by b.

        Args:
            a: Dividend.
            b: Divisor (must not be zero).

        Returns:
            Quotient of a and b.

        Raises:
            DivisionByZeroError: If b is zero.
        """
        if b == 0:
            raise DivisionByZeroError("Cannot divide by zero")
        return self._record(Operation.DIVIDE, (a, b), a / b)

    def power(self, base: float, exponent: float) -> float:
        """Raise base to the power of exponent.

        Args:
            base: The base number.
            exponent: The exponent to raise to.

        Returns:
            base raised to exponent.
        """
        return self._record(Operation.POWER, (base, exponent), base**exponent)

    def sqrt(self, value: float) -> float:
        """Calculate the square root of a value.

        Args:
            value: Non-negative number.

        Returns:
            Square root of value.

        Raises:
            NegativeSqrtError: If value is negative.
        """
        if value < 0:
            raise NegativeSqrtError(f"Cannot calculate square root of {value}")
        return self._record(Operation.SQRT, (value,), math.sqrt(value))

    def memory_store(self, value: float) -> None:
        """Store a value in calculator memory.

        Args:
            value: The value to store.
        """
        self.memory = value

    def memory_recall(self) -> float:
        """Recall the value stored in memory.

        Returns:
            The stored memory value.

        Raises:
            MemoryEmptyError: If no value has been stored.
        """
        if self.memory is None:
            raise MemoryEmptyError("Memory is empty, store a value first")
        return self.memory

    def memory_clear(self) -> None:
        """Clear the calculator memory."""
        self.memory = None

    def history(self, last_n: Optional[int] = None) -> list[HistoryEntry]:
        """Return calculator operation history.

        Args:
            last_n: If provided, return only the last N entries.

        Returns:
            List of history entries.
        """
        if last_n is not None:
            return self._history[-last_n:]
        return list(self._history)

    def clear_history(self) -> None:
        """Clear all operation history."""
        self._history.clear()

    def chain(self, initial: float, *operations: tuple[str, float]) -> float:
        """Chain multiple operations starting from an initial value.

        Args:
            initial: Starting value.
            *operations: Tuples of (operation_name, operand).

        Returns:
            Final computed value after all operations.
        """
        result = initial
        dispatch = {
            "add": self.add,
            "subtract": self.subtract,
            "multiply": self.multiply,
            "divide": self.divide,
            "power": self.power,
        }
        for op_name, operand in operations:
            func = dispatch.get(op_name)
            if func is None:
                raise CalculatorError(f"Unknown operation: {op_name}")
            result = func(result, operand)
        return result
