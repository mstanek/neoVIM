# Lekcja 04: Text objects

> Czas: ~40-45 min | Poziom: Intermediate

## Cel lekcji

Opanowanie text objects -- sposobu na definiowanie zakresu operacji niezaleznie od pozycji
kursora. Zamiast martwic sie "gdzie dokladnie stoi kursor", mowisz Vimowi "chce operowac
na calym slowie / calym stringu / calym bloku nawiasow". To przelamowy moment w nauce Vima.

## Teoria

### Czym sa text objects?

Text objects to specjalne motions, ktore definiuja **zakres tekstu** bazujac na strukturze
(slowa, stringi, nawiasy, tagi HTML). Dzialaja TYLKO z operatorami lub w trybie Visual --
nie mozna ich uzyc samodzielnie do poruszania kursora.

Kluczowa roznica vs motions:
- **Motion** (np. `w`): zakres = od kursora do celu
- **Text object** (np. `iw`): zakres = caly obiekt, **niezaleznie od pozycji kursora wewnatrz**

```python
# Kursor gdzies w srodku slowa:
format_currency
     ^              # kursor na 't'

# dw  -- usunie "t_currency" (od kursora do nastepnego slowa)
# diw -- usunie "format_currency" (cale slowo, niezaleznie od pozycji!)
```

### Inner vs Around

Kazdy text object ma dwie wersje:

| Prefix | Nazwa | Opis |
|--------|-------|------|
| `i` | **Inner** | Wnetrze obiektu (bez delimitera/otoczenia) |
| `a` | **Around** | Caly obiekt (z delimiterem/otoczeniem) |

Przyklad z cydzysowem:
```python
name = "John Doe"
          ^          # kursor na 'h'

# di" -- usunie John Doe, zostanie: name = ""
# da" -- usunie "John Doe" (z cudzysowami), zostanie: name =
```

Przyklad z nawiasem:
```python
print(result + 10)
         ^          # kursor na 's'

# di( -- usunie result + 10, zostanie: print()
# da( -- usunie (result + 10), zostanie: print
```

### Natywne text objects Vima

#### Word objects

| Text object | Opis | Przyklad tekstu | Inner | Around |
|-------------|------|-----------------|-------|--------|
| `iw` | Inner word | `hello world` | `hello` | `hello ` (ze spacja) |
| `aw` | A word | `hello world` | - | `hello ` |
| `iW` | Inner WORD | `data["key"]` | `data["key"]` | `data["key"] ` |
| `aW` | A WORD | `data["key"]` | - | `data["key"] ` |

#### Quote objects

| Text object | Opis | Przyklad | Inner | Around |
|-------------|------|----------|-------|--------|
| `i"` | Inner double quotes | `"hello world"` | `hello world` | `"hello world"` |
| `a"` | Around double quotes | `"hello world"` | - | `"hello world"` |
| `i'` | Inner single quotes | `'test'` | `test` | `'test'` |
| `a'` | Around single quotes | `'test'` | - | `'test'` |
| `` i` `` | Inner backticks | `` `code` `` | `code` | `` `code` `` |
| `` a` `` | Around backticks | `` `code` `` | - | `` `code` `` |

#### Bracket/paren objects

| Text object | Alias | Opis |
|-------------|-------|------|
| `i(` / `i)` | `ib` | Wnetrze nawiasow okraglych |
| `a(` / `a)` | `ab` | Z nawiasami okraglymi |
| `i[` / `i]` | - | Wnetrze nawiasow kwadratowych |
| `a[` / `a]` | - | Z nawiasami kwadratowymi |
| `i{` / `i}` | `iB` | Wnetrze nawiasow klamrowych |
| `a{` / `a}` | `aB` | Z nawiasami klamrowymi |
| `i<` / `i>` | - | Wnetrze nawiasow katowych |
| `a<` / `a>` | - | Z nawiasami katowymi |

#### Tag objects (HTML/XML)

| Text object | Opis |
|-------------|------|
| `it` | Inner tag -- zawartosc miedzy tagami |
| `at` | Around tag -- z tagami otwierajacym i zamykajacym |

```html
<div class="card">Hello World</div>
                   ^                    # kursor na 'H'

# dit -- usunie "Hello World", zostanie: <div class="card"></div>
# dat -- usunie caly tag: <div class="card">Hello World</div>
```

