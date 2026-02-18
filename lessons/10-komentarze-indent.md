# Lekcja 10: Komentarze i wciecia

> Czas: ~30-40 min | Poziom: Intermediate

## Cel lekcji

Opanowanie Comment.nvim do blyskawicznego komentowania/odkomentowania kodu oraz operatorow
indentacji (`>>`, `<<`, `=`). Nauczysz sie wykorzystywac Twoja konfiguracje, ktora automatycznie
zachowuje zaznaczenie po wcieniu w trybie Visual.

## Teoria

### Comment.nvim -- komentowanie kodu

Comment.nvim to plugin, ktory automatycznie rozpoznaje jezyk pliku i uzywa prawidlowej
skladni komentarzy. W Pythonie doda `#`, w TypeScript `//`, w HTML `<!-- -->`, w Vue
rozrozni sekcje `<template>`, `<script>` i `<style>`.

### Podstawowe komendy Comment.nvim

| Komenda | Tryb | Opis |
|---------|------|------|
| `gcc` | Normal | Toggle komentarz na biezacej linii |
| `gc{motion}` | Normal | Toggle komentarz na zakresie motion |
| `gc` | Visual | Toggle komentarz na zaznaczeniu |
| `gco` | Normal | Dodaj komentarz w nowej linii ponizej |
| `gcO` | Normal | Dodaj komentarz w nowej linii powyzej |
| `gcA` | Normal | Dodaj komentarz na koncu linii |

### `gcc` -- toggle komentarza linii

Najczesciej uzywana komenda. Jedno nacisniecie `gcc` komentuje linie, drugie `gcc`
odkomentowuje:

```python
# Przed:
result = calculate(x, y)

# Po gcc:
# result = calculate(x, y)

# Po ponownym gcc:
result = calculate(x, y)
```

`gcc` uzywa **line comment** danego jezyka:

| Jezyk | Komentarz |
|-------|-----------|
| Python | `# ...` |
| TypeScript/JavaScript | `// ...` |
| CSS | `/* ... */` |
| HTML | `<!-- ... -->` |
| Lua | `-- ...` |
| SQL | `-- ...` |

### `gc{motion}` -- komentowanie z motion

`gc` jest operatorem -- laczy sie z dowolnym motion lub text object:

| Komenda | Opis |
|---------|------|
| `gcap` | Toggle komentarz na calym paragrafie (around paragraph) |
| `gcip` | Toggle komentarz na wnetrzu paragrafu (inner paragraph) |
| `gc3j` | Toggle komentarz na 3 liniach w dol (biezaca + 3) |
| `gc2k` | Toggle komentarz na 2 liniach w gore |
| `gcG` | Toggle komentarz od kursora do konca pliku |
| `gcgg` | Toggle komentarz od kursora do poczatku pliku |
| `gci}` | Toggle komentarz wewnatrz bloku `{}` |
| `gci)` | Toggle komentarz wewnatrz nawiasow `()` |

**Przyklad `gcap`** (comment around paragraph):

```python
# Przed (kursor gdziekolwiek w bloku):
def process_data(items):
    validated = validate(items)
    transformed = transform(validated)
    return save(transformed)

# Po gcap:
# def process_data(items):
#     validated = validate(items)
#     transformed = transform(validated)
#     return save(transformed)
```

### `gc` w trybie Visual

Zaznacz tekst w trybie Visual, nastepnie nacisnij `gc`:

```
1. V      -- wejdz w Visual Line
2. 3j     -- zaznacz 4 linie
3. gc     -- toggle komentarz na zaznaczeniu
```

Lub:
```
1. vip    -- zaznacz inner paragraph (Visual + text object)
2. gc     -- toggle komentarz
```

### Dodatkowe komendy: `gco`, `gcO`, `gcA`

| Komenda | Opis | Przyklad |
|---------|------|----------|
| `gco` | Nowa linia z komentarzem ponizej | `# ` pojawi sie ponizej i wejdziesz w Insert |
| `gcO` | Nowa linia z komentarzem powyzej | `# ` pojawi sie powyzej |
| `gcA` | Komentarz na koncu biezacej linii | `x = 1  # ` -- dopisuje komentarz |

---

### Wciecia (indentation)

### Operator `>>` i `<<`

| Komenda | Opis |
|---------|------|
| `>>` | Wciecie linii w prawo (o 1 poziom) |
| `<<` | Wciecie linii w lewo (o 1 poziom) |
| `3>>` | Wciecie 3 linii w prawo |
| `5<<` | Wciecie 5 linii w lewo |

Jeden "poziom" to wartosc `shiftwidth` (domyslnie 4 spacje lub 1 tab, zaleznie od konfiguracji).

### Wciecia w trybie Visual

Zaznacz tekst w trybie Visual, nastepnie:

| Klawisz | Opis |
|---------|------|
| `>` | Wciecie zaznaczenia w prawo |
| `<` | Wciecie zaznaczenia w lewo |

> **Twoja konfiguracja**: Masz ustawione `vim.keymap.set("v", ">", ">gv")` oraz
> `vim.keymap.set("v", "<", "<gv")`. To oznacza, ze **po wcieniu zaznaczenie NIE znika** --
> mozesz naciskac `>` lub `<` wielokrotnie, bez potrzeby ponownego zaznaczania! To ogromna
> oszczednosc czasu przy wielokrotnym indentowaniu.

**Bez Twojej konfiguracji** (standardowe zachowanie):
```
1. Vjj    -- zaznacz 3 linie
2. >      -- wciecie w prawo -- zaznaczenie znika!
3. gv     -- ponowne zaznaczenie
4. >      -- kolejne wciecie
```

**Z Twoja konfiguracja**:
```
1. Vjj    -- zaznacz 3 linie
2. >      -- wciecie w prawo -- zaznaczenie zostaje!
3. >      -- kolejne wciecie -- nadal zaznaczone!
4. >      -- i jeszcze raz -- caly czas widoczne!
```

### Operator `=` -- automatyczne formatowanie wciec

Operator `=` automatycznie naprawia wciecia na podstawie struktury kodu:

| Komenda | Opis |
|---------|------|
| `==` | Auto-indent biezacej linii |
| `=ap` | Auto-indent paragrafu |
| `=i}` | Auto-indent wnetrza bloku `{}` |
| `gg=G` | Auto-indent **calego pliku** (idz na poczatek, indentuj do konca) |
| `=G` | Auto-indent od kursora do konca pliku |

**Przyklad `gg=G`** (auto-indent calego pliku):

```python
# Przed (zle wciecia):
def hello():
result = calculate()
    if result > 0:
  return result
        else:
    return 0

# Po gg=G:
def hello():
    result = calculate()
    if result > 0:
        return result
    else:
        return 0
```

> **Uwaga**: Operator `=` dziala w oparciu o indentexpr jezyka. Dla Pythona, TypeScript
> i Vue dziala dobrze. Dla bardziej zlozonych przypadkow mozesz potrzebowac formattera
> (np. Prettier, Black).

### `>` i `<` jako operatory w Normal mode

W trybie Normal `>` i `<` to operatory -- lacza sie z motions:

| Komenda | Opis |
|---------|------|
| `>ap` | Indent paragrafu |
| `>i}` | Indent wnetrza bloku `{}` |
| `<ip` | Outdent inner paragraph |
| `>G` | Indent od kursora do konca pliku |

### Laczenie komentarzy z wcieniami

Typowy workflow: masz blok kodu do tymczasowego wylaczenia, ale chcesz zachowac
wciecia na pozniej:

```
1. vip       -- zaznacz blok kodu
2. gc        -- zakomentuj
3. (pracuj nad czyms innym)
4. vip       -- zaznacz zakomentowany blok
5. gc        -- odkomentuj -- wciecia sa zachowane!
```

## Cwiczenia

### Cwiczenie 1: Komentowanie linii (exercises/python/calculator.py)

Otwierz `exercises/python/calculator.py`:

1. Przejdz do metody `add` (~linia 85) -- `gcc` -- zakomentuj linie `return self._record(...)`
2. `gcc` ponownie -- odkomentuj
3. Przejdz do metody `memory_store` (~linia 166) -- `gcip` -- zakomentuj cale cialo metody
4. `gcip` -- odkomentuj

### Cwiczenie 2: Komentowanie paragrafu (exercises/python/calculator.py)

1. Przejdz do klasy `HistoryEntry` (~linia 27) -- `gcap` -- zakomentuj cala klase
2. Cofnij: `u`
3. Przejdz do metody `chain` (~linia 208) -- `gci{` ... hmm, Python nie ma `{}`. Uzyj `gcip`
4. Cofnij: `u`

### Cwiczenie 3: Visual mode komentarze (exercises/python/calculator.py)

1. Przejdz do importow na gorze (~linie 8-11)
2. `V3j` -- zaznacz 4 linie importow
3. `gc` -- zakomentuj
4. `u` -- cofnij

### Cwiczenie 4: Komentowanie z count (exercises/python/calculator.py)

1. Przejdz na linie z `class CalculatorError` (~linia 40)
2. `gc4j` -- zakomentuj 5 linii (biezaca + 4 w dol): cala klase CalculatorError i DivisionByZeroError
3. `u` -- cofnij

### Cwiczenie 5: Dodawanie komentarzy (exercises/python/calculator.py)

1. Przejdz do metody `divide` (~linia 121)
2. `gcA` -- dodaj komentarz na koncu linii, wpisz: `may raise DivisionByZeroError`
3. `Esc` -- wroc do Normal

