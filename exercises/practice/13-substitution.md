# Cwiczenie 13: Substitution

> Powiazana lekcja: `lessons/13-substitution.md`

## Instrukcje
- `:[range]s/pattern/replacement/[flags]` -- podstawowa skladnia
- `%` -- caly plik; `'<,'>` -- zaznaczenie Visual; `.,.+5` -- biezaca + 5 linii
- Flagi: `g` (global), `c` (confirm), `i` (case insensitive), `n` (count only)
- `\v` -- very magic mode (mniej backslashy w regex)
- `\1`-`\9` -- backreferences do grup `()`
- `\U`, `\L` -- uppercase/lowercase; `\u`, `\l` -- jeden znak
- `&` / `\0` -- caly match
- `inccommand=split` -- podglad zmian na zywo (Twoja konfiguracja!)

## Cwiczenie 1: Prosta zamiana nazw

Obserwuj podglad na zywo (inccommand=split) -- nie naciskaj Enter od razu!

```python
class UserManager:
    def get_user(self, user_id):
        user = self.db.find_user(user_id)
        if not user:
            raise UserNotFoundError(f"User {user_id} not found")
        return user

    def update_user(self, user_id, data):
        user = self.get_user(user_id)
        user.update(data)
        self.db.save_user(user)
        return user

    def delete_user(self, user_id):
        user = self.get_user(user_id)
        self.db.remove_user(user_id)
        return user
```

1. `:%s/user/account/g` -- obserwuj preview... za duzo zmian! (zmienia tez `user_id`)
2. `Esc` -- anuluj
3. `:%s/\buser\b/account/g` -- hmm, Vim uzywa `\<` i `\>` na granice slow
4. `:%s/\<user\>/account/g` -- teraz zmienia tylko samo slowo "user"
5. `Esc` -- anuluj
6. `:%s/User/Account/g` -- zmien z zachowaniem wielkosci liter
7. `Esc`

## Cwiczenie 2: Regex z grupami -- zamiana kolejnosci

Zamien `key: value` na `value -> key`:

```yaml
name: John
age: 30
city: Warsaw
role: developer
team: backend
level: senior
status: active
joined: 2023
```

1. Zaznacz linie w Visual Line (`V`)
2. `:'<,'>s/\v(\w+): (.+)/\2 -> \1/`
3. Obserwuj preview -- kolejnosc sie zamienia!
4. `Enter` -- `u`

## Cwiczenie 3: snake_case na camelCase

Zamien nazwy zmiennych:

```python
user_name = "Jan"
first_name = "Jan"
last_name = "Kowalski"
email_address = "jan@example.com"
phone_number = "+48123456789"
date_of_birth = "1990-01-15"
postal_code = "00-001"
street_address = "Marszalkowska 1"
```

1. Zaznacz blok
2. `:'<,'>s/\v_([a-z])/\u\1/g`
3. Preview: `user_name` -> `userName`, `first_name` -> `firstName`
4. `Enter` -- `u`

## Cwiczenie 4: Dodawanie prefixow/suffixow

Dodaj `export` na poczatku i `;` na koncu kazdej linii:

```typescript
const API_URL = "https://api.example.com"
const API_KEY = "sk-1234567890"
const TIMEOUT = 5000
const MAX_RETRIES = 3
const LOG_LEVEL = "info"
const CACHE_TTL = 3600
const BATCH_SIZE = 100
const RATE_LIMIT = 60
```

1. Zaznacz blok
2. `:'<,'>s/^/export /` -- dodaj `export ` na poczatku
3. `u` -- cofnij
4. `:'<,'>s/$/;/` -- dodaj `;` na koncu
5. `u` -- cofnij
6. Obydwa naraz: `:'<,'>s/\v^(.+)$/export \1;/`

## Cwiczenie 5: HTML entity encoding

Zamien znaki specjalne na HTML entities:

```html
<p>Price: 5 < 10 & 10 > 5</p>
<p>Tom & Jerry -- "Best Friends"</p>
<p>if (x < y && y > z) { return true; }</p>
<p>Company: Smith & Sons -- est. 1990</p>
<p>"Hello" & 'World' -- <special></p>
```