#### Inne natywne text objects

| Text object | Opis |
|-------------|------|
| `is` | Inner sentence (zdanie) |
| `as` | Around sentence |
| `ip` | Inner paragraph (paragraf) |
| `ap` | Around paragraph |

### mini.ai -- rozszerzone text objects

> **Twoja konfiguracja**: Masz plugin **mini.ai**, ktory dodaje dodatkowe text objects
> oparte na treesitter (rozumieja strukture kodu).

| Text object | Opis | Przyklad |
|-------------|------|----------|
| `if` / `af` | **Function** -- cialo/cala funkcja | `daf` usunie cala funkcje |
| `ic` / `ac` | **Class** -- cialo/cala klasa | `dic` usunie cialo klasy |
| `ia` / `aa` | **Argument** -- argument funkcji | `dia` usunie argument |
| `iq` / `aq` | **Quote** -- dowolny typ cudzyslowu | `ciq` zmieni zawartosc stringa |

Te text objects sa niezwykle potezne w kodzie:

```python
def calculate_tax(amount: float, rate: float = 0.23) -> float:
                   ^
# dia -- usunie "amount: float" (sam argument)
# daa -- usunie "amount: float, " (argument ze spacja/przecinkiem)
```

```python
def process_data(items):
    for item in items:
        result = transform(item)
        store(result)
    return True
# Z kursorem gdziekolwiek wewnatrz:
# dif -- usunie cialo funkcji (zachowa "def process_data(items):")
# daf -- usunie CALA funkcje (lacznie z definicja)
```

### Najczesciej uzywane kombinacje

| Komenda | Opis | Typowe zastosowanie |
|---------|------|---------------------|
| `diw` | Delete inner word | Usun slowo (kursor gdziekolwiek w slowie) |
| `ciw` | Change inner word | Zmien slowo na inne |
| `ci"` | Change inner quotes | Zmien zawartosc stringa |
| `ci(` | Change inner parens | Zmien argumenty funkcji |
| `da(` | Delete around parens | Usun nawiasy z zawartoscia |
| `dit` | Delete inner tag | Usun zawartosc tagu HTML |
| `yiw` | Yank inner word | Kopiuj slowo |
| `yi{` | Yank inner braces | Kopiuj zawartosc bloku {} |
| `viw` | Visual inner word | Zaznacz slowo |
| `vi"` | Visual inner quotes | Zaznacz zawartosc stringa |
| `vaf` | Visual around function | Zaznacz cala funkcje (mini.ai) |
| `daa` | Delete around argument | Usun argument z separatorem (mini.ai) |

### Wizualizacja: jak myslec o text objects

```
Operator + i/a + Object
   │        │      │
   │        │      └── CO: word, quote, paren, tag, function...
   │        └── JAK: inner (bez delimitera) / around (z delimiterem)
   └── AKCJA: d(elete), c(hange), y(ank), v(isual)
```

Przyklady "zdan":
- `ci"` = **c**hange **i**nner **"** = zmien zawartosc stringa
- `daf` = **d**elete **a**round **f**unction = usun cala funkcje
- `yiB` = **y**ank **i**nner **B**races = kopiuj zawartosc bloku {}

## Cwiczenia

### Cwiczenie 1: Inner word vs Around word

Otworz plik:
```
nvim exercises/practice/text-objects.txt
```

Wpisz nastepujacy tekst:
```
The quick brown fox jumps over the lazy dog
```

1. Ustaw kursor gdziekolwiek w slowie `brown` (np. na `o`)
2. `diw` -- usunie `brown`, zostanie `The quick  fox...` (podwojna spacja)
3. `u` -- cofnij
4. `daw` -- usunie `brown ` (z jedna spacja), zostanie `The quick fox...`
5. `u` -- cofnij
6. `ciw` -- usun `brown` i wejdz w Insert, wpisz `red`, `Esc`
7. `u` -- cofnij

### Cwiczenie 2: Quote objects

Wpisz w pliku cwiczeniowym:
```python
name = "John Doe"
greeting = 'Hello World'
query = "SELECT * FROM users WHERE name = 'admin'"
```

