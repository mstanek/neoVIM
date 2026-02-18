# Cwiczenie 11: Flash.nvim -- blyskawiczna nawigacja

> Powiazana lekcja: `lessons/11-flash-nvim.md`

## Instrukcje
- `s` + tekst + label -- Flash jump (Normal / Visual / operator-pending)
- `S` -- Flash Treesitter select (zaznaczanie node'ow AST)
- `r` -- Remote Flash (tylko operator-pending, kursor wraca po operacji)
- `f`/`t` dzialaja natywnie (Flash ich nie nadpisuje)
- Flash dziala inkrementalnie -- po kazdym znaku zaweza wyniki
- Flash dziala tylko na widocznym tekscie (off-screen uzyj `/`)

## Cwiczenie 1: Nawigacja po klasach

Uzyj `s` aby skakac miedzy klasami w tym kodzie. Zacznij od gory pliku (`gg`).

```python
class DatabaseConnection:
    def __init__(self, host, port, dbname):
        self.host = host
        self.port = port
        self.dbname = dbname
        self.conn = None

    def connect(self):
        self.conn = psycopg2.connect(
            host=self.host, port=self.port, dbname=self.dbname
        )

    def disconnect(self):
        if self.conn:
            self.conn.close()


class QueryBuilder:
    def __init__(self):
        self.table = None
        self.conditions = []
        self.order_by = None
        self.limit_val = None

    def select(self, table):
        self.table = table
        return self

    def where(self, condition):
        self.conditions.append(condition)
        return self

    def build(self):
        query = f"SELECT * FROM {self.table}"
        if self.conditions:
            query += " WHERE " + " AND ".join(self.conditions)
        return query


class MigrationRunner:
    def __init__(self, db):
        self.db = db
        self.applied = []

    def run(self, migration):
        self.db.connect()
        migration.apply(self.db.conn)
        self.applied.append(migration.name)
        self.db.disconnect()

    def rollback(self, migration):
        self.db.connect()
        migration.revert(self.db.conn)
        self.applied.remove(migration.name)
        self.db.disconnect()
```

1. `gg` -- poczatek pliku
2. `s` + `Query` -- przeskocz do `QueryBuilder`
3. `s` + `Migra` -- przeskocz do `MigrationRunner`
4. `s` + `Datab` -- wroc do `DatabaseConnection`
5. `s` + `def b` -- przeskocz do metody `build`
6. `s` + `rollb` -- przeskocz do metody `rollback`

## Cwiczenie 2: Flash w Visual mode -- zaznaczanie zakresu

Zaznacz fragmenty kodu uzywajac `v` + `s`:

```typescript
export function processPayment(order: Order): PaymentResult {
    const tax = calculateTax(order.total, order.region);
    const shipping = calculateShipping(order.items, order.address);
    const discount = applyPromoCode(order.promoCode, order.total);

    const finalAmount = order.total + tax + shipping - discount;

    if (finalAmount <= 0) {
        return { status: "error", message: "Invalid amount" };
    }

    const transaction = createTransaction(finalAmount, order.paymentMethod);
    const receipt = generateReceipt(transaction, order);

    sendConfirmation(order.email, receipt);
    updateInventory(order.items);
    logTransaction(transaction);

    return { status: "success", transactionId: transaction.id };
}
```

1. Kursor na `const tax` -- `V` -- `s` + `final` + label przy `finalAmount` -- zaznaczyles 3 linie
2. `Esc` -- anuluj
3. Kursor na `const transaction` -- `V` -- `s` + `logTr` -- zaznaczyles blok operacji
4. `Esc`

## Cwiczenie 3: Flash z operatorami

Uzyj `d`, `y`, `c` w polaczeniu z Flash (`s`):

```python
def generate_report(data, format_type, include_header=True):
    header = create_header(data.title) if include_header else ""
    rows = [format_row(row, format_type) for row in data.items]
    footer = create_footer(len(rows))
    separator = "-" * 80

    output = header + separator
    for row in rows:
        output += row + "\n"
    output += separator + footer

    return output
```

1. Kursor na poczatku `header = create_header...`
2. `d` + `s` + `separ` + label -- usun od `header` do `separator`
3. `u` -- cofnij
4. Kursor na `output = header`
5. `y` + `s` + `return` + label -- skopiuj od `output` do `return`
6. `u` -- cofnij

## Cwiczenie 4: Treesitter select

Uzyj `S` aby zaznaczac strukturalne elementy kodu:

```python
class ShoppingCart:
    def __init__(self):
        self.items = []
        self.coupon = None

    def add_item(self, product, quantity=1):
        for item in self.items:
            if item.product.id == product.id:
                item.quantity += quantity
                return
        self.items.append(CartItem(product, quantity))

    def remove_item(self, product_id):
        self.items = [i for i in self.items if i.product.id != product_id]

    def apply_coupon(self, coupon_code):
        coupon = validate_coupon(coupon_code)
        if coupon and coupon.is_valid():
            self.coupon = coupon
            return True
        return False

    def get_total(self):
        subtotal = sum(i.product.price * i.quantity for i in self.items)
        if self.coupon:
            subtotal *= (1 - self.coupon.discount / 100)
        return round(subtotal, 2)
```

1. Kursor wewnatrz `add_item` -- `S` -- wybierz label przy calej metodzie
2. `Esc`
3. Kursor wewnatrz `for item in self.items:` -- `S` -- wybierz label przy `for_statement`
4. `Esc`
5. Kursor wewnatrz `if coupon and coupon.is_valid():` -- `S` -- wybierz `if_statement`
6. `Esc`

## Cwiczenie 5: Remote Flash

Skopiuj tekst z odleglego miejsca bez przesuwania kursora (`yr`):

```typescript
const CONFIG = {
    apiUrl: "https://api.production.com/v2",
    timeout: 5000,
    retries: 3,
    cacheTime: 3600,
};

// Kursor tutaj - chcesz skopiowac wartosci z CONFIG
const devConfig = {
    apiUrl: "",
    timeout: 0,
    retries: 0,
    cacheTime: 0,
};
```

1. Kursor na pustym stringu `""` w `devConfig.apiUrl`
2. `yr` -- yank + Remote Flash
3. Wpisz `prod` -- Flash podswietli `production` w CONFIG
4. Nacisnij label -- przeskocz tam
5. `i"` -- skopiuj inner string (caly URL)
6. Kursor wraca! Uzyj `p` aby wkleic
7. `u` -- cofnij

## Cwiczenie 6: Flash do precyzyjnej nawigacji

Nawiguj po dlugim pliku uzywajac Flash zamiast `/`:

```python
import os
import sys
import json
import logging
from pathlib import Path
from datetime import datetime, timedelta
from typing import Optional, List, Dict

logger = logging.getLogger(__name__)

def load_config(path: str) -> Dict:
    with open(path) as f:
        return json.load(f)

def save_config(path: str, data: Dict) -> None:
    with open(path, "w") as f:
        json.dump(data, f, indent=2)

def validate_path(path: str) -> Optional[Path]:
    p = Path(path)
    if p.exists() and p.is_file():
        return p
    logger.warning(f"Invalid path: {path}")
    return None

def parse_timestamp(ts: str) -> Optional[datetime]:
    formats = ["%Y-%m-%d", "%Y-%m-%dT%H:%M:%S", "%d/%m/%Y"]
    for fmt in formats:
        try:
            return datetime.strptime(ts, fmt)
        except ValueError:
            continue
    return None

def calculate_age(birth: datetime) -> int:
    today = datetime.now()
    age = today.year - birth.year
    if (today.month, today.day) < (birth.month, birth.day):
        age -= 1
    return age

def format_duration(seconds: int) -> str:
    hours = seconds // 3600
    minutes = (seconds % 3600) // 60
    secs = seconds % 60
    return f"{hours:02d}:{minutes:02d}:{secs:02d}"
```

Przeskakuj miedzy funkcjami uzywajac `s`:
1. `s` + `parse` -- do `parse_timestamp`
2. `s` + `calc` -- do `calculate_age`
3. `s` + `format_d` -- do `format_duration`
4. `s` + `validate` -- do `validate_path`
5. `s` + `save` -- do `save_config`

## Cwiczenie bonusowe

**Flash + operatory challenge**: Wykonaj te operacje uzywajac Flash:

```python
class EventBus:
    def __init__(self):
        self.subscribers = {}
        self.history = []
        self.middleware = []

    def subscribe(self, event_type, callback):
        if event_type not in self.subscribers:
            self.subscribers[event_type] = []
        self.subscribers[event_type].append(callback)

    def unsubscribe(self, event_type, callback):
        if event_type in self.subscribers:
            self.subscribers[event_type].remove(callback)

    def emit(self, event_type, data=None):
        self.history.append({"type": event_type, "data": data})
        for mw in self.middleware:
            data = mw(event_type, data)
        for cb in self.subscribers.get(event_type, []):
            cb(data)

    def add_middleware(self, fn):
        self.middleware.append(fn)

    def get_history(self):
        return list(self.history)

    def clear(self):
        self.subscribers.clear()
        self.history.clear()
        self.middleware.clear()
```

1. Z poczatku pliku -- `yr` + Flash do `emit` + `iw` -- skopiuj slowo "emit" zdalnie
2. Kursor na `subscribe` -- `ds` + Flash do `unsubscribe` -- usun tekst miedzy nimi
3. `u` -- cofnij
4. Uzyj `S` (Treesitter) aby zaznaczac po kolei: cala klase, metode `emit`, blok `for`
5. Kursor na `def clear` -- `V` + `s` + `__init` -- zaznacz od `clear` do `__init__` (caly zakres)
6. `Esc` -- anuluj
