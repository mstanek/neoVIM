"""
Data processing module with classes and functions for ETL pipelines.

Good for practicing folding (zc/zo/za/zR/zM), Aerial navigation,
telescope symbol search, and general code navigation.
"""

from __future__ import annotations

import csv
import io
import json
import re
from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum
from pathlib import Path
from typing import Any, Callable, Generic, Iterator, Optional, TypeVar

T = TypeVar("T")
R = TypeVar("R")


# ---------------------------------------------------------------------------
# Data types and configuration
# ---------------------------------------------------------------------------

class FileFormat(Enum):
    CSV = "csv"
    JSON = "json"
    TSV = "tsv"


@dataclass
class ColumnSchema:
    """Schema definition for a single data column."""

    name: str
    dtype: str
    nullable: bool = True
    default: Any = None
    validators: list[Callable[[Any], bool]] = field(default_factory=list)

    def validate(self, value: Any) -> bool:
        """Run all validators against the given value."""
        if value is None:
            return self.nullable
        return all(v(value) for v in self.validators)


@dataclass
class DataSchema:
    """Schema definition for a dataset."""

    columns: list[ColumnSchema]
    primary_key: Optional[str] = None
    version: str = "1.0"

    def get_column(self, name: str) -> Optional[ColumnSchema]:
        """Find a column by name."""
        for col in self.columns:
            if col.name == name:
                return col
        return None

    @property
    def column_names(self) -> list[str]:
        return [col.name for col in self.columns]

    @property
    def required_columns(self) -> list[str]:
        return [col.name for col in self.columns if not col.nullable]


# ---------------------------------------------------------------------------
# Data Loader
# ---------------------------------------------------------------------------

class DataLoader:
    """Loads data from various file formats into row dictionaries."""

    def __init__(self, encoding: str = "utf-8") -> None:
        self.encoding = encoding
        self._parsers: dict[FileFormat, Callable] = {
            FileFormat.CSV: self._parse_csv,
            FileFormat.JSON: self._parse_json,
            FileFormat.TSV: self._parse_tsv,
        }

    def load(self, source: str | Path, fmt: FileFormat) -> list[dict[str, Any]]:
        """Load data from the given source path.

        Args:
            source: File path to load.
            fmt: Expected file format.

        Returns:
            List of row dictionaries.
        """
        parser = self._parsers.get(fmt)
        if parser is None:
            raise ValueError(f"Unsupported format: {fmt}")
        path = Path(source)
        content = path.read_text(encoding=self.encoding)
        return parser(content)

    def load_string(self, content: str, fmt: FileFormat) -> list[dict[str, Any]]:
        """Load data from a raw string."""
        parser = self._parsers.get(fmt)
        if parser is None:
            raise ValueError(f"Unsupported format: {fmt}")
        return parser(content)

    def _parse_csv(self, content: str) -> list[dict[str, Any]]:
        reader = csv.DictReader(io.StringIO(content))
        return [dict(row) for row in reader]

    def _parse_tsv(self, content: str) -> list[dict[str, Any]]:
        reader = csv.DictReader(io.StringIO(content), delimiter="\t")
        return [dict(row) for row in reader]

    def _parse_json(self, content: str) -> list[dict[str, Any]]:
        data = json.loads(content)
        if isinstance(data, list):
            return data
        if isinstance(data, dict) and "data" in data:
            return data["data"]
        raise ValueError("JSON must be an array or object with 'data' key")


# ---------------------------------------------------------------------------
# Transformers
# ---------------------------------------------------------------------------

class BaseTransformer(ABC, Generic[T, R]):
    """Abstract base class for data transformers."""

    @abstractmethod
    def transform(self, data: T) -> R:
        """Transform the input data."""
        ...

    def __repr__(self) -> str:
        return f"{self.__class__.__name__}()"


