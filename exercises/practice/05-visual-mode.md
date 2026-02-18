# Cwiczenie 05: Tryb Visual

> Powiazana lekcja: `lessons/05-visual-mode.md`

## Instrukcje
- Character-wise: `v` -- zaznaczanie po znakach
- Line-wise: `V` -- zaznaczanie calych linii
- Block-wise: `Ctrl+v` -- zaznaczanie prostokatnego bloku (kolumny)
- Operacje: `d` (usun), `c` (zmien), `y` (kopiuj), `>/<` (indent/outdent)
- Case: `~` (toggle), `u` (lowercase), `U` (UPPERCASE)
- Block: `I` (insert na poczatku), `A` (append na koncu)
- Narzedzia: `o` (toggle end), `gv` (reselect), przelaczanie `v`/`V`/`Ctrl+v`

## Cwiczenie 1: Character Visual -- precyzyjne zaznaczanie

Uzyj `v` + motions do zaznaczenia dokladnych fragmentow tekstu.

```python
config = {
    "database_host": "postgresql://admin:secret@prod-db.internal:5432/maindb",
    "cache_ttl": 3600,
    "api_key": "sk-1234567890abcdef",
    "debug_mode": False,
    "allowed_origins": ["https://app.example.com", "https://admin.example.com"],
}
```

Zadania:
1. Kursor na `p` w `postgresql`. `ve` -- zaznacz do konca slowa. Rozszerz: `E` -- zaznacz caly URL
2. Kursor na `s` w `secret`. `vf@` -- zaznacz od `s` do `@` (wlacznie). `d` -- usun haslo
3. `u` -- cofnij. Kursor na `"sk-...`. `vi"` -- zaznacz caly API key. `c` -> `"REDACTED"` -> `Esc`
4. `u`. Kursor na `F` w `False`. `viw` -- zaznacz slowo. `c` -> `True` -> `Esc`
5. `u`. Kursor na `[` w `allowed_origins`. `vi[` -- zaznacz zawartosc listy. `y` -- kopiuj

## Cwiczenie 2: Line Visual -- operacje na blokach kodu

Uzyj `V` do zaznaczania i manipulacji calych linii.

```javascript
// Sekcja A: importy (powinny byc na gorze)
const express = require("express");
const cors = require("cors");
const helmet = require("helmet");

// Sekcja B: middleware
app.use(cors());
app.use(helmet());
app.use(express.json());

// Sekcja C: do przesuniecia o 1 poziom wciecia
function setupRoutes(app) {
app.get("/users", getUsers);
app.post("/users", createUser);
app.delete("/users/:id", deleteUser);
app.put("/users/:id", updateUser);
}
```

Zadania:
1. Kursor na `app.get`. `V3j` -- zaznacz 4 linie z routami. `>` -- dodaj wciecie
   (zaznaczenie zostanie dzieki Twojemu keymapowi!). `>` jeszcze raz jesli potrzeba. `Esc`
2. `u` wielokrotnie. Kursor na `// Sekcja B`. `V5j` -- zaznacz sekcje B. `d` -- usun. `u`
3. Kursor na `const cors`. `V` -- zaznacz linie. `j` -- rozszerz o `const helmet`. `y` -- kopiuj.
   Przejdz na koniec pliku. `p` -- wklej. `u`
4. Zaznacz sekcje C: `V` na `function setupRoutes`, potem `}` (lub `5j`). `J` -- polacz w 1 linie. `u`

## Cwiczenie 3: Block Visual -- dodawanie prefixu

Uzyj `Ctrl+v` do edycji kolumnowej.

```
name = "Alice"
email = "alice@example.com"
age = 30
city = "Krakow"
role = "admin"
active = True
joined = "2026-01-15"
score = 95
```

Zadanie 1 -- dodaj `self.` przed kazda zmienna:
1. Kursor na `n` w `name` (pierwsza linia, pierwsza kolumna)
2. `Ctrl+v` -- Block Visual
3. `7j` -- zaznacz 8 linii
4. `I` -- Insert na poczatku bloku
5. Wpisz `self.`
6. `Esc` -- tekst pojawi sie we WSZYSTKICH liniach!
7. `u` -- cofnij

Zadanie 2 -- dodaj ` # field` na koncu kazdej linii:
1. Kursor na pierwszej linii
2. `Ctrl+v` + `7j` -- zaznacz 8 linii
3. `$` -- rozszerz do konca kazdej linii
4. `A` -- Append na koncu bloku
5. Wpisz `  # field`
6. `Esc`
7. `u` -- cofnij

## Cwiczenie 4: Block Visual -- usuwanie kolumny

Usun komentarze liniowe z bloku kodu.

```python
#     name = "Alice"
#     email = "alice@example.com"
#     age = 30
#     city = "Krakow"
#     role = "admin"
```

