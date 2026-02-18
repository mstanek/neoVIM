"""
Django-like models for practicing class navigation with Aerial/Namu.

These are simplified model definitions mimicking Django ORM patterns.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime
from decimal import Decimal
from enum import Enum
from typing import Optional
from uuid import UUID, uuid4


class OrderStatus(Enum):
    PENDING = "pending"
    CONFIRMED = "confirmed"
    SHIPPED = "shipped"
    DELIVERED = "delivered"
    CANCELLED = "cancelled"


@dataclass
class User:
    """Represents a registered user in the system."""

    username: str
    email: str
    first_name: str = ""
    last_name: str = ""
    is_active: bool = True
    is_staff: bool = False
    date_joined: datetime = field(default_factory=datetime.now)
    id: UUID = field(default_factory=uuid4)

    class Meta:
        ordering = ["-date_joined"]
        verbose_name = "User"
        verbose_name_plural = "Users"

    def __str__(self) -> str:
        return f"{self.username} <{self.email}>"

    @property
    def full_name(self) -> str:
        """Return the user's full name."""
        parts = [self.first_name, self.last_name]
        return " ".join(p for p in parts if p).strip()

    @classmethod
    def create_superuser(cls, username: str, email: str, **kwargs: str) -> User:
        """Factory method for creating superuser accounts."""
        return cls(username=username, email=email, is_staff=True, **kwargs)

    def deactivate(self) -> None:
        """Deactivate this user account."""
        self.is_active = False


@dataclass
class Product:
    """Represents a product available for purchase."""

    name: str
    description: str
    price: Decimal
    sku: str
    stock_quantity: int = 0
    is_available: bool = True
    category: str = "uncategorized"
    created_at: datetime = field(default_factory=datetime.now)
    id: UUID = field(default_factory=uuid4)

    class Meta:
        ordering = ["name"]
        verbose_name = "Product"

    def __str__(self) -> str:
        return f"{self.name} ({self.sku}) - ${self.price}"

    @property
    def is_in_stock(self) -> bool:
        """Check whether the product is currently in stock."""
        return self.stock_quantity > 0 and self.is_available

    def reduce_stock(self, quantity: int) -> None:
        """Reduce stock by given quantity. Raises ValueError if insufficient."""
        if quantity > self.stock_quantity:
            raise ValueError(
                f"Insufficient stock: requested {quantity}, available {self.stock_quantity}"
            )
        self.stock_quantity -= quantity


@dataclass
class OrderItem:
    """Single line item within an order."""

    product: Product
    quantity: int
    unit_price: Decimal
    id: UUID = field(default_factory=uuid4)

    def __str__(self) -> str:
        return f"{self.quantity}x {self.product.name}"

    @property
    def total_price(self) -> Decimal:
        """Calculate total price for this line item."""
        return self.unit_price * self.quantity


@dataclass
class Order:
    """Represents a customer order containing one or more items."""

    user: User
    items: list[OrderItem] = field(default_factory=list)
    status: OrderStatus = OrderStatus.PENDING
    notes: Optional[str] = None
    created_at: datetime = field(default_factory=datetime.now)
    updated_at: Optional[datetime] = None
    id: UUID = field(default_factory=uuid4)

    class Meta:
        ordering = ["-created_at"]
        verbose_name = "Order"

    def __str__(self) -> str:
        return f"Order {self.id} by {self.user.username} [{self.status.value}]"

    @property
    def total(self) -> Decimal:
        """Calculate the total value of all items in the order."""
        return sum((item.total_price for item in self.items), Decimal("0"))

    @property
    def item_count(self) -> int:
        """Return total number of individual products in the order."""
        return sum(item.quantity for item in self.items)

    def add_item(self, product: Product, quantity: int) -> OrderItem:
        """Add a product to the order."""
        item = OrderItem(product=product, quantity=quantity, unit_price=product.price)
        self.items.append(item)
        self.updated_at = datetime.now()
        return item

    def cancel(self) -> None:
        """Cancel this order if it has not been shipped yet."""
        if self.status in (OrderStatus.SHIPPED, OrderStatus.DELIVERED):
            raise ValueError(f"Cannot cancel order in {self.status.value} state")
        self.status = OrderStatus.CANCELLED
        self.updated_at = datetime.now()

    @classmethod
    def create_from_cart(cls, user: User, cart_items: list[tuple[Product, int]]) -> Order:
        """Create an order from a list of (product, quantity) tuples."""
        order = cls(user=user)
        for product, qty in cart_items:
            order.add_item(product, qty)
        return order
