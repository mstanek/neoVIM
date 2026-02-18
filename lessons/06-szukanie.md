# Lekcja 06: Szukanie (search)

> Czas: ~35-45 min | Poziom: Intermediate

## Cel lekcji

Opanowanie wyszukiwania tekstu w Vimie -- od prostego `/pattern` przez wyszukiwanie slowa
pod kursorem (`*`/`#`), az po podstawy wyrazen regularnych. Poznasz tez search & replace
(`:s` i `:%s`) z podgladem na zywo dzieki Twojej konfiguracji `inccommand=split`.

## Teoria

### Podstawowe wyszukiwanie

| Komenda | Opis |
|---------|------|
| `/{pattern}` + Enter | Szukaj **w przod** od kursora |
| `?{pattern}` + Enter | Szukaj **w tyl** od kursora |
| `n` | Nastepny wynik (w kierunku wyszukiwania) |
| `N` | Poprzedni wynik (odwrotny kierunek) |

Po wpisaniu `/{pattern}` i nacisnieciu Enter, Vim przeskoczy do pierwszego wystapienia.
`n` przenosi do nastepnego, `N` do poprzedniego.

> **Twoja konfiguracja**: `incsearch = true` sprawia, ze Vim zaczyna szukac **juz podczas
> wpisywania** patternu. Podswietla pierwszy wynik na zywo, zanim nacisniesz Enter.

> **Twoja konfiguracja**: `hlsearch = true` podswietla **wszystkie** wyniki wyszukiwania
> w pliku. Podswietlenia zostaja az do czyszczenia.

### Czyszczenie podswietlenia

Po wyszukiwaniu podswietlone wyniki moga przeszkadzac. Masz dwa sposoby na ich usuniecie:

| Komenda | Opis |
|---------|------|
| `<Esc>` | Czysc podswietlenie (Twoj keymap) |
| `<leader><space>` | Czysc podswietlenie (`Space Space`) |

> **Twoja konfiguracja**: Obie komendy sa zmapowane na `:nohlsearch`. Wybierz ta, ktora
> jest wygodniejsza. `Esc` jest szybszy, `Space Space` bardziej intencjonalny.

### Wyszukiwanie slowa pod kursorem

| Komenda | Opis |
|---------|------|
| `*` | Szukaj slowa pod kursorem **w przod** (whole word) |
| `#` | Szukaj slowa pod kursorem **w tyl** (whole word) |
| `g*` | Szukaj slowa pod kursorem w przod (partial match) |
| `g#` | Szukaj slowa pod kursorem w tyl (partial match) |

**Roznica `*` vs `g*`**:
- `*` na slowie `add` znajdzie tylko `add`, nie `add_item` ani `address`
- `g*` na slowie `add` znajdzie `add`, `add_item`, `address`, `added` itd.

```python
def add(self, a: float, b: float) -> float:
     ^   # kursor na "add"
# * -- szuka "\<add\>" (whole word) -- znajdzie tylko "add"
# g* -- szuka "add" -- znajdzie "add", "add_item", itp.
```

### Opcje wyszukiwania

> **Twoja konfiguracja**: Masz ustawione:
> - `ignorecase = true` -- wyszukiwanie domyslnie nie rozroznia wielkosci liter
> - `smartcase = true` -- **ALE** jesli wzorzec zawiera wielka litere, wyszukiwanie
>   staje sie case-sensitive!

| Wzorzec | Zachowanie (z ignorecase + smartcase) |
|---------|---------------------------------------|
| `/hello` | Znajdzie `hello`, `Hello`, `HELLO` |
| `/Hello` | Znajdzie **tylko** `Hello` (wielka litera = case-sensitive) |
| `/HELLO` | Znajdzie **tylko** `HELLO` |
| `/hello\C` | Case-sensitive (force) -- tylko `hello` |
| `/Hello\c` | Case-insensitive (force) -- `Hello`, `hello`, `HELLO` |

Modyfikatory `\c` (case-insensitive) i `\C` (case-sensitive) mozna dodac w dowolnym
miejscu wzorca.

