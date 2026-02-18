# Cwiczenie 10: Komentarze i wciecia

> Powiazana lekcja: `lessons/10-komentarze-indent.md`

## Instrukcje
- `gcc` -- toggle komentarz na biezacej linii
- `gc{motion}` -- toggle komentarz na zakresie (np. `gcap`, `gc3j`, `gci}`)
- `gc` (Visual) -- toggle komentarz na zaznaczeniu
- `gco` / `gcO` / `gcA` -- nowy komentarz ponizej / powyzej / na koncu linii
- `>>` / `<<` -- indent / outdent linii (Normal)
- `>` / `<` (Visual) -- indent / outdent zaznaczenia (zaznaczenie zostaje!)
- `==` -- auto-indent linii; `gg=G` -- auto-indent calego pliku
- `>ap`, `>i}` -- indent z operatorem i text object

## Cwiczenie 1: Toggle komentarzy w Python

Zakomentuj i odkomentuj poszczegolne linie uzywajac `gcc`:

```python
def calculate_discount(price, discount_percent):
    if discount_percent < 0:
        raise ValueError("Discount cannot be negative")
    if discount_percent > 100:
        raise ValueError("Discount cannot exceed 100%")
    discount = price * discount_percent / 100
    final_price = price - discount
    return round(final_price, 2)
```

1. `gcc` na linii `if discount_percent < 0:` -- zakomentuj
2. `gcc` ponownie -- odkomentuj
3. `gcc` na `discount = price * ...` -- zakomentuj
4. `gcc` na `final_price = ...` -- zakomentuj
5. Cofnij: `u` wielokrotnie

## Cwiczenie 2: Komentowanie z motion

Uzyj `gc` z roznymi motions:

```typescript
interface UserSettings {
    theme: string;
    language: string;
    notifications: boolean;
    autoSave: boolean;
    fontSize: number;
    showSidebar: boolean;
}

function applySettings(settings: UserSettings): void {
    document.body.className = settings.theme;
    setLanguage(settings.language);
    toggleNotifications(settings.notifications);
    enableAutoSave(settings.autoSave);
}
```

1. Kursor na `interface` -- `gcap` -- zakomentuj caly interface
2. Cofnij: `u`
3. Kursor na `theme: string` -- `gc3j` -- zakomentuj 4 linie (theme do notifications)
4. Cofnij: `u`
5. Kursor wewnatrz ciala `applySettings` -- `gci{` -- zakomentuj wnetrze funkcji
6. Cofnij: `u`

## Cwiczenie 3: Komentarze w trybie Visual

Zaznacz bloki kodu i zakomentuj je:

```python
class Logger:
    def __init__(self, name):
        self.name = name
        self.handlers = []
        self.level = "INFO"

    def add_handler(self, handler):
        self.handlers.append(handler)

    def info(self, message):
        self._log("INFO", message)

    def error(self, message):
        self._log("ERROR", message)

    def debug(self, message):
        self._log("DEBUG", message)

    def _log(self, level, message):
        for handler in self.handlers:
            handler.write(f"[{level}] {self.name}: {message}")
```

1. `V` na `def add_handler` -- zaznacz cala metode (do `self.handlers...`) -- `gc`
2. Cofnij: `u`
3. Zaznacz metody `info`, `error`, `debug` razem (ok. 9 linii) -- `gc`
4. Cofnij: `u`

## Cwiczenie 4: Dodawanie komentarzy inline

Uzyj `gcA`, `gco`, `gcO`:

```python
MAX_RETRIES = 3
TIMEOUT = 30
BASE_URL = "https://api.example.com"
API_VERSION = "v2"
DEBUG_MODE = False
```

1. Kursor na `MAX_RETRIES` -- `gcA` -- wpisz: `maximum number of retries` -- `Esc`
2. Kursor na `TIMEOUT` -- `gcA` -- wpisz: `in seconds` -- `Esc`
3. Kursor na `DEBUG_MODE` -- `gco` -- wpisz: `set to True for verbose logging` -- `Esc`
4. Kursor na `BASE_URL` -- `gcO` -- wpisz: `API configuration` -- `Esc`

## Cwiczenie 5: Indentacja w Visual mode

Wciecia sa zle -- napraw je uzywajac `>` i `<` w Visual mode (zaznaczenie zostaje!):

```python
def process_orders(orders):
for order in orders:
if order.status == "pending":
validate(order)
calculate_total(order)
if order.total > 1000:
apply_discount(order)
send_notification(order)
save(order)
return orders
```

1. Zaznacz linie od `for` do `return orders` (Visual Line: `V`)
2. Nacisnij `>` -- wciecie o 1 poziom (zaznaczenie zostaje!)
3. Teraz zaznacz linie od `if order.status` do `save(order)` -- `>` jeszcze raz
4. Zaznacz `validate` do `send_notification` -- `>` jeszcze raz
5. Zaznacz `if order.total` do `send_notification` -- `>` jeszcze raz
6. Zaznacz `apply_discount` i `send_notification` -- `>` jeszcze raz

## Cwiczenie 6: Auto-indent `=`

Ten kod ma zepsute wciecia. Uzyj `==`, `=ap` lub `gg=G`:

```javascript
function fetchUserData(userId) {
const response = fetch(`/api/users/${userId}`);
    if (response.ok) {
  const data = response.json();
            return {
    id: data.id,
        name: data.name,
              email: data.email,
  };
      } else {
throw new Error("Failed to fetch user");
    }
}
```

1. `gg=G` -- auto-indent calego bloku
2. Cofnij: `u`
3. Kursor na `const response` -- `=ap` -- auto-indent paragrafu
4. Cofnij: `u`

## Cwiczenie 7: Indent z operatorem w Normal mode

Uzyj `>` i `<` jako operatorow z motions:

```vue
<template>
<div class="dashboard">
<header>
<h1>Dashboard</h1>
<nav>
<a href="/">Home</a>
<a href="/settings">Settings</a>
</nav>
</header>
<main>
<section>
<p>Welcome back!</p>
</section>
</main>
</div>
</template>
```

1. Kursor na `<div>` -- `>ap` -- indent calego paragrafu (wszystko do `</template>`)
2. Cofnij: `u`
3. Kursor na `<header>` -- `>i>` -- hmm, to nie zadziala. Uzyj `V` + zaznacz do `</header>` + `>`

## Cwiczenie bonusowe

**Workflow: tymczasowe wylaczanie kodu**: Zakomentuj blok, pracuj, odkomentuj.

```python
def sync_data(source, target):
    # Step 1: Fetch
    raw_data = source.fetch_all()
    validated = validate_schema(raw_data)

    # Step 2: Transform
    transformed = apply_mappings(validated)
    enriched = enrich_with_metadata(transformed)

    # Step 3: Load
    target.bulk_insert(enriched)
    target.update_indexes()

    return {"synced": len(enriched), "status": "ok"}
```

1. Zakomentuj caly Step 2 (`vip` na bloku Transform, `gc`)
2. Zakomentuj caly Step 3 (`vip` na bloku Load, `gc`)
3. Odkomentuj Step 2 (`vip` + `gc`)
4. Odkomentuj Step 3 (`vip` + `gc`)
5. Dodaj `gcA` do `sync_data`: `needs error handling`
6. Uzyj `gco` pod `return` aby dodac komentarz: `log sync result`