class ColumnRenamer(BaseTransformer[dict[str, Any], dict[str, Any]]):
    """Rename columns in row dictionaries."""

    def __init__(self, mapping: dict[str, str]) -> None:
        self.mapping = mapping

    def transform(self, data: dict[str, Any]) -> dict[str, Any]:
        return {self.mapping.get(k, k): v for k, v in data.items()}


class TypeCaster(BaseTransformer[dict[str, Any], dict[str, Any]]):
    """Cast column values to specified types."""

    TYPE_MAP: dict[str, type] = {
        "int": int,
        "float": float,
        "str": str,
        "bool": bool,
    }

    def __init__(self, type_spec: dict[str, str]) -> None:
        self.type_spec = type_spec

    def transform(self, data: dict[str, Any]) -> dict[str, Any]:
        result = dict(data)
        for col, target_type in self.type_spec.items():
            if col in result and result[col] is not None:
                caster = self.TYPE_MAP.get(target_type)
                if caster:
                    result[col] = caster(result[col])
        return result


class ColumnFilter(BaseTransformer[dict[str, Any], dict[str, Any]]):
    """Keep only specified columns."""

    def __init__(self, columns: list[str]) -> None:
        self.columns = set(columns)

    def transform(self, data: dict[str, Any]) -> dict[str, Any]:
        return {k: v for k, v in data.items() if k in self.columns}


class RowFilter(BaseTransformer[dict[str, Any], Optional[dict[str, Any]]]):
    """Filter rows based on a predicate function."""

    def __init__(self, predicate: Callable[[dict[str, Any]], bool]) -> None:
        self.predicate = predicate

    def transform(self, data: dict[str, Any]) -> Optional[dict[str, Any]]:
        return data if self.predicate(data) else None


class ValueMapper(BaseTransformer[dict[str, Any], dict[str, Any]]):
    """Apply a mapping function to a specific column."""

    def __init__(self, column: str, func: Callable[[Any], Any]) -> None:
        self.column = column
        self.func = func

    def transform(self, data: dict[str, Any]) -> dict[str, Any]:
        result = dict(data)
        if self.column in result:
            result[self.column] = self.func(result[self.column])
        return result


# ---------------------------------------------------------------------------
# Data Validator
# ---------------------------------------------------------------------------

@dataclass
class ValidationError:
    """Describes a single validation failure."""

    row_index: int
    column: str
    message: str
    value: Any = None


class DataValidator:
    """Validates data rows against a schema."""

    def __init__(self, schema: DataSchema, strict: bool = False) -> None:
        self.schema = schema
        self.strict = strict

    def validate(self, rows: list[dict[str, Any]]) -> list[ValidationError]:
        """Validate all rows and return a list of errors."""
        errors: list[ValidationError] = []
        for idx, row in enumerate(rows):
            errors.extend(self._validate_row(idx, row))
        return errors

    def _validate_row(self, index: int, row: dict[str, Any]) -> list[ValidationError]:
        errors: list[ValidationError] = []

        for col in self.schema.columns:
            value = row.get(col.name)

            if value is None and not col.nullable:
                errors.append(
                    ValidationError(index, col.name, "Required field is missing")
                )
                continue

            if value is not None and not col.validate(value):
                errors.append(
                    ValidationError(index, col.name, "Validation failed", value)
                )

        if self.strict:
            extra_keys = set(row.keys()) - set(self.schema.column_names)
            for key in extra_keys:
                errors.append(
                    ValidationError(index, key, "Unexpected column in strict mode")
                )

        return errors

    def is_valid(self, rows: list[dict[str, Any]]) -> bool:
        """Return True if no validation errors exist."""
        return len(self.validate(rows)) == 0


# ---------------------------------------------------------------------------
# Pipeline
# ---------------------------------------------------------------------------

