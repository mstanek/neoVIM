# Cwiczenie 06: Szukanie (search)

> Powiazana lekcja: `lessons/06-szukanie.md`

## Instrukcje
- Szukanie: `/{pattern}` (w przod), `?{pattern}` (w tyl)
- Nawigacja: `n` (nastepny), `N` (poprzedni)
- Slowo pod kursorem: `*` (whole word, w przod), `#` (w tyl), `g*`/`g#` (partial)
- Czyszczenie podswietlenia: `Esc` lub `Space Space`
- Search & Replace: `:%s/foo/bar/g` (caly plik), `:%s/foo/bar/gc` (z potwierdzeniem)
- Flagi: `g` (global), `c` (confirm), `n` (count only), `i`/`I` (case)
- Regex: `\v` (very magic), `\V` (literal), `\<\>` (word boundary)
- Config: `smartcase`, `ignorecase`, `inccommand=split`, `hlsearch`, `incsearch`

## Cwiczenie 1: Wyszukiwanie z smartcase

Ponizszy tekst zawiera rozne warianty wielkosci liter. Sprawdz jak `smartcase` wplywa
na wyniki wyszukiwania.

```
The React framework is popular for building UIs.
react components should be reusable and composable.
REACT is maintained by Meta (formerly Facebook).
ReactDOM renders React components to the DOM.
A reactive programming model differs from React.
Reactivity in Vue is based on proxies, not React patterns.
```

Zadania:
1. `/react` + Enter -- znajdzie WSZYSTKO (lowercase = ignorecase). Policz wyniki: ___
2. `Esc` -- czysc. `/React` + Enter -- znajdzie TYLKO `React` (wielka litera = case-sensitive). Policz: ___
3. `Esc`. `/REACT` + Enter -- znajdzie TYLKO `REACT`. Policz: ___
4. `Esc`. `/react\C` + Enter -- force case-sensitive, lowercase. Policz: ___
5. `Esc`. `/React\c` + Enter -- force case-insensitive. Policz: ___ (powinno byc tyle co w pkt 1)

## Cwiczenie 2: Star search -- * vs g*

Uzyj `*` i `g*` na slowie `item` w ponizszym kodzie. Porownaj wyniki.

```python
def process_items(items):
    for item in items:
        if item.is_valid():
            item_data = transform(item)
            item_list.append(item_data)
    return item_list

def get_item(item_id):
    """Get single item by ID."""
    return find_item_by_id(item_id)

def delete_item(item_id):
    """Delete item permanently."""
    remove_item(item_id)
```

Zadania:
1. Kursor na `item` w `for item in items` (linia 2)
2. `*` -- szuka `\<item\>` (whole word). `n` kilka razy. Ile matchow? ___
   (nie znajdzie `items`, `item_data`, `item_list`, `item_id`)
3. `Esc`. Kursor ponownie na `item`
4. `g*` -- szuka `item` (partial). `n` kilka razy. Ile matchow? ___
   (znajdzie WSZYSTKO zawierajace `item`)

## Cwiczenie 3: Search as motion -- usuwanie z wyszukiwaniem

Uzyj `/pattern` jako motion z operatorami.

```python
# Usun wszystko od poczatku do "class":
import os
import sys
from pathlib import Path

CONSTANT_A = 42
CONSTANT_B = "hello"

class UserService:
    def __init__(self):
        self.users = []

    def add_user(self, name):
        self.users.append(name)

    def remove_user(self, name):
        self.users.remove(name)
```

Zadania (po kazdym `u`):
1. Kursor na `import os` (linia 2). `d/class` + Enter -- usun od kursora do `class`
2. Kursor na `def __init__`. `y/def remove` + Enter -- kopiuj od `__init__` do `remove_user`
3. Kursor na `CONSTANT_A`. `d/class` + Enter -- usun stale i puste linie
4. Kursor na `import os`. `d/CONSTANT` + Enter -- usun importy

## Cwiczenie 4: Search & Replace z inccommand

Cwicz substitute z podgladem na zywo (`inccommand=split`).

```python
def calculate_user_score(user_data):
    user_name = user_data["name"]
    user_email = user_data["email"]
    user_age = user_data["age"]
    user_score = compute_score(user_name, user_email, user_age)
    log_user_action(user_name, "score_calculated", user_score)
    return {"user": user_name, "score": user_score}
```

Zadania:
1. `:%s/user/account/g` -- ale NIE naciskaj Enter! Obserwuj:
   - W pliku podswietlone `user` z podgladem zamiany
   - Na dole ekranu split window ze wszystkimi zmianami
   - UWAGA: zamieni tez `user` w `user_data`, `user_name` itd.!
2. `Esc` -- anuluj
3. `:%s/\<user\>/account/g` -- teraz `\<user\>` matchuje TYLKO cale slowo `user`.
   Obserwuj podglad -- ile zmian? `Esc`
4. `:%s/user_/account_/g` -- zamien prefix `user_` na `account_`. Obserwuj. Enter -- wykonaj!
5. `u` -- cofnij

## Cwiczenie 5: Search & Replace w zakresie

Cwicz substitute na wybranym fragmencie pliku.

