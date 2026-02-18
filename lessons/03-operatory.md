# Lekcja 03: Operatory (operators)

> Czas: ~35-45 min | Poziom: Beginner/Intermediate

## Cel lekcji

Nauczysz sie laczyc operatory (`d`, `c`, `y`) z motions z lekcji 02 w potezna formule
`operator + motion`. To jest serce efektywnosci Vima -- zamiast zaznaczac tekst mysza,
mowisz Vimowi CO chcesz zrobic i GDZIE.

## Teoria

### Formula: operator + motion

Vim dziala jak **jezyk**: skladasz zdania z czasownikow (operators) i rzeczownikow (motions).

```
{operator}{count}{motion}
     lub
{count}{operator}{motion}
```

Przyklady "zdan":
- `dw` = **d**elete **w**ord = usun slowo
- `c3w` = **c**hange **3** **w**ords = zmien 3 slowa
- `y$` = **y**ank do **$** (konca linii) = kopiuj do konca linii
- `d}` = **d**elete do **}** (nastepny paragraf) = usun do nastepnego pustego wiersza

### Trzy glowne operatory

| Operator | Opis | Co robi z tekstem |
|----------|------|-------------------|
| `d` | **Delete** | Kasuje tekst i zapisuje go w rejestrze (mozna wkleic) |
| `c` | **Change** | Kasuje tekst, zapisuje w rejestrze i wchodzi w tryb Insert |
| `y` | **Yank** | Kopiuje tekst do rejestru (nie kasuje) |

> **Twoja konfiguracja**: `clipboard = unnamedplus` oznacza, ze kazde `y` (yank) i `d` (delete)
> automatycznie trafia do **schowka systemowego**! Mozesz wkleic w innej aplikacji przez Cmd+V.
> I odwrotnie -- Cmd+C w przegladarce pozwala wkleic w Vimie przez `p`.

### Delete (d) -- usuwanie

| Komenda | Opis |
|---------|------|
| `dw` | Usun od kursora do poczatku nastepnego slowa |
| `de` | Usun od kursora do konca biezacego slowa |
| `db` | Usun od kursora do poczatku poprzedniego slowa |
| `d$` lub `D` | Usun od kursora do konca linii |
| `d0` | Usun od kursora do poczatku linii |
| `d^` | Usun od kursora do pierwszego nie-bialego znaku |
| `dd` | Usun cala linie (operator podwojony = cala linia) |
| `d}` | Usun do nastepnego pustego wiersza |
| `d{` | Usun do poprzedniego pustego wiersza |
| `dG` | Usun od biezacej linii do konca pliku |
| `dgg` | Usun od biezacej linii do poczatku pliku |
| `df{char}` | Usun do znaku (wlacznie) |
| `dt{char}` | Usun do znaku (bez niego) |

**Wazne**: `d` w Vimie to bardziej "wytnij" niz "usun" -- tekst trafia do rejestru
i mozna go wkleic za pomoca `p`. Prawdziwe usuwanie (bez rejestru) to `"_d` (rejestr
black hole) -- wiecej w lekcji 07.

### Change (c) -- zmiana

`c` dziala identycznie jak `d`, ale po usunieciu tekstu wchodzi w tryb Insert:

| Komenda | Opis |
|---------|------|
| `cw` | Zmien slowo (usun + Insert) |
| `ce` | Zmien do konca slowa |
| `cb` | Zmien do poczatku poprzedniego slowa |
| `c$` lub `C` | Zmien do konca linii |
| `c0` | Zmien do poczatku linii |
| `cc` | Zmien cala linie (usun zawartosc, zachowaj wciecie) |
| `cf{char}` | Zmien do znaku (wlacznie) |
| `ct{char}` | Zmien do znaku (bez niego) |

**Roznica `cw` vs `ce`**: Historycznie `cw` dziala tak samo jak `ce` (to wyjątek w Vimie).
Obie komendy zmieniaja tekst do konca biezacego slowa.

