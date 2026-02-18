# Cwiczenie 12: Makra

> Powiazana lekcja: `lessons/12-makra.md`

## Instrukcje
- `q{reg}` -- rozpocznij nagrywanie do rejestru (a-z)
- `q` -- zakoncz nagrywanie
- `@{reg}` -- odtworz makro
- `@@` -- powtorz ostatnie makro
- `{count}@{reg}` -- odtworz N razy
- `q{REG}` (duza litera) -- dopisz do istniejacego makra
- `:reg {reg}` -- podejrzyj zawartosc rejestru
- `"ap` / `"ay$` -- wklej/skopiuj makro do edycji
- Zasady: zaczynaj od `0` lub `^`, koncz na `j`, uzywaj `f`/`/` zamiast `w` wielokrotnie

## Cwiczenie 1: Log entries do obiektow

Przeksztalc logi w obiekty TypeScript. Kazda linia to log w formacie `LEVEL [timestamp] message`.

```
INFO [2024-03-15 08:30:01] Server started on port 3000
WARN [2024-03-15 08:31:15] Slow query detected: 2.3s
ERROR [2024-03-15 08:32:00] Connection refused: database
INFO [2024-03-15 08:33:10] User login: admin@example.com
ERROR [2024-03-15 08:34:22] Out of memory: heap allocation
WARN [2024-03-15 08:35:05] Rate limit approaching: 95%
INFO [2024-03-15 08:36:00] Backup completed successfully
ERROR [2024-03-15 08:37:11] Timeout: external API /payments
```

Oczekiwany wynik (pierwsza linia):
```typescript
{ level: "INFO", timestamp: "2024-03-15 08:30:01", message: "Server started on port 3000" },
```

Makro (rejestr `a`):
```
qa
0                         -- poczatek linii
i{ level: "<Esc>          -- wstaw poczatek
f[s", timestamp: "<Esc>   -- zamien [ na separator
f]s", message: "<Esc>     -- zamien ] na separator
A" },<Esc>                -- zamknij na koncu
j                         -- nastepna linia
q
```

Przetestuj na jednej linii (`@a`), potem `7@a` na reszcie.

## Cwiczenie 2: Dodaj type annotations do Python

Dodaj type hints do kazdej funkcji. Format: `def func(param)` -> `def func(param: str) -> None`:

```python
def send_email(recipient):
    pass

def validate_token(token):
    pass

def parse_config(filename):
    pass

def create_backup(source):
    pass

def encrypt_data(plaintext):
    pass

def compress_file(filepath):
    pass
```

Makro:
```
qa
0f(a: str<Esc>    -- dodaj `: str` po argumencie
f)a -> None<Esc>  -- dodaj `-> None` po nawiasie
j                  -- nastepna linia (puste: pass)
j                  -- przeskocz `pass` i pusta linie
j                  -- do nastepnej funkcji
q
```

Odtworz: `5@a`

## Cwiczenie 3: Markdown tabela z danych

Przeksztalc dane rozdzielone `|` w sformatowana tabele markdown:

```
name|type|default|description
host|string|localhost|Database host address
port|number|5432|Database port number
database|string|mydb|Database name
username|string|admin|Connection username
password|string||Connection password
ssl|boolean|false|Enable SSL connection
timeout|number|30|Connection timeout in seconds
pool_size|number|10|Maximum pool connections
```

Makro (dodaj spacje wokol `|`):
```
qa
0
:s/|/ | /g<CR>   -- zamien | na " | " (ze spacjami)
I| <Esc>          -- dodaj "| " na poczatku
A |<Esc>          -- dodaj " |" na koncu
j
q
```

Po pierwszej linii (naglowku) dodaj recznie linie separatora: `|---|---|---|---|`

## Cwiczenie 4: Import refaktoring

Przeksztalc default importy na named importy:

```javascript
import React from "react";
import Express from "express";
import Mongoose from "mongoose";
import Lodash from "lodash";
import Axios from "axios";
import Chalk from "chalk";
import Dotenv from "dotenv";
import Cors from "cors";
```

Cel: `import React from "react";` -> `import { React } from "react";`

Makro:
```
qa
0f<Space>a{<Esc>        -- wstaw { po "import "
f<Space>i}<Esc>          -- wstaw } przed " from"
j
q
```

Odtworz: `7@a`

## Cwiczenie 5: Generowanie test boilerplate

Wygeneruj szkielet testu dla kazdej nazwy funkcji:

```
calculateTotal
validateEmail
formatCurrency
parseDate
generateToken
hashPassword
```

Cel:
```typescript
describe("calculateTotal", () => {
    it("should work correctly", () => {
        // TODO: implement
    });
});
```

Makro:
```
qa
0                                     -- poczatek
idescribe("<Esc>                      -- otworz describe
A", () => {<Esc>                      -- zamknij
o    it("should work correctly", () => {<Esc>  -- dodaj it
o        // TODO: implement<Esc>      -- placeholder
o    });<Esc>                         -- zamknij it
o});<Esc>                             -- zamknij describe
o<Esc>                                -- pusta linia
j                                     -- do nastepnej nazwy
q
```

## Cwiczenie 6: Edycja istniejacego makra

1. Nagraj proste makro: `qa0I// <Esc>jq` (dodaje `//` na poczatku linii)
2. Sprawdz zawartosc: `:reg a`
3. Otwierz pusta linie, wklej: `"ap`
4. Zmien `//` na `#` (bo potrzebujesz Python-owych komentarzy)
5. Skopiuj do rejestru: `0"ay$`
6. Usun linie: `dd`
7. Przetestuj na tym kodzie:

```python
result = fetch_data(url)
processed = transform(result)
saved = store(processed)
cleanup(result, processed)
notify_complete(saved)
```

## Cwiczenie 7: Makro z wyszukiwaniem

Dodaj `async` przed kazdym `function` w pliku:

```typescript
const config = loadConfig();

function fetchUsers() {
    return api.get("/users");
}

const cache = new Map();

function createOrder(data) {
    return api.post("/orders", data);
}

const logger = getLogger();

function processPayment(amount) {
    return api.post("/payments", { amount });
}

const secret = process.env.SECRET;

function sendNotification(userId, message) {
    return api.post(`/notify/${userId}`, { message });
}
```

Makro z wyszukiwaniem:
```
qa
/function<CR>      -- znajdz nastepne "function"
Iasync <Esc>       -- wstaw "async " na poczatku
q
```

Odtworz: `3@a` (lub `100@a` -- zatrzyma sie samo gdy braknie trafien).

## Cwiczenie bonusowe

**Makro rekurencyjne**: Przeksztalc kazda linie env w export:

```
DATABASE_URL=postgres://localhost:5432/mydb
REDIS_URL=redis://localhost:6379
SECRET_KEY=super-secret-key-123
API_PORT=8080
LOG_LEVEL=debug
CACHE_TTL=3600
CORS_ORIGIN=http://localhost:3000
JWT_EXPIRY=24h
```

Cel: `DATABASE_URL=postgres://...` -> `export DATABASE_URL="postgres://..."`

1. `qaq` -- wyczysc rejestr `a`
2. Nagraj makro rekurencyjne:
```
qa
0iexport <Esc>      -- dodaj "export " na poczatku
f=a"<Esc>           -- wstaw " po znaku =
A"<Esc>             -- dodaj " na koncu
j                   -- nastepna linia
@a                  -- rekurencja!
q
```
3. `@a` -- makro przetworzy wszystkie linie do konca

**Wyzwanie**: Nagraj makro `b`, ktore uzywa `@a` wewnatrz -- makro w makrze.
