# Cwiczenie 04: Text objects

> Powiazana lekcja: `lessons/04-text-objects.md`

## Instrukcje
- Formula: `{operator} + i/a + {object}` -- AKCJA + WEWNATRZ/WOKOL + CO
- `i` = inner (bez delimitera), `a` = around (z delimiterem)
- Obiekty: `w` (word), `W` (WORD), `"`, `'`, `` ` ``, `(`, `[`, `{`, `<`, `t` (tag)
- Obiekty `is`/`as` (sentence), `ip`/`ap` (paragraph)
- mini.ai: `if`/`af` (function), `ic`/`ac` (class), `ia`/`aa` (argument), `iq`/`aq` (quote)
- Dziala z: `d`, `c`, `y`, `v` (visual)

## Cwiczenie 1: inner word vs around word -- precyzja

Kursor moze byc GDZIEKOLWIEK w slowie -- text object ogarnie calosc.
Ustaw kursor na dowolnej literze podkreslonych slow i wykonaj operacje.

```python
username = "john_doe"
full_name = "John Michael Doe"
is_active_user = True
max_retry_count = 5
default_timeout_ms = 3000
```

Zadania (po kazdym `u`):
1. Kursor na dowolnej literze `john_doe`. `diw` -- usunie `john_doe`, zostanie `username = ""`
2. Kursor na `Michael`. `daw` -- usunie `Michael ` (ze spacja), zostanie `"John Doe"`
3. Kursor na `True`. `ciw` -> `False` -> `Esc` -- zmieni `True` na `False`
4. Kursor na `5`. `ciw` -> `10` -> `Esc`
5. Kursor na `default`. `diW` -- usunie `default_timeout_ms` (caly WORD bez spacji)

## Cwiczenie 2: Quote objects -- edycja stringow

Zmien zawartosc stringow bez koniecznosci precyzyjnego pozycjonowania kursora.
Wystarczy byc gdziekolwiek wewnatrz cudzyslowow.

```typescript
const apiUrl = "https://old-api.example.com/v1";
const greeting = "Hello, World!";
const query = 'SELECT * FROM legacy_table';
const template = `Dear ${name}, your order #${orderId} is ready`;
const empty = "";
const config = { name: "old-database", host: "192.168.1.100" };
```

Zadania:
1. Kursor wewnatrz `"https://..."`. `ci"` -> `https://new-api.example.com/v2` -> `Esc`
2. Kursor wewnatrz `"Hello..."`. `di"` -- usun zawartosc, zostanie `""`
3. Kursor wewnatrz `'SELECT...'`. `ci'` -> `SELECT id, name FROM new_table` -> `Esc`
4. Kursor wewnatrz `` `Dear...` ``. `` ci` `` -> `` Hi ${name}, order ready `` -> `Esc`
5. Kursor na `""` (empty). `ci"` -> `default value` -> `Esc` -- dziala nawet na pustym stringu!
6. Kursor na `"old-database"`. `ci"` -> `production-db` -> `Esc`
7. Bez wychodzenia z pliku: `yi"` na `"192.168.1.100"` -- kopiuj IP, przejdz gdzies, `p`

## Cwiczenie 3: Bracket objects -- praca z nawiasami

Edytuj zawartosc nawiasow okraglych, kwadratowych i klamrowych.

```python
def send_email(recipient, subject, body, cc=None, bcc=None):
    headers = {"Content-Type": "text/html", "X-Priority": "1"}
    attachments = [report.pdf, summary.xlsx, data.csv]

    if validate(recipient) and check_quota(sender):
        result = mailer.send(
            to=recipient,
            subject=subject,
            html=render_template(body, {"user": recipient}),
        )
    return result
```

Zadania (po kazdym `u`):
1. Kursor wewnatrz `(recipient, subject...)`. `ci(` -> `to, subj, msg` -> `Esc`
2. Kursor wewnatrz `{"Content-Type"...}`. `di{` -- usun zawartosci slownika
3. Kursor wewnatrz `[report.pdf...]`. `ci[` -> `file1, file2` -> `Esc`
4. Kursor wewnatrz `(recipient)` w `validate`. `di(` -- usun argument
5. Kursor wewnatrz zewnetrznego `(` po `mailer.send`. `yi(` -- kopiuj wszystkie argumenty

## Cwiczenie 4: Tag objects -- edycja HTML/Vue templates

Edytuj zawartosc tagow HTML.

```html
<div class="user-profile">
  <h2 class="name">Stary Tytul Profilu</h2>
  <p class="bio">Ten opis jest nieaktualny i powinien zostac zmieniony na nowy</p>
  <ul class="skills">
    <li>JavaScript</li>
    <li>Python</li>
    <li>Rust</li>
  </ul>
  <footer>
    <span class="date">2024-01-15</span>
    <a href="https://example.com">Stary link</a>
  </footer>
</div>
```

Zadania (po kazdym `u`):
1. Kursor na `Stary Tytul Profilu`. `cit` -> `Nowy Tytul` -> `Esc` -- zmien zawartosc h2
2. Kursor na `Ten opis...`. `dit` -- usun zawartosc paragrafu, tag zostaje pusty `<p class="bio"></p>`
3. Kursor na `JavaScript`. `cit` -> `TypeScript` -> `Esc`
4. Kursor na `<li>Python</li>`. `dat` -- usun caly tag (lacznie z `<li>` i `</li>`)
5. Kursor na `2024-01-15`. `cit` -> `2026-02-18` -> `Esc`
6. Kursor na `Stary link`. `cit` -> `Nowy link` -> `Esc`

## Cwiczenie 5: mini.ai -- function i class objects

Pracuj na prawdziwym kodzie z plikami cwiczeniowymi.

```python
class ShoppingCart:
    def __init__(self):
        self.items = []
        self.discount = 0

    def add_item(self, product, quantity=1):
        """Add item to cart."""
        item = {"product": product, "qty": quantity}
        self.items.append(item)
        return self

    def remove_item(self, product):
        """Remove item from cart."""
        self.items = [i for i in self.items if i["product"] != product]
        return self

    def apply_discount(self, percentage):
        """Apply discount to cart total."""
        if 0 <= percentage <= 100:
            self.discount = percentage
        return self

    def total(self):
        """Calculate total with discount."""
        subtotal = sum(i["product"].price * i["qty"] for i in self.items)
        return subtotal * (1 - self.discount / 100)
```

Zadania (po kazdym `u`):
1. Kursor gdziekolwiek w `add_item`. `vif` -- zaznacz cialo funkcji. Obserwuj zakres. `Esc`
2. Kursor gdziekolwiek w `add_item`. `vaf` -- zaznacz CALA funkcje. `Esc`
3. Kursor gdziekolwiek w `remove_item`. `daf` -- usun cala metode. `u`
4. Kursor gdziekolwiek w `ShoppingCart`. `vic` -- zaznacz cialo klasy. `Esc`
5. Kursor gdziekolwiek w `total`. `yaf` -- kopiuj cala metode. `G`, `p` -- wklej na koncu. `u`

## Cwiczenie 6: mini.ai -- argument objects

Edytuj argumenty funkcji precyzyjnie.

```typescript
function createUser(name: string, email: string, role: string = "user", active: boolean = true) {
    return { name, email, role, active };
}

function sendNotification(userId: number, message: string, channel: "email" | "sms" | "push", priority: number = 5) {
    // implementation
}

const result = processData(inputArray, { sort: true, limit: 100 }, callback, "json");
```

Zadania (po kazdym `u`):
1. Kursor na `email: string` (2. argument). `dia` -- usun sam argument
2. Kursor na `role: string = "user"`. `cia` -> `role: Role` -> `Esc`
3. Kursor na `active: boolean = true`. `daa` -- usun argument Z przecinkiem
4. W `sendNotification`: kursor na `priority`. `daa` -- usun ostatni argument
5. W `processData`: kursor na `{ sort: true, limit: 100 }`. `cia` -> `options` -> `Esc`

## Cwiczenie 7: Kombinacje text objects z Visual

Uzyj Visual mode + text objects do zaznaczania i obserwacji zakresu.

```vue
<template>
  <div class="dashboard">
    <header>
      <h1>{{ title }}</h1>
      <nav>
        <a href="/home">Home</a>
        <a href="/settings">Settings</a>
      </nav>
    </header>
    <main>
      <section v-for="item in items" :key="item.id">
        <p>{{ item.description }}</p>
      </section>
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from "vue"

const title = ref("Dashboard")
const items = ref([
  { id: 1, description: "First item" },
  { id: 2, description: "Second item" },
  { id: 3, description: "Third item" },
])

const activeCount = computed(() => items.value.length)
</script>
```

Zadania (po kazdym `Esc`):
1. Kursor na `Home`. `vit` -- zaznacz inner tag `<a>`. Obserwuj zaznaczenie
2. Kursor wewnatrz `<nav>`. `vit` -- zaznacz zawartosc nav (kilka linii!)
3. Kursor wewnatrz `<header>`. `vat` -- zaznacz caly header tag
4. Kursor na `"Dashboard"`. `vi"` -- zaznacz zawartosc stringa
5. Kursor wewnatrz `[...]` (tablicy items). `vi[` -- zaznacz zawartosc tablicy
6. Kursor wewnatrz `{ id: 1, ... }`. `vi{` -- zaznacz zawartosc obiektu

## Cwiczenie bonusowe

Otworz `exercises/typescript/api-service.ts` i wykonaj nastepujace operacje
uzywajac GLOWNIE text objects:

1. Znajdz metode z parametrami -- zmien argumenty uzywajac `ci(` (nie `c` + motion!)
2. Znajdz string z URL -- zmien zawartosc uzywajac `ci"` lub `ciq` (mini.ai)
3. Znajdz obiekt konfiguracyjny `{...}` -- skopiuj zawartosc uzywajac `yi{`
4. Znajdz funkcje/metode -- skopiuj cala uzywajac `yaf` (mini.ai)
5. Cofnij wszystko (`u`)

Wyzwanie: zmierz ile klawiszy potrzebujesz na zadanie 1 z text objects vs z motions.
Text objects powinny wymagac ~3-4 klawiszy (`ci(`), motions wiecej (trzeba dokladnie
pozycjonowac kursor).