Zadanie: usun `# ` z poczatku kazdej linii:
1. Kursor na `#` w pierwszej linii
2. `Ctrl+v` -- Block Visual
3. `4j` -- zaznacz 5 linii
4. `l` -- rozszerz zaznaczenie o spacje po `#` (zaznacz `# ` -- 2 znaki)
5. Jesli wciaz za malo, jeszcze raz `l` (5 spacji wciecia)
6. `d` -- usun zaznaczony blok
7. `u` -- cofnij

## Cwiczenie 5: Block Visual -- zamiana tekstu

Zamien prefix w wielu liniach naraz.

```typescript
export const getUserName = () => "Alice";
export const getUserEmail = () => "alice@test.com";
export const getUserAge = () => 30;
export const getUserCity = () => "Krakow";
export const getUserRole = () => "admin";
```

Zadanie: zmien `export const` na `export let`:
1. Kursor na `c` w `const` (pierwsza linia)
2. `Ctrl+v` -- Block Visual
3. `4j` -- zaznacz 5 linii
4. `4l` -- zaznacz `const` (5 znakow)
5. `c` -- change block
6. Wpisz `let  ` (let + 2 spacje dla wyrownania)
7. `Esc` -- zmiana we wszystkich liniach
8. `u` -- cofnij

## Cwiczenie 6: Komenda o -- rozszerzanie zaznaczenia w obie strony

```python
def first():
    pass

def second():
    pass

def third():
    pass

def fourth():
    pass

def fifth():
    pass
```

Zadania:
1. Kursor na `def third`. `V` -- zaznacz linie
2. `j` -- rozszerz w dol (third + pass)
3. `o` -- kursor przeskakuje na poczatek zaznaczenia!
4. `2k` -- rozszerz w gore (teraz zaznaczone: second + pass + pusty wiersz + third + pass)
5. `o` -- wroc na koniec zaznaczenia
6. `3j` -- rozszerz az do `def fourth` + pass
7. `y` -- kopiuj caly zaznaczony blok
8. `u` -- cofnij

## Cwiczenie 7: gv -- ponowne zaznaczenie i wielokrotne wciecie

```html
<div>
<h1>Title</h1>
<p>Paragraph one</p>
<p>Paragraph two</p>
<p>Paragraph three</p>
<ul>
<li>Item A</li>
<li>Item B</li>
<li>Item C</li>
</ul>
</div>
```

Zadanie: popraw wciecia:
1. Kursor na `<h1>`. `V` -- zaznacz linie
2. Przesun do `</ul>` (zaznacz wszystko wewnatrz `<div>`)
3. `>` -- wciecie o 1 poziom (zaznaczenie zostaje!)
4. Teraz zaznacz tylko `<li>` elementy: `Esc`, kursor na `<li>Item A`. `V2j`
5. `>` -- dodatkowe wciecie dla `<li>`
6. `u` wielokrotnie -- cofnij

Wynik powinien wygladac tak:
```html
<div>
  <h1>Title</h1>
  <p>Paragraph one</p>
  <p>Paragraph two</p>
  <p>Paragraph three</p>
  <ul>
    <li>Item A</li>
    <li>Item B</li>
    <li>Item C</li>
  </ul>
</div>
```

## Cwiczenie 8: Visual + case toggle

Zmien wielkosc liter w zaznaczonym tekscie.

```
http_status_ok = 200
http_status_not_found = 404
http_status_internal_error = 500
content_type_json = "application/json"
content_type_html = "text/html"
```

Zadania:
1. Kursor na `h` w `http_status_ok`. `viw` -- zaznacz slowo. `U` -- UPPERCASE: `HTTP_STATUS_OK`
2. `u`. Kursor na `h`. `v$` -- zaznacz cala linie od kursora. `~` -- toggle case
3. `u`. Kursor na `content_type_json`. `V4j` -- zaznacz 2 linie. `U` -- cale uppercase
4. `u` -- cofnij wszystko

## Cwiczenie bonusowe

Otworz `exercises/vue/DataTable.vue` i wykonaj nastepujace zadania uzywajac
roznych wariantow Visual mode:

1. Znajdz `<template>` -- zaznacz caly template uzywajac `Vat` (Visual line + around tag)
2. Wewnatrz `<script>`: zaznacz 3 kolejne zmienne uzywajac `V2j` i zmien wciecie `>`
3. Znajdz blok z props/columns -- uzyj `vi[` do zaznaczenia zawartosci tablicy
4. Uzyj Block Visual (`Ctrl+v`) zeby dodac komentarz `// ` przed 5 kolejnymi liniami kodu
5. Cofnij (`u`)
6. Uzyj Block Visual zeby usunac komentarze ktore wlasnie cofnales (gdybys ich nie cofnal)

Wyzwanie: skomentuj/odkomentuj 10 linii za pomoca Block Visual + `I// ` w mniej
niz 10 sekund. Powtarzaj az bedziesz szybki.