1. Ustaw kursor gdziekolwiek wewnatrz `"John Doe"`
2. `di"` -- usunie `John Doe`, zostanie `name = ""`
3. `u` -- cofnij
4. `ci"` -- usun i wejdz w Insert, wpisz `Jane Smith`, `Esc`
5. `u` -- cofnij
6. Na linii z `greeting`, kursor wewnatrz `'Hello World'`
7. `ci'` -- zmien na `Czesc Swiecie`
8. `u` -- cofnij
9. Na linii z `query`, kursor wewnatrz zewnetrznego `"..."`
10. `yi"` -- kopiuj cale zapytanie SQL (zawartosc zewnetrznych cudzystowow)

### Cwiczenie 3: Bracket objects

Otworz `exercises/python/calculator.py`:
```
nvim exercises/python/calculator.py
```

1. Znajdz `def add(self, a: float, b: float) -> float:` (linia ~85)
2. Ustaw kursor gdziekolwiek wewnatrz nawiasow `(...)`
3. `di(` -- usunie zawartosc nawiasow: `def add() -> float:`
4. `u` -- cofnij
5. `ci(` -- zmien argumenty: wpisz `self, x: int, y: int`, `Esc`
6. `u` -- cofnij
7. Znajdz `dispatch = {` w metodzie `chain` (linia ~219)
8. Ustaw kursor gdziekolwiek wewnatrz `{...}`
9. `di{` -- usunie cala zawartosc slownika
10. `u` -- cofnij
11. `yi{` -- kopiuj zawartosc slownika (mozesz wkleic gdzie indziej)

### Cwiczenie 4: Tag objects (HTML/XML)

Wpisz w pliku cwiczeniowym (lub otworz plik Vue jesli istnieje):
```html
<div class="container">
  <h1>Tytul strony</h1>
  <p class="description">To jest opis <strong>waznego</strong> elementu.</p>
  <ul>
    <li>Punkt pierwszy</li>
    <li>Punkt drugi</li>
    <li>Punkt trzeci</li>
  </ul>
</div>
```

1. Ustaw kursor na `Tytul strony` wewnatrz `<h1>`
2. `dit` -- usunie `Tytul strony`, zostanie `<h1></h1>`
3. `u` -- cofnij
4. `cit` -- zmien na `Nowy tytul`, `Esc`
5. `u` -- cofnij
6. Ustaw kursor na `waznego` wewnatrz `<strong>`
7. `dat` -- usunie `<strong>waznego</strong>`, zostanie `...opis  elementu.`
8. `u` -- cofnij

### Cwiczenie 5: mini.ai -- function objects

Otworz `exercises/python/utils.py`:
```
nvim exercises/python/utils.py
```

1. Ustaw kursor gdziekolwiek wewnatrz funkcji `validate_email` (np. na linii z `pattern`)
2. `vif` -- zaznacz cialo funkcji (Visual mode pokaze zakres)
3. `Esc` -- wyjdz z Visual
4. `vaf` -- zaznacz cala funkcje (z `def` i dekoratorem jesli jest)
5. `Esc`
6. `daf` -- usun cala funkcje
7. `u` -- cofnij
8. Przejdz do funkcji `slugify`
9. `yaf` -- kopiuj cala funkcje
10. `G` -- przejdz na koniec pliku
11. `p` -- wklej kopie funkcji
12. `u` -- cofnij

### Cwiczenie 6: mini.ai -- argument objects

Otworz `exercises/python/utils.py`:

1. Znajdz `def format_currency(amount: float, currency: str = "USD", locale: str = "en"):`
2. Ustaw kursor na `currency` (drugi argument)
3. `dia` -- usunie `currency: str = "USD"` (sam argument)
4. `u` -- cofnij
5. `daa` -- usunie `currency: str = "USD", ` (z przecinkiem)
6. `u` -- cofnij
7. `cia` -- zmien argument: wpisz `curr: str = "EUR"`, `Esc`
8. `u` -- cofnij

### Cwiczenie 7: mini.ai -- quote objects

```python
message = "Hello World"
template = 'Dear {name}, welcome to {city}'
command = `ls -la /home`
```