### Yank (y) -- kopiowanie

| Komenda | Opis |
|---------|------|
| `yw` | Kopiuj slowo |
| `ye` | Kopiuj do konca slowa |
| `y$` | Kopiuj do konca linii |
| `y0` | Kopiuj do poczatku linii |
| `yy` | Kopiuj cala linie |
| `y}` | Kopiuj do nastepnego pustego wiersza |
| `yG` | Kopiuj od biezacej linii do konca pliku |

### Put (p/P) -- wklejanie

| Komenda | Opis |
|---------|------|
| `p` | Wklej **po** kursorze (lub ponizej biezacej linii dla line-wise yank) |
| `P` | Wklej **przed** kursorem (lub powyzej biezacej linii) |

**Zachowanie `p` zalezy od tego co skopiowales**:
- Jesli `yy` (linia) -- `p` wklei nowa linie ponizej
- Jesli `yw` (slowo) -- `p` wklei tekst po kursorze

> **Twoja konfiguracja**: `clipboard = unnamedplus` -- tekst skopiowany `yy` mozesz
> wkleic w terminalu, przegladarce, Slacku itd. przez Cmd+V.

### Podwojenie operatora = cala linia

Kazdy operator podwojony dziala na cala biezaca linie:

| Komenda | Opis |
|---------|------|
| `dd` | Usun cala linie |
| `cc` | Zmien cala linie |
| `yy` | Kopiuj cala linie |

### Count -- powtarzanie

Mozesz dodac liczbe przed lub po operatorze:

| Komenda | Opis |
|---------|------|
| `3dd` | Usun 3 linie |
| `d3w` | Usun 3 slowa |
| `5yy` | Kopiuj 5 linii |
| `c2w` | Zmien 2 slowa |
| `2dw` | Usun 2 slowa (to samo co `d2w`) |

### Skroty wielkich liter

Duze litery sa czesto skrotami dla operatora + ruchu do konca/poczatku linii:

| Skrot | Rownowaznik | Opis |
|-------|-------------|------|
| `D` | `d$` | Usun do konca linii |
| `C` | `c$` | Zmien do konca linii |
| `Y` | `yy` | Kopiuj cala linie (uwaga: nie `y$`!) |
| `x` | `dl` | Usun znak pod kursorem |
| `X` | `dh` | Usun znak przed kursorem |
| `s` | `cl` | Zmien znak pod kursorem (ale masz Flash.nvim na `s`!) |
| `S` | `cc` | Zmien cala linie |

> **Uwaga**: W Twojej konfiguracji `s` jest zajety przez **Flash.nvim** (szybkie skakanie).
> Natywny `s` (substitute character) nie jest dostepny. Zamiast `s` uzywaj `cl`.

### Komenda `.` (dot) -- powtarzanie ostatniej zmiany

Komenda `.` powtarza **ostatnia zmiane** (operacje w trybie Normal lub caly "seans"
w trybie Insert). To niezwykle potezne narzedzie:

```python
# Chcesz usunac 3 podobne linie:
dd      # usun pierwsza linie
j.      # przejdz w dol, powtorz dd
j.      # przejdz w dol, powtorz dd

# Chcesz zmienic slowo w kilku miejscach:
cw          # zmien slowo na...
nowe_slowo  # ...nowe_slowo
Esc         # wroc do Normal
w.          # przejdz do nastepnego slowa i powtorz zmiane
w.          # kolejne
```

`.` zostanie szerzej omowiony w przyszlych lekcjach, ale zacznij go uzywac juz teraz.

### Wizualizacja przeplywu operacji

```
Krok 1: Operator czeka na motion
d|                    <- Vim czeka, co usunac

Krok 2: Podajesz motion
d|w                   <- usun slowo

Krok 3: Vim wykonuje
[tekst usuniety, kursor na nowej pozycji]
```

## Cwiczenia

### Cwiczenie 1: Podstawowe delete