### Cwiczenie 6: Indentowanie w Visual mode (exercises/vue/DataTable.vue)

Otwierz `exercises/vue/DataTable.vue`:

1. Przejdz do bloku `<thead>` (~linia 21)
2. `Vjjjjjjjjj` -- zaznacz header section (ok. 10 linii)
3. `>` -- wciecie w prawo -- **zaznaczenie zostaje** (Twoja konfiguracja!)
4. `>` -- jeszcze raz
5. `<` -- cofnij jedno wciecie
6. `<` -- cofnij drugie -- wrociles do oryginalu
7. `Esc` -- wyjdz z Visual

### Cwiczenie 7: Auto-indent calego pliku (exercises/python/calculator.py)

1. `gg=G` -- auto-indent calego pliku od poczatku do konca
2. Sprawdz wynik -- wciecia powinny byc poprawne
3. `u` -- cofnij jesli cos sie zmienialo

### Cwiczenie 8: Indent z operatorem (exercises/vue/DataTable.vue)

1. Znajdz blok `<tbody>` (~linia 39)
2. `>i>` ... hmm, to nie zadziala -- `>` potrzebuje text object
3. Uzyj: `vit` (visual inner tag) aby zaznaczyc zawartosc `<tbody>`, nastepnie `>`
4. `u` -- cofnij

### Cwiczenie 9: Komentarze w Vue (exercises/vue/DataTable.vue)

1. Przejdz do sekcji `<script setup>` (~linia 77)
2. Znajdz `const searchQuery = ref("")` (~linia 103)
3. `gc4j` -- zakomentuj 5 linii zmiennych ref
4. `u` -- cofnij
5. Przejdz do sekcji `<style>` i uzyj `gcc` na wybranej regule CSS

### Cwiczenie 10: Kombinacja komentarzy i wciec (exercises/python/calculator.py)

Symulacja tymczasowego debug:
1. Przejdz do metody `divide` (~linia 121)
2. Linia z `if b == 0:` (~linia 134) -- `gco` -- dodaj komentarz: `debug: checking divisor`
3. `Esc`
4. Przejdz do linii `return self._record(...)` -- `O` -- nowa linia powyzej
5. Wpisz: `print(f"divide: {a} / {b}")` -- `Esc`
6. Zaznacz nowo dodane linie i `gcc` aby je zakomentowac

## Cwiczenie bonusowe

**Refaktor komentarzy**: Otwierz `exercises/python/calculator.py` i:

1. Zakomentuj **wszystkie** metody `memory_*` (store, recall, clear) -- uzyj `gc` z odpowiednimi motions
2. Odkomentuj je
3. Dodaj komentarz `# TODO: add input validation` nad kazda metoda arytmetyczna (add, subtract, multiply, divide) -- uzyj `gcO`

**Indent challenge**: Otwierz `exercises/vue/DataTable.vue` i:
1. Zaznacz cala sekcje `<template>` (`vit` z kursorem na root `<div>`)
2. Wciecie w prawo 2 razy (`>>`)
3. Cofnij 2 razy (`<<`)
4. Uzyj `gg=G` do automatycznego formatowania calego pliku

## Podsumowanie

### Tabela komend -- Comment.nvim

| Komenda | Tryb | Opis |
|---------|------|------|
| `gcc` | Normal | Toggle komentarz linii |
| `gc{motion}` | Normal | Toggle komentarz na motion |
| `gcap` | Normal | Toggle komentarz paragrafu |
| `gc3j` | Normal | Toggle komentarz 3 linii w dol |
| `gc` | Visual | Toggle komentarz zaznaczenia |
| `gco` | Normal | Nowy komentarz ponizej |
| `gcO` | Normal | Nowy komentarz powyzej |
| `gcA` | Normal | Komentarz na koncu linii |

### Tabela komend -- Indentation

| Komenda | Tryb | Opis |
|---------|------|------|
| `>>` | Normal | Indent linii |
| `<<` | Normal | Outdent linii |
| `3>>` | Normal | Indent 3 linii |
| `>` / `<` | Visual | Indent/outdent zaznaczenia (zachowuje selekcje!) |
| `==` | Normal | Auto-indent linii |
| `=ap` | Normal | Auto-indent paragrafu |
| `gg=G` | Normal | Auto-indent calego pliku |
| `>ap` | Normal | Indent paragrafu |
| `>i}` | Normal | Indent wnetrza bloku `{}` |

### Co dalej?

W nastepnej lekcji (11) poznasz Flash.nvim -- plugin do blyskawicznej nawigacji po widocznym
tekscie. Zamiast wielokrotnego `w`, `f`, `}` -- wpisujesz 2 litery i przeskakujesz
natychmiast do dowolnego miejsca na ekranie.
