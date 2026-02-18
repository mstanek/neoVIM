# Cwiczenie 03: Operatory (operators)

> Powiazana lekcja: `lessons/03-operatory.md`

## Instrukcje
- Formula: `{operator}{count}{motion}` -- CO + ILE + GDZIE
- Delete: `d` (usun), Change: `c` (usun + Insert), Yank: `y` (kopiuj)
- Put: `p` (wklej po), `P` (wklej przed)
- Podwojony operator = cala linia: `dd`, `cc`, `yy`
- Skroty: `D` = `d$`, `C` = `c$`, `x` = `dl`, `s` = `cl` (ale `s` = Flash.nvim!)
- Dot: `.` -- powtorz ostatnia zmiane

## Cwiczenie 1: Delete z roznymi motions

Ponizej blok kodu z bledami. Kazda linia zawiera fragment do usuniecia.
Po kazdym usunieciu cofnij (`u`) i przejdz do nastepnego zadania.

```python
def USUN_TO create_user(name, email):
    """Create USUN STĄD DO KONCA a new user in the database."""
    USUN_DO_KONCA_LINII user = {"name": name, "email": email}
    validated = USUN_JEDNO_SLOWO validate_input(user)
    return save_to_db(validated) USUN_OD_TUTAJ_DO_KONCA
```

Zadania (po kazdym cofnij `u`):
1. Linia 1: kursor na `U` w `USUN_TO`. `dW` -- usun WORD (lacznie z spacja)
2. Linia 2: kursor na `U` w `USUN`. `dt ` lub `d3W` -- usun do `a`
3. Linia 3: kursor na `U` w `USUN`. `d0` lub `d^` -- usun do poczatku linii
4. Linia 4: kursor na `U` w `USUN_JEDNO_SLOWO`. `dW` -- usun jedno WORD
5. Linia 5: kursor na `U` w `USUN_OD`. `D` lub `d$` -- usun do konca linii

## Cwiczenie 2: Change -- zamiana tekstu w kodzie

Uzyj `c` z odpowiednim motion zeby zamienic tekst. Wpisz podana wartosc, `Esc`.

```typescript
const userName = "ZMIEN_NA_Alice";
const userAge = ZMIEN_NA_30;
const userEmail = "ZMIEN_NA_alice@example.com";
const isActive = ZMIEN_NA_true;
const role = "ZMIEN_NA_admin";
```

Zadania:
1. Linia 1: kursor na `Z`. `ci"` -- zmien wewnatrz cudzyslowow na `Alice`
2. Linia 2: kursor na `Z`. `cW` -- zmien WORD na `30`
3. Linia 3: kursor na `Z`. `ci"` -- zmien na `alice@example.com`
4. Linia 4: kursor na `Z`. `cW` -- zmien na `true`
5. Linia 5: kursor na `Z`. `ci"` -- zmien na `admin`

Powtorz, ale tym razem uzyj `cw` zamiast `cW`. Jaka jest roznica?

## Cwiczenie 3: Yank, put i przenoszenie linii

Cwicz kopiowanie i przenoszenie kodu.

```python
# Ulozy w kolejnosci: imports, stale, funkcja, wywolanie

result = process(DATA_PATH)      # 4. Wywolanie (powinno byc na koncu)
DATA_PATH = "/data/input.csv"    # 2. Stala
import os                         # 1. Import (powinien byc na gorze)
def process(path):                # 3. Definicja funkcji
    return os.path.exists(path)
```

Zadanie: przeniesc linie w poprawna kolejnosc uzywajac `dd` + `p`/`P`:
1. `dd` na linii z `import os` -- wytnij ja
2. Przejdz na linie z komentarzem `# Ulozy...`
3. `p` -- wklej pod komentarzem
4. Teraz przenies `DATA_PATH = ...` pod `import os`
5. Przenies `def process(path):` + jej cialo (uzyj `d}` lub `2dd`)
6. Na koncu przenies `result = ...`

## Cwiczenie 4: Dot repeat -- zmiana wielu linii

Uzyj `.` (dot) zeby powtorzyc zmiane na wielu liniach.

```javascript
var name = "Alice";
var email = "alice@test.com";
var age = 30;
var city = "Krakow";
var active = true;
var role = "user";
var createdAt = Date.now();
```