class Pipeline:
    """Composable data processing pipeline.

    Chains together a loader, transformers, and optional validator
    to process data in a single pass.
    """

    def __init__(self, name: str = "default") -> None:
        self.name = name
        self._transformers: list[BaseTransformer] = []
        self._validator: Optional[DataValidator] = None
        self._on_error: Callable[[ValidationError], None] = lambda e: None

    def add_transformer(self, transformer: BaseTransformer) -> Pipeline:
        """Add a transformer to the pipeline. Returns self for chaining."""
        self._transformers.append(transformer)
        return self

    def set_validator(self, validator: DataValidator) -> Pipeline:
        """Set the validator for the pipeline."""
        self._validator = validator
        return self

    def on_error(self, handler: Callable[[ValidationError], None]) -> Pipeline:
        """Set an error handler callback."""
        self._on_error = handler
        return self

    def process(self, rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
        """Run all rows through the transformer chain.

        Args:
            rows: Input data rows.

        Returns:
            Transformed and filtered rows.
        """
        if self._validator:
            errors = self._validator.validate(rows)
            for err in errors:
                self._on_error(err)

        result: list[dict[str, Any]] = []
        for row in rows:
            current: Any = row
            for transformer in self._transformers:
                if current is None:
                    break
                current = transformer.transform(current)
            if current is not None:
                result.append(current)
        return result

    def process_stream(self, rows: Iterator[dict[str, Any]]) -> Iterator[dict[str, Any]]:
        """Process rows lazily as an iterator."""
        for row in rows:
            current: Any = row
            for transformer in self._transformers:
                if current is None:
                    break
                current = transformer.transform(current)
            if current is not None:
                yield current


# ---------------------------------------------------------------------------
# Helper functions
# ---------------------------------------------------------------------------

def normalize_whitespace(text: str) -> str:
    """Collapse multiple whitespace characters into single spaces."""
    return re.sub(r"\s+", " ", text).strip()


def extract_emails(text: str) -> list[str]:
    """Extract all email addresses from a text string."""
    pattern = r"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}"
    return re.findall(pattern, text)


def flatten_dict(data: dict[str, Any], prefix: str = "", sep: str = ".") -> dict[str, Any]:
    """Flatten a nested dictionary into dot-notation keys."""
    items: list[tuple[str, Any]] = []
    for key, value in data.items():
        new_key = f"{prefix}{sep}{key}" if prefix else key
        if isinstance(value, dict):
            items.extend(flatten_dict(value, new_key, sep).items())
        else:
            items.append((new_key, value))
    return dict(items)


def chunk_list(data: list[T], size: int) -> list[list[T]]:
    """Split a list into chunks of the given size."""
    return [data[i : i + size] for i in range(0, len(data), size)]


def safe_get(data: dict[str, Any], path: str, default: Any = None) -> Any:
    """Safely retrieve a nested value using dot-notation path.

    Args:
        data: Source dictionary.
        path: Dot-separated key path (e.g. "user.address.city").
        default: Value to return if path does not exist.

    Returns:
        The value at the path, or default.
    """
    keys = path.split(".")
    current: Any = data
    for key in keys:
        if isinstance(current, dict):
            current = current.get(key)
        else:
            return default
        if current is None:
            return default
    return current


def merge_dicts(*dicts: dict[str, Any]) -> dict[str, Any]:
    """Deep merge multiple dictionaries. Later values override earlier ones."""
    result: dict[str, Any] = {}
    for d in dicts:
        for key, value in d.items():
            if key in result and isinstance(result[key], dict) and isinstance(value, dict):
                result[key] = merge_dicts(result[key], value)
            else:
                result[key] = value
    return result


def format_timestamp(dt: datetime, fmt: str = "%Y-%m-%d %H:%M:%S") -> str:
    """Format a datetime object as a string."""
    return dt.strftime(fmt)


def parse_bool(value: str) -> bool:
    """Parse a string into a boolean value.

    Recognized truthy: 'true', '1', 'yes', 'on', 'tak'
    Recognized falsy: 'false', '0', 'no', 'off', 'nie'
    """
    normalized = value.strip().lower()
    if normalized in ("true", "1", "yes", "on", "tak"):
        return True
    if normalized in ("false", "0", "no", "off", "nie"):
        return False
    raise ValueError(f"Cannot parse '{value}' as boolean")