### Search & Replace -- komenda `:s`

Vim uzywa komendy `:s` (substitute) do wyszukiwania i zamiany tekstu:

```
:{zakres}s/{wzorzec}/{zamiana}/{flagi}
```

| Czesc | Opis |
|-------|------|
| `{zakres}` | Gdzie szukac (biezaca linia, caly plik, zakres linii) |
| `{wzorzec}` | Co szukac (tekst lub regex) |
| `{zamiana}` | Na co zamienic |
| `{flagi}` | Jak zamienic (g = globalnie, c = potwierdzenie, i = case-insensitive) |

#### Zakresy

| Zakres | Opis |
|--------|------|
| (brak) | Tylko biezaca linia |
| `%` | Caly plik |
| `1,10` | Linie 1-10 |
| `.,$` | Od biezacej linii do konca pliku |
| `'<,'>` | Zaznaczenie Visual (wypelnia sie automatycznie) |

#### Flagi

| Flaga | Opis |
|-------|------|
| `g` | **Global** -- zamien wszystkie wystapienia w linii (bez tego: tylko pierwsze) |
| `c` | **Confirm** -- pytaj o kazda zamiane (y/n/a/q/l) |
| `i` | Case-insensitive |
| `I` | Case-sensitive |
| `n` | Nie zamieniaj, tylko policz wystapienia |

#### Przyklady

| Komenda | Opis |
|---------|------|
| `:s/foo/bar/` | Zamien pierwsze `foo` na `bar` w biezacej linii |
| `:s/foo/bar/g` | Zamien wszystkie `foo` na `bar` w biezacej linii |
| `:%s/foo/bar/g` | Zamien wszystkie `foo` na `bar` w calym pliku |
| `:%s/foo/bar/gc` | j.w. z potwierdzeniem kazdej zamiany |
| `:%s/foo/bar/gi` | j.w. case-insensitive |
| `:%s/foo//g` | Usun wszystkie `foo` z pliku |
| `:10,20s/foo/bar/g` | Zamien w liniach 10-20 |
| `:%s/foo/bar/gn` | Policz wystapienia `foo` (nie zamieniaj) |

> **Twoja konfiguracja**: `inccommand = split` -- to jedna z najlepszych opcji Neovima!
> Kiedy wpisujesz `:%s/foo/bar/g`, Vim **na zywo** pokazuje:
> 1. Podswietla `foo` w pliku
> 2. Pokazuje jak bedzie wygladal tekst po zamianie
> 3. Otwiera **split window** na dole z podgladem wszystkich zmian
>
> Mozesz modyfikowac wzorzec i zamienik na zywo, obserwujac efekt! Enter zatwierdza,
> Esc anuluje.

### Specjalne znaki w zamianie

| Znak | Opis |
|------|------|
| `&` | Caly matchujacy tekst |
| `\1`, `\2`, ... | Grupy z `\(...\)` |
| `\r` | Nowa linia |
| `\t` | Tab |
| `\u` / `\l` | Nastepny znak uppercase / lowercase |
| `\U` / `\L` | Uppercase / lowercase do `\E` lub konca |

Przyklady:
```
:%s/\(foo\)/[\1]/g          -- otocz foo nawiasami: [foo]
:%s/\<\(\w\)/\u\1/g        -- capitalize first letter of each word
:%s/hello/&_world/g         -- hello -> hello_world
```

### Podstawy regex w Vimie

Vim uzywa wlasnego "dialektu" regex, ktory nieco rozni sie od PCRE (Perl/Python):

| Vim regex | PCRE | Opis |
|-----------|------|------|
| `.` | `.` | Dowolny znak |
| `\d` | `\d` | Cyfra [0-9] |
| `\w` | `\w` | Znak slowa [a-zA-Z0-9_] |
| `\s` | `\s` | Bialy znak (spacja, tab) |
| `*` | `*` | 0 lub wiecej powtorzen |
| `\+` | `+` | 1 lub wiecej powtorzen |
| `\?` | `?` | 0 lub 1 powtorzenie |
| `\(grupa\)` | `(grupa)` | Grupa przechwytujaca |
| `\|` | `\|` | Alternatywa (OR) |
| `\<` / `\>` | `\b` | Granica slowa (word boundary) |
| `\{n,m}` | `{n,m}` | Od n do m powtorzen |