Otworz plik:
```
nvim exercises/practice/operators.txt
```

Wpisz nastepujacy tekst:
```
Lorem ipsum dolor sit amet consectetur adipiscing elit
Sed do eiusmod tempor incididunt ut labore et dolore magna
Ut enim ad minim veniam quis nostrud exercitation ullamco
Duis aute irure dolor in reprehenderit in voluptate velit
```

1. Ustaw kursor na poczatku pierwszego slowa
2. `dw` -- usun "Lorem " (slowo + spacja)
3. `u` -- cofnij (undo)
4. `de` -- usun "Lorem" (slowo bez spacji)
5. `u` -- cofnij
6. `d$` -- usun od kursora do konca linii
7. `u` -- cofnij
8. `dd` -- usun cala linie
9. `u` -- cofnij
10. `3dd` -- usun 3 linie
11. `u` -- cofnij

### Cwiczenie 2: Delete z character find

W tym samym pliku, na linii:
```
Sed do eiusmod tempor incididunt ut labore et dolore magna
```

1. `0` -- poczatek linii
2. `dt ` -- usun do pierwszej spacji (till space) -- usunie "Sed"
3. `u` -- cofnij
4. `df ` -- usun do pierwszej spacji wlacznie -- usunie "Sed "
5. `u` -- cofnij
6. `d2f ` -- usun do drugiej spacji wlacznie -- usunie "Sed do "
7. `u` -- cofnij

### Cwiczenie 3: Change -- zmiana tekstu

Otworz `exercises/python/utils.py`:
```
nvim exercises/python/utils.py
```

1. Znajdz linie `def format_currency(...)` (linia ~21)
2. Ustaw kursor na `f` w `format`
3. `cw` -- usun "format" i wejdz w Insert
4. Wpisz `convert` i nacisnij `Esc` -- teraz jest `def convert_currency(...)`
5. `u` -- cofnij zmiane
6. Przejdz do linii z `symbols = {"USD": "$", ...}`
7. Ustaw kursor na `s` w `symbols`
8. `C` -- usun od kursora do konca linii i wejdz w Insert
9. Wpisz nowa wartosc i `Esc`
10. `u` -- cofnij

### Cwiczenie 4: Yank i put

W pliku `exercises/python/utils.py`:

1. Przejdz do linii `def validate_email(...)` (linia ~39)
2. `yy` -- kopiuj cala linie `def`
3. Przejdz kilka linii nizej
4. `p` -- wklej linie ponizej
5. `u` -- cofnij
6. Wroc do linii `def validate_email(...)`
7. `y3j` -- kopiuj 4 linie (biezaca + 3 w dol)
8. Przejdz na koniec pliku (`G`)
9. `p` -- wklej 4 linie
10. `u` -- cofnij
11. Otworz inna aplikacje i sprawdz czy mozesz wkleic (Cmd+V) -- `clipboard=unnamedplus`!

### Cwiczenie 5: Kombinacje operator + motion

W pliku `exercises/python/calculator.py`:
```
nvim exercises/python/calculator.py
```

Wykonaj ponizsze operacje (kazda cofaj `u` po sprawdzeniu):

1. Na linii `class Operation(Enum):` -- `d$` usun do konca linii
2. Na `ADD = "add"` -- `f"` znajdz cydzyslow, potem `dt"` usun zawartosc
3. Na dowolnej linii z komentarzem -- `0d^` usun wciecie
4. Na `def add(self, a: float, b: float) -> float:` -- `d}` usun cala metode (do pustego wiersza)
5. Na poczatku pliku -- `dG` usun caly plik (cofnij natychmiast `u`!)

### Cwiczenie 6: Dot command

W pliku `exercises/practice/operators.txt` wpisz:
```
TODO: fix bug in login
TODO: refactor database module
TODO: add unit tests
TODO: update documentation
DONE: deploy to staging
```

