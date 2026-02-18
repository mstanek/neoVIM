# Lekcja 07: Rejestry (registers)

> Czas: ~30-40 min | Poziom: Intermediate

## Cel lekcji

Zrozumienie systemu rejestrow Vima -- wewnetrznych "schowkow", ktore przechowuja skopiowany,
usuniety i wstawiany tekst. Nauczysz sie swiadomie korzystac z rejestrow zamiast polegac
tylko na domyslnym schowku. To eliminuje jeden z najczestszych frustracji poczatkujacych:
"skopiowem tekst, potem usunelem cos, i moja kopia zniknela!"

## Teoria

### Czym sa rejestry?

Rejestry to **nazwane lokacje w pamieci**, w ktorych Vim przechowuje tekst. Kazde `y` (yank),
`d` (delete), `c` (change) i `s` (substitute) zapisuje tekst w rejestrze. Kazde `p` (put)
wkleja tekst z rejestru.

Kluczowa roznica vs "schowek" w innych edytorach: Vim ma **dziesiątki rejestrow**, nie
jeden schowek. Mozesz jednoczesnie przechowywac wiele roznych fragmentow tekstu.

### Jak uzywac rejestrow

Przed operacja yank/delete/put dodaj `"` + nazwe rejestru:

```
"{rejestr}{operacja}
```

Przyklady:
- `"ayy` -- yank linie do rejestru `a`
- `"bp` -- paste z rejestru `b`
- `"cdiw` -- delete inner word do rejestru `c`

Bez prefixu `"x` operacja uzywa **rejestru unnamed** (`""`), ktory jest domyslny.

### Kategorie rejestrow

#### 1. Unnamed register (`""`)

Domyslny rejestr -- kazdy `y`, `d`, `c`, `x`, `s` zapisuje tutaj. Kazdy `p` wkleja stad.

> **Twoja konfiguracja**: `clipboard = unnamedplus` sprawia, ze unnamed register (`""`)
> jest **zsynchronizowany** ze schowkiem systemowym (`"+`). To oznacza:
> - `yy` kopiuje do schowka systemowego (mozesz Cmd+V w innej aplikacji)
> - Cmd+C w przegladarce pozwala `p` w Vimie
> - `dd` tez trafia do schowka systemowego (uwaga -- usuwanie nadpisuje schowek!)

#### 2. Numbered registers (`"0` - `"9`)

| Rejestr | Zawartosc |
|---------|-----------|
| `"0` | Ostatni **yank** (kopiowanie) |
| `"1` | Ostatni **delete/change** (>= 1 linia lub z motions specjalnymi) |
| `"2` | Przedostatni delete (to co bylo w `"1` przesuwa sie do `"2`) |
| `"3`-`"9` | Kolejne starsze delete'y (FIFO -- najstarszy w `"9`) |

**Kluczowe**: `"0` zawsze przechowuje **ostatni yank**. To rozwiazuje klasyczny problem:

```
Problem:
1. yy       -- kopiujesz linie (trafia do "" i "0)
2. dd       -- usuwasz inna linie (nadpisuje ""!)
3. p        -- wklejasz usuniety tekst, nie skopiowany!

Rozwiazanie:
1. yy       -- kopiujesz linie
2. dd       -- usuwasz inna linie
3. "0p      -- wklejasz z "0 (ostatni YANK, nie delete!)
```

#### 3. Named registers (`"a` - `"z`)

26 rejestrow, ktorymi zarzadzasz recznie. Uzywaj ich do przechowywania tekstu na dluzej.

| Rejestr | Opis |
|---------|------|
| `"a` - `"z` | Zapisz tekst do rejestru (nadpisz) |
| `"A` - `"Z` | **Dopisz** tekst do rejestru (append!) |

**Append jest potezny**: Mozesz zbierac fragmenty tekstu z roznych miejsc:

```
"ayy      -- kopiuj pierwsza linie do rejestru a
(przejdz gdzies)
"Ayy      -- DOPISZ kolejna linie do rejestru a (wielka A!)
(przejdz gdzies)
"Ayy      -- DOPISZ jeszcze jedna linie
"ap       -- wklej wszystkie 3 linie naraz!
```

#### 4. Special registers