Wykonaj po kolei (kazda zamiana na calym bloku):
1. `:'<,'>s/&/\&amp;/g` -- zamien `&` na `&amp;`
2. `:'<,'>s/</\&lt;/g` -- zamien `<` na `&lt;` (uwaga: to zamieni tez tagi!)
3. `u` wielokrotnie -- cofnij i sprobuj bardziej precyzyjnie

## Cwiczenie 6: camelCase na UPPER_SNAKE_CASE

Zamien nazwy stalych:

```javascript
const apiBaseUrl = "https://api.com";
const maxRetryCount = 5;
const defaultTimeout = 3000;
const cacheExpiry = 86400;
const sessionDuration = 1800;
const requestBatchSize = 50;
```

Dwuetapowa zamiana:
1. Zaznacz blok -- camelCase -> snake_case:
   `:'<,'>s/\v([a-z])([A-Z])/\1_\2/g`
2. snake_case -> UPPER (tylko nazwy zmiennych, nie wartosci):
   `:'<,'>s/\v(const )(\w+)/\1\U\2/g`
3. `u` wielokrotnie -- cofnij

## Cwiczenie 7: Zamiana z potwierdzeniem

Uzyj flagi `c` aby selektywnie zamienic `console.log` na `logger.info`:

```typescript
function processOrder(order: Order) {
    console.log("Processing order:", order.id);
    const validated = validateOrder(order);
    console.log("Validation result:", validated);

    if (!validated) {
        console.log("Order validation failed");
        return { error: "Invalid order" };
    }

    const payment = chargePayment(order);
    console.log("Payment processed:", payment.id);

    console.log("Order completed successfully");
    return { success: true, paymentId: payment.id };
}
```

1. `:%s/console\.log/logger.info/gc`
2. Przy kazdym trafieniu: `y` (zamien) lub `n` (pomin)
3. Zamien wszystkie oprocz "Order validation failed" (ten zostawimy jako `console.log`)
4. `u` -- cofnij

## Cwiczenie 8: Transformacja importow

Zamien CommonJS require na ES6 import:

```javascript
const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const helmet = require("helmet");
const morgan = require("morgan");
const dotenv = require("dotenv");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");
```

Regex z grupami:
1. Zaznacz blok
2. `:'<,'>s/\vconst (\w+) \= require\("(\w+)"\);/import \1 from "\2";/`
3. Preview: `const express = require("express");` -> `import express from "express";`
4. `Enter` -- `u`

Bonus -- zamien na named import: `import { express } from "express";`
`:'<,'>s/\vconst (\w+) \= require\("(\w+)"\);/import { \1 } from "\2";/`

## Cwiczenie bonusowe

**Multi-step refactoring**: Wykonaj pelna konwersje tego kodu:

```python
def get_user_data(user_name, user_email, user_role):
    print(f"Fetching data for {user_name}")
    user_record = db.query("SELECT * FROM users WHERE name = %s", user_name)
    print(f"Found record: {user_record}")
    user_data = {
        "user_name": user_name,
        "user_email": user_email,
        "user_role": user_role,
        "user_status": "active",
    }
    print(f"Returning: {user_data}")
    return user_data

def update_user_data(user_name, new_email, new_role):
    print(f"Updating {user_name}")
    db.execute("UPDATE users SET email = %s, role = %s WHERE name = %s",
               new_email, new_role, user_name)
    print(f"Updated successfully")
    return get_user_data(user_name, new_email, new_role)
```

Krok po kroku (zaznacz caly blok przed kazda operacja):
1. Zamien `print(` na `logger.debug(`: `:'<,'>s/print(/logger.debug(/g`
2. Zamien `user_name` na `username` (bez podkreslnika): `:'<,'>s/user_name/username/g`
3. Zamien `user_email` na `email`: `:'<,'>s/user_email/email/g`
4. Zamien `user_role` na `role`: `:'<,'>s/user_role/role/g`
5. Zamien `user_data` na `profile`: `:'<,'>s/user_data/profile/g`
6. Zamien `user_record` na `record`: `:'<,'>s/user_record/record/g`
7. Zamien `user_status` na `status`: `:'<,'>s/user_status/status/g`

**Regex golf**: Sprobuj zrobic to w mniejszej liczbie komend uzywajac `\v` i grup.