Zadanie: zmien wszystkie `var` na `const`:
1. Linia 1, kursor na `v` w `var`. `cw` -> wpisz `const` -> `Esc`
2. `j0` -- nastepna linia, poczatek
3. `.` -- powtorz zmiane! `var` zmieni sie na `const`
4. `j0.` -- powtarzaj az do konca

Policz ile klawiszy naciskasz: 1. zmiana = `cw` + `const` + `Esc` = ~8. Kazda nastepna = `j0.` = 3.
Bez dot: 8 * 7 = 56 klawiszy. Z dot: 8 + 6*3 = 26 klawiszy.

## Cwiczenie 5: Delete + find w dlugich liniach

Cwicz `df`, `dt`, `dF`, `dT` na ponizszych liniach.

```
path = "/home/user/documents/projects/vim-tutor/exercises/practice/test.md"
query = "SELECT id, name, email, role FROM users WHERE active = true AND role = 'admin'"
log = "[2026-02-18 14:30:00] [ERROR] [module.auth] Failed to authenticate user: timeout"
```

Zadania (po kazdym cofnij `u`):
1. Linia `path`: kursor na pierwszym `/`. `df/` -- usun do nastepnego `/` (wlacznie). Powtorz `;` + `.`
2. Linia `query`: kursor na `S`. `dt,` -- usun do pierwszego przecinka (bez niego)
3. Linia `query`: kursor na `S`. `d2f,` -- usun do 2. przecinka (wlacznie)
4. Linia `log`: kursor na `[`. `df]` -- usun do zamkniecia `]` (wlacznie)

## Cwiczenie 6: Operatory z paragrafami

Uzyj `d}`, `y}`, `c}` na blokach kodu oddzielonych pustymi liniami.

```python
def deprecated_function():
    """This function is no longer used."""
    pass

def active_function():
    """This function is in use."""
    result = compute()
    return result

def another_deprecated():
    """Remove this too."""
    return None

def keep_this():
    """Important function."""
    return 42
```

Zadania:
1. Kursor na `def deprecated_function`. `d}` -- usun do pustego wiersza. `u` -- cofnij
2. Kursor na `def active_function`. `y}` -- kopiuj funkcje. Przejdz na koniec. `p` -- wklej. `u`
3. Kursor na `def another_deprecated`. `c}` -- usun i wejdz w Insert. Wpisz nowa funkcje. `Esc`. `u`

## Cwiczenie 7: Praktyczny refactoring z operatorami

Przeksztalc ponizszy kod uzywajac operatorow. Cel jest podany w komentarzu.

```vue
<template>
  <!-- CEL: zmien div na section, p na span -->
  <div class="wrapper">
    <p class="title">Hello World</p>
    <p class="subtitle">Welcome</p>
  </div>
</template>

<script setup lang="ts">
// CEL: zmien nazwy zmiennych
const oldName = ref("Alice")
const oldAge = ref(30)
const oldEmail = ref("alice@test.com")

// CEL: usun ta funkcje
function deprecatedHelper() {
  console.log("remove me")
  return null
}

// CEL: zachowaj ta funkcje
function activeHelper() {
  return "keep me"
}
</script>
```

Zadania:
1. Zmien `oldName` na `userName`: kursor na `old`, `cw` -> `user`, `Esc`. Uzyj `N` zamiast wielkich liter
2. Powtorz dla `oldAge` -> `userAge` i `oldEmail` -> `userEmail` (cwicz `.` jesli wzorzec pasuje)
3. Usun funkcje `deprecatedHelper`: kursor na `function deprecated`, `d}` (lub `daf` z mini.ai)
4. Cofnij wszystko `u` wielokrotnie

## Cwiczenie bonusowe

Otworz `exercises/python/data_processing.py` i wykonaj refactoring:

1. Znajdz funkcje ktore maja `TODO` lub `FIXME` w komentarzach
2. Dla kazdej: skopiuj sygnature (`yy` na linii z `def`) i wklej na koncu pliku (`G`, `p`)
3. Uzywajac `cc` zamien kazda skopiowana linie na komentarz: `# TODO: fix <nazwa_funkcji>`
4. Uzyj `.` gdzie to mozliwe do powtorzenia zmian
5. Cofnij wszystko (`u`)

Wyzwanie: zrefaktoryzuj jednolinijkowe `if` w kodzie na wieloliniowe:
- Kursor na `if`. `f:` zeby znalezc dwukropek. `a` + Enter zeby przejsc do nowej linii
- Powtorz wzorzec uzywajac `.` wszedzie gdzie to mozliwe