| Rejestr | Opis | Read-only? |
|---------|------|------------|
| `"+` | Schowek systemowy (clipboard) | Read/Write |
| `"*` | Selection clipboard | Read/Write |
| `"_` | **Black hole** -- usun bez zapisywania | Write-only |
| `"%` | Nazwa biezacego pliku | Read-only |
| `"#` | Nazwa alternatywnego pliku (poprzedni bufor) | Read-only |
| `".` | Ostatnio wstawiony tekst (Insert mode) | Read-only |
| `":` | Ostatnio wykonana komenda Ex | Read-only |
| `"/` | Ostatni wzorzec wyszukiwania | Read-only |
| `"=` | Expression register (kalkulator) | Special |

> **Twoja konfiguracja (macOS)**: Na macOS rejestry `"+` i `"*` sa **identyczne** -- oba
> odwoluja sie do systemowego schowka (pasteboard). Na Linuxie to dwa rozne schowki
> (X11 clipboard vs X11 primary selection).

#### 5. Small delete register (`"-`)

Przechowuje ostatni delete/change **krotszy niz 1 linia** (np. `dw`, `x`, `dl`).

### Black hole register (`"_`) -- prawdziwe usuwanie

Z `clipboard = unnamedplus` kazde `d` nadpisuje schowek systemowy. Jesli chcesz
**usunac tekst bez wplywu na schowek**, uzyj black hole register:

| Komenda | Opis |
|---------|------|
| `"_dd` | Usun linie bez zapisywania gdziekolwiek |
| `"_dw` | Usun slowo bez zapisywania |
| `"_diw` | Usun inner word bez zapisywania |
| `"_x` | Usun znak bez zapisywania |

**Typowy use case**:
```
1. yy        -- kopiujesz linie (trafia do schowka)
2. "_dd      -- usuwasz inna linie (schowek NIE zmieniony!)
3. p         -- wklejasz oryginalna skopiowana linie
```

### Przegladanie rejestrow

| Komenda | Opis |
|---------|------|
| `:reg` | Pokaz zawartosci WSZYSTKICH rejestrow |
| `:reg a` | Pokaz zawartosc rejestru `a` |
| `:reg ab0` | Pokaz rejestry `a`, `b`, `0` |

Wynik `:reg` wyglada mniej wiecej tak:
```
Type Name Content
  l  ""   def calculate(...):^J
  l  "0   result = a + b^J
  l  "1   old_line = "deleted"^J
  c  "a   variable_name
  c  "-   x
```

Gdzie:
- `l` = line-wise (cala linia)
- `c` = character-wise
- `^J` = newline

### Rejestry w Insert mode i Command-line

Mozesz wkleic zawartosc rejestru bez wychodzenia z Insert mode lub Command-line:

| Komenda | Opis |
|---------|------|
| `Ctrl+r {rejestr}` | Wklej zawartosc rejestru (w Insert/Command-line mode) |
| `Ctrl+r "` | Wklej z unnamed register |
| `Ctrl+r 0` | Wklej z yank register |
| `Ctrl+r +` | Wklej z schowka systemowego |
| `Ctrl+r %` | Wklej nazwe biezacego pliku |
| `Ctrl+r =` | Wklej wynik wyrazenia (np. `2+2` -> `4`) |

**Tip**: `Ctrl+r =` to wbudowany kalkulator:
1. W Insert mode nacisnij `Ctrl+r =`
2. Wpisz `2 * 3.14 * 5` + Enter
3. Vim wstawi `31.4` w tekst!

### Expression register (`"=`)

`Ctrl+r =` w Insert mode otwiera mini-command-line, w ktorej mozesz wpisac
dowolne wyrazenie Vimscript:

| Wyrazenie | Wynik |
|-----------|-------|
| `2+2` | `4` |
| `strftime('%Y-%m-%d')` | `2026-02-18` (biezaca data) |
| `line('.')` | Numer biezacej linii |
| `expand('%')` | Nazwa biezacego pliku |

### Diagram przeplywu rejestrow

```
yy, yw, y{motion}
    │
    ├──► "" (unnamed) ──► schowek systemowy (clipboard=unnamedplus)
    └──► "0 (yank register)

dd, dw, d{motion}, cc, cw
    │
    ├──► "" (unnamed) ──► schowek systemowy
    ├──► "1 (latest delete)
    │       "1 -> "2 -> "3 ... -> "9 (shift)
    └──► "- (jesli < 1 linia)

"add, "ayy
    │
    └──► "a (named register)

"_dd
    │
    └──► /dev/null (nic nie zapisane)
```

## Cwiczenia

### Cwiczenie 1: Problem z unnamed register

Otworz plik:
```
nvim exercises/practice/registers.txt
```

Wpisz:
```
Linia do skopiowania: IMPORTANT DATA
Linia do usuniecia: temporary garbage
Miejsce docelowe: [WKLEJ TUTAJ]
```