**Tip**: W Vimie specjalne znaki jak `+`, `?`, `(`, `)`, `|` wymagaja backslasha `\`.
To odwrotnie niz w PCRE! Jesli wolisz skladnie zblizana do PCRE, uzyj "very magic" mode:
`/\v` na poczatku wzorca.

| Tryb | Opis | Przyklad |
|------|------|----------|
| `\v` | Very magic -- prawie jak PCRE | `/\v(foo|bar)+` |
| `\V` | Very nomagic -- literal search | `/\Vfoo.bar` szuka dokladnie `foo.bar` |

### Wyszukiwanie jako motion

Wyszukiwanie `/` i `?` mozna laczyc z operatorami jak kazdy inny motion:

| Komenda | Opis |
|---------|------|
| `d/foo` | Usun od kursora do pierwszego wystapienia `foo` |
| `y/foo` | Kopiuj od kursora do pierwszego wystapienia `foo` |
| `c/foo` | Zmien od kursora do pierwszego wystapienia `foo` |

> **Uwaga**: Flash.nvim (plugin do szybkiego skakania za pomoca `s`) to zupelnie
> inna funkcjonalnosc niz natywne wyszukiwanie `/`. Flash dziala jak interaktywny `f/t`
> z labelkami -- zostanie omowiony w osobnej lekcji. Tutaj skupiamy sie na natywnym
> wyszukiwaniu Vima.

### Historia wyszukiwania

| Komenda | Opis |
|---------|------|
| `/` + strzalka gora/dol | Przegladaj historie wyszukiwania |
| `q/` | Otworz okno historii wyszukiwania |
| `q?` | Otworz okno historii wyszukiwania wstecz |

## Cwiczenia

### Cwiczenie 1: Podstawowe wyszukiwanie

Otworz plik:
```
nvim exercises/practice/search-replace.txt
```

Wpisz nastepujacy tekst (lub upewnij sie ze istnieje):
```
Python is a great programming language.
python scripts are easy to write.
PYTHON is used in data science.
Java is another popular language.
JavaScript is not the same as Java.
TypeScript extends JavaScript with types.
python and Python are the same language.
The pythonic way of writing code is important.
```

1. `/Python` + Enter -- znajdzie `Python` (case-sensitive z powodu smartcase -- wielka P!)
2. `n` -- nastepny wynik
3. `N` -- poprzedni wynik
4. `<Esc>` -- czysc podswietlenie
5. `/python` + Enter -- znajdzie `python`, `Python`, `PYTHON` (lowercase = ignorecase)
6. Obserwuj: wszystkie warianty sa podswietlone (hlsearch)
7. `<leader><space>` (`Space Space`) -- czysc podswietlenie

### Cwiczenie 2: Wyszukiwanie slowa pod kursorem

W tym samym pliku:

1. Ustaw kursor na slowie `Java` (linia 4)
2. `*` -- wyszukuje `\<Java\>` (whole word) -- znajdzie `Java` ale NIE `JavaScript`
3. `n` -- nastepny wynik (linia 5: `Java` na koncu)
4. `N` -- wroc
5. `<Esc>` -- czysc
6. Ustaw kursor na `Java` ponownie
7. `g*` -- wyszukuje `Java` (partial) -- znajdzie `Java`, `JavaScript`
8. `n` -- przegladaj wszystkie wyniki
9. `<Esc>` -- czysc

### Cwiczenie 3: Wyszukiwanie wstecz

1. Przejdz na koniec pliku (`G`)
2. `?Python` + Enter -- szuka w tyl od konca pliku
3. `n` -- nastepny wynik (w tyl! bo `?` ustawia kierunek na wsteczny)
4. `N` -- odwrotnie (w przod)
5. `<Esc>` -- czysc

### Cwiczenie 4: Search & Replace -- podstawy

W pliku cwiczeniowym:

1. `:%s/Python/Ruby/g` -- ale **nie naciskaj Enter jeszcze!**
2. Obserwuj: `inccommand=split` pokazuje podglad zmian na zywo!
   - W pliku `Python` jest podswietlone i widac zamiane na `Ruby`
   - Na dole ekranu split window pokazuje wszystkie linie z zamianami
3. Zmodyfikuj wzorzec: zmien na `:%s/Python/Rust/g` -- podglad zmieni sie na zywo
4. Nacisnij `Esc` -- anuluj (zadna zmiana nie zostala wykonana)
5. Teraz wykonaj: `:%s/Python/Ruby/gc` + Enter -- z potwierdzeniem
6. Vim zapyta o kazda zamiane: `y` (tak), `n` (nie), `a` (wszystkie), `q` (koniec)
7. `u` -- cofnij wszystkie zamiany

### Cwiczenie 5: Search & Replace w zakresie

Otworz `exercises/python/utils.py`:
```
nvim exercises/python/utils.py
```

1. `:21,36s/currency/money/g` -- zamien `currency` na `money` tylko w liniach 21-36
   (obserwuj podglad inccommand!)
2. `u` -- cofnij
3. Zaznacz blok Visual: przejdz do `def validate_email`, `V`, zaznacz kilka linii
4. `:` -- automatycznie wstawi `'<,'>` (zakres Visual)
5. Dopisz: `s/email/mail/g` -- pelna komenda: `:'<,'>s/email/mail/g`
6. Enter -- zamien w zaznaczonym zakresie
7. `u` -- cofnij

### Cwiczenie 6: Zliczanie wystapien

W `exercises/python/calculator.py`:
```
nvim exercises/python/calculator.py
```

1. `:%s/self/self/gn` -- policz ile razy wystepuje `self` (flaga `n` = count only)
2. Vim pokaze np. "42 matches on 35 lines"
3. `:%s/float/float/gn` -- policz `float`
4. `:%s/def /def /gn` -- policz definicje funkcji/metod

### Cwiczenie 7: Regex -- podstawowe wzorce

W pliku cwiczeniowym wpisz:
```
price1 = 10.50
price2 = 20.75
price3 = 30.00
total_price = 61.25
item_count = 3
```

1. `/\d\+` + Enter -- znajdz sekwencje cyfr
2. `n` kilka razy -- przegladaj wyniki
3. `<Esc>` -- czysc
4. `/\d\+\.\d\+` + Enter -- znajdz liczby z czescią dziesietna (np. `10.50`)
5. `<Esc>`
6. `/price\d` + Enter -- znajdz `price` + cyfra (price1, price2, price3)
7. `<Esc>`
8. `/\<price\>` + Enter -- znajdz dokladnie slowo `price` (nie `total_price`, nie `price1`)
9. `<Esc>`

### Cwiczenie 8: Search & Replace z regex

W `exercises/python/utils.py`:

1. `:%s/def \(\w\+\)/def my_\1/gc` -- dodaj prefix `my_` do nazw funkcji
   - `\(\w\+\)` -- przechwytuje nazwe funkcji
   - `\1` -- odwolanie do przechwyconej grupy
   - Obserwuj podglad inccommand!
   - Potwierdz kilka zamian lub `Esc` zeby anulowac
2. `u` -- cofnij
3. `:%s/\<str\>/string/gn` -- policz wystapienia `str` jako calego slowa
4. `:%s/"""\_.\{-}"""/"""REDACTED"""/gc` -- zamien docstringi na REDACTED
   - `\_.\{-}` -- dowolny znak wlacznie z newline, non-greedy
   - `Esc` -- anuluj (to bylo tylko demo)

### Cwiczenie 9: Very magic mode

W pliku cwiczeniowym:

1. `/\v(def|class) \w+` + Enter -- very magic: szukaj definicji funkcji lub klas
   (nie trzeba escapowac `(`, `|`, `+`)
2. `n` -- przegladaj wyniki
3. `<Esc>`
4. Porownaj bez very magic: `/\(def\|class\) \w\+` -- te same wyniki, wiecej backslashy

### Cwiczenie 10: Wyszukiwanie jako motion

W `exercises/python/calculator.py`:

1. Ustaw kursor na poczatku pliku (`gg`)
2. `d/class Calculator` + Enter -- usun wszystko od poczatku pliku do `class Calculator`
3. `u` -- cofnij natychmiast!
4. Ustaw kursor na `class Operation`
5. `y/class Calculator` + Enter -- kopiuj od `Operation` do `Calculator`
6. Przejdz na koniec pliku
7. `p` -- wklej skopiowany fragment
8. `u` -- cofnij

## Cwiczenie bonusowe

Otworz `exercises/python/calculator.py` i wykonaj nastepujace refaktoryzacje
uzywajac search & replace:

1. Zmien nazwe klasy `Calculator` na `AdvancedCalculator` we wszystkich miejscach:
   `:%s/Calculator/AdvancedCalculator/g`
   - Obserwuj podglad inccommand
   - Ile miejsc zostalo zmienionych?

2. Zmien wszystkie docstringi z `"""..."""` na komentarze `# ...`:
   - To wymaga regex: `:%s/"""\(.\{-}\)"""/# \1/g` (tylko jednolinijkowe)

3. Dodaj type hint `-> None` do metod ktore nie maja return type:
   - Znajdz metody: `:%s/def \(\w\+\)(.\{-}):\n/& -> None:\r/gc` -- potwierdz selektywnie

4. Policz ile razy wystepuje slowo `return` w pliku: `:%s/return/return/gn`

Pamietaj: `u` cofnie kazda operacje, a `inccommand=split` pozwala zobaczyc efekt
**przed** zatwierdzeniem!

## Podsumowanie

### Nauczone komendy

| Kategoria | Komenda | Opis |
|-----------|---------|------|
| Szukanie | `/{pattern}` | Szukaj w przod |
| Szukanie | `?{pattern}` | Szukaj w tyl |
| Nawigacja | `n` / `N` | Nastepny / poprzedni wynik |
| Slowo | `*` / `#` | Szukaj slowa pod kursorem w przod / tyl |
| Slowo | `g*` / `g#` | Partial match slowa pod kursorem |
| Czyszczenie | `<Esc>` | Czysc podswietlenie |
| Czyszczenie | `<leader><space>` | Czysc podswietlenie |
| Replace | `:%s/foo/bar/g` | Zamien w calym pliku |
| Replace | `:%s/foo/bar/gc` | Zamien z potwierdzeniem |
| Replace | `:%s/foo/bar/gn` | Policz wystapienia |
| Regex | `\v` | Very magic mode |
| Regex | `\V` | Literal search |
| Historia | `q/` | Okno historii wyszukiwania |

### Konfiguracja uzyta w tej lekcji

| Ustawienie | Wartosc | Efekt |
|------------|---------|-------|
| `inccommand` | `split` | Podglad search & replace na zywo z split window |
| `hlsearch` | `true` | Podswietla wszystkie wyniki wyszukiwania |
| `incsearch` | `true` | Szuka juz podczas wpisywania |
| `ignorecase` | `true` | Domyslnie case-insensitive |
| `smartcase` | `true` | Case-sensitive gdy wzorzec zawiera wielka litere |

### Co dalej?

W **lekcji 07** poznasz **rejestry (registers)** -- system schowkow Vima. Dowiesz sie
jak Vim automatycznie przechowuje historię usuniec/kopiowania, jak uzywac nazwanych rejestrow
(`"a`-`"z`) do przechowywania roznych fragmentow tekstu, i jak Twoja konfiguracja
`clipboard=unnamedplus` integruje to z systemowym schowkiem.