```typescript
function processOrder(order: Order): Result {
    const total = order.total;
    const tax = order.tax;
    const discount = order.discount;
    const shipping = order.shipping;
    const finalPrice = total + tax - discount + shipping;
    return { price: finalPrice, order: order.id };
}

function processPayment(payment: Payment): Result {
    const amount = payment.amount;
    const method = payment.method;
    const currency = payment.currency;
    return { status: "processed", payment: payment.id };
}
```

Zadania:
1. Zamien `order` na `o` TYLKO w pierwszej funkcji:
   - Sprawdz numery linii funkcji (np. 1-8)
   - `:1,8s/order/o/g` -- zamien w zakresie linii 1-8. Obserwuj inccommand. `Esc` lub Enter + `u`
2. Zamien uzywajac Visual range:
   - `V` na `function processPayment`. Zaznacz cala funkcje w dol
   - `:` -- automatycznie wstawi `'<,'>`
   - `s/payment/p/g` + Enter
   - `u` -- cofnij

## Cwiczenie 6: Zliczanie wystapien

Policz wystapienia roznych patternow w kodzie.

```python
class DataProcessor:
    def __init__(self, data, config=None):
        self.data = data
        self.config = config or {}
        self.results = []

    def process(self):
        for item in self.data:
            result = self._transform(item)
            self.results.append(result)
        return self.results

    def _transform(self, item):
        if self.config.get("uppercase"):
            return item.upper()
        return item

    def export(self, format="json"):
        if format == "json":
            return json.dumps(self.results)
        elif format == "csv":
            return ",".join(self.results)
        return str(self.results)
```

Zadania (uzyj flagi `n` -- count only, bez zamiany):
1. `:%s/self/self/gn` -- ile razy `self`? ___
2. `:%s/\<def\>/def/gn` -- ile metod (definicji)? ___
3. `:%s/return/return/gn` -- ile `return`? ___
4. `:%s/self\.results/self.results/gn` -- ile `self.results`? ___
5. `:%s/format/format/gn` -- ile `format`? ___

## Cwiczenie 7: Regex -- wzorce w wyszukiwaniu

Cwicz wyrazenia regularne na ponizszym tekscie.

```
user1@example.com       -- valid
admin@test.org          -- valid
john.doe@company.co.uk  -- valid
invalid-email           -- invalid
@missing-name.com       -- invalid
no-domain@              -- invalid
support+tag@service.io  -- valid
192.168.1.100           -- IP
10.0.0.1                -- IP
255.255.255.0           -- IP
phone: +48 123 456 789
phone: +1 555 0123
date: 2026-02-18
date: 2025-12-31
```

Zadania:
1. `/\v\w+@\w+\.\w+` -- szukaj emaili (very magic). Ile matchow? ___
2. `Esc`. `/\v\d+\.\d+\.\d+\.\d+` -- szukaj IP. Ile? ___
3. `Esc`. `/\v\d{4}-\d{2}-\d{2}` -- szukaj dat w formacie YYYY-MM-DD. Ile? ___
4. `Esc`. `/\v\+\d+\s\d+\s\d+` -- szukaj telefonow. Ile? ___
5. `Esc`. `/\V.` -- literal search: szukaj dokladnie znaku `.` (kropki). Ile? ___

## Cwiczenie 8: Search & Replace z grupami przechwytujacymi

Zaawansowane zamiany z regex i grupami `\(...\)`.

```python
def get_user_name(user_id):
    pass

def get_user_email(user_id):
    pass

def get_user_age(user_id):
    pass

def get_order_total(order_id):
    pass

def get_order_status(order_id):
    pass
```

Zadania:
1. Dodaj prefix `fetch_` do nazw funkcji zaczynajacych sie od `get_`:
   `:%s/def get_\(\w\+\)/def fetch_\1/g` -- obserwuj inccommand. Enter. `u`
2. Zmien kolejnosc: `user_name` -> `name_user`:
   `:%s/\(\w\+\)_\(\w\+\)(/\2_\1(/g` -- obserwuj podglad. `Esc` (to moze byc destruktywne)
3. Otocz nazwy funkcji w `[]`:
   `:%s/def \(\w\+\)/def [\1]/g` -- podglad. `Esc`

## Cwiczenie bonusowe

Otworz `exercises/python/models.py` i wykonaj nastepujace wyszukiwania i zamiany:

1. Policz ile jest metod w pliku: `:%s/def /def /gn`
2. Policz ile jest klas: `:%s/class /class /gn`
3. Znajdz wszystkie stringi: `/\v"[^"]*"` -- nawiguj `n`/`N`
4. Zamien wszystkie `str` (jako typ) na `String`: `:%s/\<str\>/String/gc` -- potwierdz selektywnie
5. `u` -- cofnij
6. Zamien f-stringi `f"..."` na zwykle stringi `"..."`:
   `:%s/f"/"/g` -- obserwuj inccommand. `Esc`

Wyzwanie: napisz substitute ktory zamieni:
- `self.status = OrderStatus.PENDING` na `self._status = OrderStatus.PENDING`
- czyli doda `_` po `self.` ale TYLKO dla `status`, nie dla innych pol
- Podpowiedz: `:%s/self\.status/self._status/g`