1. Na linii z `message`, kursor wewnatrz cudzystowu
2. `ciq` -- mini.ai automatycznie wykryje typ cudzystowu i zmieni zawartosc
3. Wpisz `Czesc Swiecie`, `Esc`
4. `u` -- cofnij
5. Porownaj: `ci"` robi to samo, ale `ciq` dziala z dowolnym typem cudzystowu

### Cwiczenie 8: Laczenie text objects z Visual mode

W `exercises/python/calculator.py`:

1. Przejdz do klasy `Calculator` (linia ~64)
2. `vic` -- zaznacz cialo klasy (mini.ai)
3. Obserwuj jak duzy jest zakres zaznaczenia
4. `Esc`
5. Znajdz metode `divide` (linia ~121)
6. `vif` -- zaznacz cialo metody
7. `Esc`
8. `vi{` -- zaznacz zawartosc bloku if (linia z `if b == 0:`)
9. `Esc`

### Cwiczenie 9: Praktyczne scenariusze

Otworz `exercises/python/models.py`:
```
nvim exercises/python/models.py
```

Wykonaj nastepujace zadania (kazde cofnij `u`):

1. W klasie `User`, zmien `email: str` na `email: EmailStr` -- uzyj `ciw` na `str`
2. W `__str__` metody User, zmien zawartosc f-stringa -- uzyj `ci{`
3. W `create_superuser`, zmien argumenty -- uzyj `ci(`
4. Skopiuj cala klase `OrderItem` -- uzyj `yac` (yank around class, mini.ai)
5. Usun cialo metody `cancel` w klasie `Order` -- uzyj `dif`

## Cwiczenie bonusowe

Otworz `exercises/python/calculator.py` i wykonaj nastepujace refaktoryzacje uzywajac
GLOWNIE text objects:

1. W metodzie `chain`: zmien zawartosc slownika `dispatch` (`ci{`) na:
   ```python
   "add": self.add,
   "sub": self.subtract,
   "mul": self.multiply,
   "div": self.divide,
   ```
2. Zmien docstring metody `add` -- uzyj `cit` lub `ci"` (docstring to potrojny cudzyslow)
3. Skopiuj metode `multiply` (`yaf`) i wklej na koncu klasy, zmien nazwe na `double`
   i cialo na `return self.multiply(a, 2)`

**Wyzwanie**: Policz ile keystroke'ow potrzebujesz na kazde zadanie. Text objects powinny
drastycznie zmniejszyc liczbe wymaganych nacisnienc klawiszy w porownaniu z motions!

## Podsumowanie

### Nauczone text objects

| Kategoria | Inner | Around | Opis |
|-----------|-------|--------|------|
| Word | `iw` | `aw` | Slowo |
| WORD | `iW` | `aW` | WORD (oddzielone spacjami) |
| Double quote | `i"` | `a"` | Cudzyslow podwojny |
| Single quote | `i'` | `a'` | Cudzyslow pojedynczy |
| Backtick | `` i` `` | `` a` `` | Backtick |
| Parentheses | `i(` / `ib` | `a(` / `ab` | Nawiasy okragle |
| Brackets | `i[` | `a[` | Nawiasy kwadratowe |
| Braces | `i{` / `iB` | `a{` / `aB` | Nawiasy klamrowe |
| Angle | `i<` | `a<` | Nawiasy katowe |
| Tag | `it` | `at` | Tag HTML/XML |
| Sentence | `is` | `as` | Zdanie |
| Paragraph | `ip` | `ap` | Paragraf |
| **Function** | `if` | `af` | Funkcja (mini.ai) |
| **Class** | `ic` | `ac` | Klasa (mini.ai) |
| **Argument** | `ia` | `aa` | Argument (mini.ai) |
| **Quote** | `iq` | `aq` | Dowolny cudzyslow (mini.ai) |

### Kluczowa formula (rozszerzona)

```
{operator} + i/a + {object}
    d           i      w        = delete inner word
    c           a      "        = change around quotes
    y           i      (        = yank inner parens
    v           a      f        = visual around function
```

### Co dalej?

W **lekcji 05** zglebisz **tryb Visual** -- trzy warianty zaznaczania (character, line, block),
edycja kolumnowa z `Ctrl+v`, i praktyczne zastosowania jak zmiana wciecia czy operacje na
wielu liniach jednoczesnie.