1. Przejdz do pierwszej linii
2. `yy` -- kopiuj linie
3. Przejdz do drugiej linii
4. `dd` -- usun linie (nadpisuje unnamed register!)
5. Przejdz do trzeciej linii, `$` na koniec
6. `p` -- **wklei usuniety tekst!** (nie skopiowany)
7. `u` -- cofnij
8. `"0p` -- wklej z rejestru `"0` (ostatni yank) -- teraz wklei `IMPORTANT DATA`
9. `u` -- cofnij wszystko

### Cwiczenie 2: Black hole register

Powtorz cwiczenie 1, ale tym razem uzyj black hole:

1. Przejdz do pierwszej linii
2. `yy` -- kopiuj
3. Przejdz do drugiej linii
4. `"_dd` -- usun do black hole (schowek nie zmieniony!)
5. Przejdz do trzeciej linii
6. `p` -- wkleja skopiowany tekst (z yy)! Sukces!
7. `u` -- cofnij

### Cwiczenie 3: Named registers

Wpisz w pliku:
```
Imie: Jan
Nazwisko: Kowalski
Email: jan@kowalski.pl
Telefon: +48 123 456 789
```

1. Przejdz do linii z imieniem
2. `"ayy` -- kopiuj linie do rejestru `a`
3. Przejdz do linii z emailem
4. `"byy` -- kopiuj do rejestru `b`
5. Przejdz na koniec pliku (`G`)
6. `"ap` -- wklej imie (z rejestru `a`)
7. `"bp` -- wklej email (z rejestru `b`)
8. `:reg ab` -- sprawdz zawartosci rejestrow
9. `u` kilka razy -- cofnij

### Cwiczenie 4: Append do rejestru

W pliku `exercises/python/calculator.py`:
```
nvim exercises/python/calculator.py
```

Zbierz sygnatury wszystkich publicznych metod klasy Calculator:

1. Znajdz `def add(...)` (linia ~85)
2. `"ayy` -- kopiuj sygnatury `add` do rejestru `a`
3. Znajdz `def subtract(...)` (linia ~97)
4. `"Ayy` -- **dopisz** (wielkie A!) sygnature `subtract`
5. Znajdz `def multiply(...)` (linia ~109)
6. `"Ayy` -- dopisz sygnature `multiply`
7. Znajdz `def divide(...)` (linia ~121)
8. `"Ayy` -- dopisz sygnature `divide`
9. `:reg a` -- sprawdz: rejestr `a` powinien zawierac 4 linie!
10. Przejdz na koniec pliku, `"ap` -- wklej wszystkie 4 sygnatury naraz
11. `u` -- cofnij

### Cwiczenie 5: Rejestry numerowane

Wpisz w pliku cwiczeniowym:
```
Linia pierwsza
Linia druga
Linia trzecia
Linia czwarta
Linia piata
```

1. `dd` -- usun pierwsza linie (trafia do `"1`)
2. `dd` -- usun druga linie (`"1` staje sie ta linia, poprzednia idzie do `"2`)
3. `dd` -- usun trzecia linie
4. `:reg 1 2 3` -- sprawdz: `"1` = trzecia, `"2` = druga, `"3` = pierwsza
5. `"3p` -- wklej pierwsza linie (z rejestru `"3`)
6. `"2p` -- wklej druga
7. `"1p` -- wklej trzecia
8. `u` kilka razy -- cofnij

### Cwiczenie 6: Special registers

1. `:reg %` -- pokaz nazwe biezacego pliku
2. W trybie Insert (`i`):
   - `Ctrl+r %` -- wstawi nazwe pliku w tekst
   - `Esc`
3. `u` -- cofnij
4. W trybie Insert:
   - `Ctrl+r =` -- otworzy prompt wyrazenia
   - Wpisz `strftime('%Y-%m-%d %H:%M')` + Enter
   - Vim wstawi biezaca date i czas!
5. `u` -- cofnij
6. W trybie Insert:
   - `Ctrl+r =` -> `2 * 3.14159 * 10` + Enter -> wstawi `62.8318`
7. `u` -- cofnij

### Cwiczenie 7: Ctrl+r w Command-line

1. `yiw` -- kopiuj slowo pod kursorem
2. `:` -- wejdz w Command-line
3. `%s/` -- zacznij substitute
4. `Ctrl+r "` -- wklej skopiowane slowo jako wzorzec!
5. `/replacement/g`
6. Obserwuj podglad inccommand
7. `Esc` -- anuluj