1. Ustaw kursor na pierwszej linii z `TODO`
2. `cw` -- zmien slowo, wpisz `DONE`, nacisnij `Esc`
3. `j0` -- nastepna linia, poczatek
4. `.` -- powtorz zmiane! "TODO" zmieni sie na "DONE"
5. `j0.` -- kolejna linia, powtorz
6. `j0.` -- i kolejna

Teraz inny przyklad:
```
var name = "Alice"
var email = "alice@test.com"
var age = 30
var city = "Krakow"
```

1. Na pierwszej linii: `cwconst` + `Esc` -- zmien `var` na `const`
2. `j0.` -- nastepna linia, powtorz
3. `j0.` -- kolejna
4. `j0.` -- i kolejna

### Cwiczenie 7: Laczone operacje

W pliku `exercises/python/utils.py`:

1. Znajdz funkcje `slugify` (linia ~52)
2. Skopiuj cala funkcje: ustaw kursor na `def slugify`, potem `y}` (yank do pustego wiersza)
3. Przejdz na koniec pliku (`G`)
4. `p` -- wklej
5. Zmien nazwe nowej kopii: `cw` na `slugify` -> wpisz `slugify_v2`
6. Dodaj komentarz: `O# Version 2 of slugify` + `Esc` (nowa linia powyzej)
7. `u` kilka razy zeby cofnac wszystkie zmiany

## Cwiczenie bonusowe

Otworz `exercises/python/calculator.py`. Bez uzywania trybu Visual (poznasz go w lekcji 05),
wykonaj:

1. Skopiuj metode `add` (linia ~85-95) i wklej ja na koncu klasy `Calculator`
2. Zmien nazwe z `add` na `modulo` (`cw`)
3. Zmien docstring (`cc` na linii z opisem)
4. Zmien `a + b` na `a % b` (uzyj `f+`, `cl`, wpisz `%`)
5. Zmien `Operation.ADD` na `Operation.MODULO` (uzyj `f.`, `w`, `cw`)

**Wyzwanie**: Uzyj `.` (dot) wszedzie gdzie to mozliwe do powtorzenia operacji.

Pamietaj: `u` cofnie ostatnia zmiane, wiec mozesz eksperymentowac bez obaw!

## Podsumowanie

### Nauczone komendy

| Kategoria | Komenda | Opis |
|-----------|---------|------|
| Delete | `d{motion}` | Usun tekst zdefiniowany przez motion |
| Delete | `dd` | Usun cala linie |
| Delete | `D` | Usun do konca linii |
| Delete | `x` | Usun znak pod kursorem |
| Change | `c{motion}` | Zmien tekst (usun + Insert) |
| Change | `cc` | Zmien cala linie |
| Change | `C` | Zmien do konca linii |
| Yank | `y{motion}` | Kopiuj tekst |
| Yank | `yy` | Kopiuj cala linie |
| Put | `p` / `P` | Wklej po/przed kursorem |
| Repeat | `.` | Powtorz ostatnia zmiane |
| Count | `{n}{op}{motion}` | Powtorz N razy |

### Kluczowa formula

```
{operator}{count}{motion}  =  CO zrobic + ILE razy + GDZIE
```

Przyklady:
- `d3w` = usun 3 slowa
- `c}` = zmien do nastepnego paragrafu
- `yft` = kopiuj do litery 't'
- `2dd` = usun 2 linie

### Konfiguracja uzyta w tej lekcji

| Ustawienie | Wartosc | Efekt |
|------------|---------|-------|
| `clipboard` | `unnamedplus` | Yank/delete automatycznie do schowka systemowego |

### Co dalej?

W **lekcji 04** poznasz **text objects** -- jeszcze potezniejszy sposob definiowania zakresu
operacji. Zamiast `d3w` (usun 3 slowa) bedziesz mogl napisac `diw` (delete inner word) lub
`ci"` (change inner quotes) -- niezaleznie od pozycji kursora wewnatrz obiektu!