Ten workflow jest przydatny: kopiujesz slowo ktore chcesz zamienic, potem uzywasz
go w substitute bez recznego wpisywania.

### Cwiczenie 8: Rejestry z Visual mode

W `exercises/python/utils.py`:
```
nvim exercises/python/utils.py
```

1. Znajdz `def format_currency(...)` (linia ~21)
2. `V` -- Visual line
3. `5j` -- zaznacz 6 linii
4. `"ay` -- kopiuj zaznaczenie do rejestru `a`
5. Znajdz `def validate_email(...)` (linia ~39)
6. `V5j` -- zaznacz 6 linii
7. `"by` -- kopiuj do rejestru `b`
8. `:reg ab` -- oba rejestry maja rozne fragmenty kodu
9. Mozesz teraz wkleic dowolny z nich niezaleznie

### Cwiczenie 9: Praktyczny workflow -- swap lines

W pliku cwiczeniowym:
```
line_a = "first"
line_b = "second"
```

Zamien linie miejscami bez named registers:
1. Na `line_a`: `dd` -- usun (trafia do `""`)
2. `p` -- wklej ponizej `line_b`
3. Wynik: `line_b` jest pierwsza, `line_a` druga

Teraz zamien z uzyciem rejestrow (bezpieczniejsze):
1. `u` kilka razy -- wroc do oryginalu
2. Na `line_a`: `"add` -- usun do rejestru `a`
3. Na `line_b`: `"bdd` -- usun do rejestru `b`
4. `"bp` -- wklej `line_b`
5. `"ap` -- wklej `line_a`
6. `u` kilka razy -- cofnij

## Cwiczenie bonusowe

Otworz `exercises/python/models.py` i wykonaj:

1. Zbierz sygnatury WSZYSTKICH metod z klasy `Order` do rejestru `m` (uzyj append `"M`):
   - `def __str__`, `def total`, `def item_count`, `def add_item`, `def cancel`,
     `def create_from_cart`
2. Wklej zebrane sygnatury na koncu pliku (`G`, `"mp`)
3. W Insert mode wstaw biezaca date przed lista (`Ctrl+r =`, `strftime(...)`)

**Wyzwanie**: Skopiuj cala klase `User` do rejestru `u` i cala klase `Product` do rejestru
`p`. Potem przejdz na koniec pliku i wklej obie klasy w odwrotnej kolejnosci (`"pp`, `"up`).
Cofnij (`u`) po sprawdzeniu.

## Podsumowanie

### Nauczone komendy

| Kategoria | Komenda | Opis |
|-----------|---------|------|
| Prefix | `"{reg}` | Uzyj rejestru przed operacja |
| Unnamed | `""` | Domyslny rejestr (= schowek z clipboard=unnamedplus) |
| Yank | `"0` | Ostatni yank (nie nadpisywany przez delete!) |
| Delete | `"1`-`"9` | Historia delete'ow (FIFO) |
| Named | `"a`-`"z` | Zapisz do rejestru |
| Append | `"A`-`"Z` | Dopisz do rejestru |
| System | `"+` / `"*` | Schowek systemowy (identyczne na macOS) |
| Black hole | `"_` | Usun bez zapisywania |
| Filename | `"%` | Nazwa biezacego pliku |
| Last insert | `".` | Ostatnio wstawiony tekst |
| Last command | `":` | Ostatnia komenda Ex |
| Last search | `"/` | Ostatni wzorzec wyszukiwania |
| Expression | `"=` | Kalkulator / wyrazenia |
| Insert paste | `Ctrl+r {reg}` | Wklej rejestr w Insert/Command-line |
| View | `:reg` | Pokaz zawartosci rejestrow |

### Konfiguracja uzyta w tej lekcji

| Ustawienie | Wartosc | Efekt |
|------------|---------|-------|
| `clipboard` | `unnamedplus` | Unnamed register = schowek systemowy |

### Kluczowa wskazowka

Z `clipboard=unnamedplus` najwazniejsze rejestry to:

| Rejestr | Kiedy uzywac |
|---------|-------------|
| `"0` | Wklejanie ostatnio skopiowanego tekstu (po delete) |
| `"_` | Usuwanie bez wplywu na schowek |
| `"a`-`"z` | Przechowywanie wielu fragmentow jednoczesnie |

### Co dalej?

W **lekcji 08** poznasz **undo/redo i historie zmian** -- system cofania z persistentnymi
plikami undo (dzieki `undofile=true`), galezienie historii (undo branches), i podroz
w czasie z `:earlier`/`:later`.
