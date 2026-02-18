# Lekcja 08: Undo/redo i historia zmian

> Czas: ~30-40 min | Poziom: Intermediate

## Cel lekcji

Zrozumienie systemu undo/redo w Vimie, ktory jest znacznie potezniejszy niz w typowych
edytorach. Vim nie ma liniowej historii -- ma **drzewo undo** (undo tree), gdzie kazda
galaz jest zachowana. Dzieki Twojej konfiguracji `undofile = true` historia przetrwa
zamkniecie pliku i restart Neovima!

## Teoria

### Podstawowe undo/redo

| Komenda | Opis |
|---------|------|
| `u` | **Undo** -- cofnij ostatnia zmiane |
| `Ctrl+r` | **Redo** -- ponow cofnieta zmiane |
| `U` | Cofnij WSZYSTKIE zmiany w biezacej linii (rzadko uzywane) |

**Co jest "zmiana"?** Kazde wejscie i wyjscie z trybu Insert to jedna zmiana.
Np. wpisujesz 5 zdan w trybie Insert, potem naciskasz `Esc` -- to jest 1 zmiana.
Ale `dd` (delete line) w Normal mode to tez 1 zmiana.

```
Zmiana 1: dd          -- usun linie
Zmiana 2: i...Esc     -- caly seans Insert
Zmiana 3: cw...Esc    -- zmiana slowa
Zmiana 4: 3dd         -- usun 3 linie (jedna zmiana, mimo ze 3 linie)
```

`u` cofa po jednej zmianie. Mozesz naciskac `u` wielokrotnie:
```
u       -- cofnij zmiane 4
u       -- cofnij zmiane 3
u       -- cofnij zmiane 2
Ctrl+r  -- ponow zmiane 2
Ctrl+r  -- ponow zmiane 3
```

### Count z undo/redo

| Komenda | Opis |
|---------|------|
| `5u` | Cofnij 5 zmian naraz |
| `3Ctrl+r` | Ponow 3 zmiany naraz |

### Persistent undo -- historia po zamknieciu pliku

> **Twoja konfiguracja**: `undofile = true` wlacza **persistent undo**. Vim zapisuje
> historie zmian do pliku na dysku. Dzieki temu mozesz:
> 1. Edytowac plik
> 2. Zapisac i zamknac Vim (`:wq`)
> 3. Otworzyc plik ponownie
> 4. Naciskac `u` i cofac zmiany sprzed zamkniecia!
>
> Pliki undo sa przechowywane w: `~/.config/nvim/undodir/`
> Kazdy edytowany plik ma swoj plik undo w tym katalogu.

**Uwaga**: Persistent undo dziala **tylko jesli zapisales plik** (`:w`) przed zamknieciem.
Niezapisane zmiany nie sa przechowywane w pliku undo.

**Bezpieczenstwo**: Pliki undo moga rosnac z czasem. Jesli chcesz je wyczyscic:
```
:echo &undodir     -- sprawdz gdzie sa przechowywane
```

### Undo tree (drzewo undo)

To jest fundamentalna roznica miedzy Vimem a innymi edytorami. W typowym edytorze historia
jest **liniowa** -- jesli cofniesz i zrobisz nowa zmiane, stara sciezka redo jest **utracona**.

W Vimie historia jest **drzewem** -- stara sciezka redo jest **zawsze zachowana**!

#### Scenariusz

```
Stan poczatkowy: "Hello World"

1. Zmien na "Hello Vim"         (zmiana 1)
2. Zmien na "Hello Neovim"      (zmiana 2)
3. u -- cofnij: "Hello Vim"
4. Zmien na "Hello Editor"      (zmiana 3 -- NOWA GALAZ!)

Historia liniowa (inne edytory):
  Hello World -> Hello Vim -> Hello Editor
  ("Hello Neovim" utracone na zawsze!)

Undo tree (Vim):
  Hello World -> Hello Vim -> Hello Neovim    (galaz 1)
                           \-> Hello Editor   (galaz 2, aktywna)
  ("Hello Neovim" jest ZACHOWANE!)
```

### Nawigacja po undo tree

Standardowe `u` i `Ctrl+r` poruszaja sie po **biezacej gałezi**. Zeby przeskakiwac
miedzy galeziami, uzyj:

| Komenda | Opis |
|---------|------|
| `g-` | Przejdz do **wczesniejszego** stanu w drzewie (chronologicznie) |
| `g+` | Przejdz do **pozniejszego** stanu w drzewie (chronologicznie) |

**Roznica `u` vs `g-`**:
- `u` idzie w gore biezacej gałezi (moze nie dojsc do stanow z innej galezi)
- `g-` idzie do **poprzedniego stanu w czasie** (niezaleznie od galezi!)

#### Wizualizacja

```
     (1) Hello World
      |
     (2) Hello Vim
      |         \
     (3) Hello    (4) Hello Editor    <-- aktualny stan
         Neovim

u na stanie (4):     wraca do (2)  -- idzie w gore gałezi
g- na stanie (4):    wraca do (3)  -- idzie do poprzedniego STANU w czasie
                                      (3 bylo zrobione PRZED 4, mimo ze jest na innej gałezi)
```

### Podroz w czasie: `:earlier` i `:later`

Vim pozwala cofnac sie do stanu pliku sprzed okreslonego czasu:

| Komenda | Opis |
|---------|------|
| `:earlier {N}s` | Stan sprzed N sekund |
| `:earlier {N}m` | Stan sprzed N minut |
| `:earlier {N}h` | Stan sprzed N godzin |
| `:earlier {N}d` | Stan sprzed N dni |
| `:earlier {N}f` | Stan sprzed N zapisow pliku (`:w`) |
| `:later {N}s` | Stan N sekund do przodu |
| `:later {N}m` | Stan N minut do przodu |
| `:later {N}h` | Stan N godzin do przodu |
| `:later {N}f` | Stan N zapisow do przodu |

Przyklady:
```vim
:earlier 5m      " cofnij sie do stanu sprzed 5 minut
:earlier 1h      " cofnij sie do stanu sprzed godziny
:earlier 3f      " cofnij sie o 3 zapisy pliku
:later 30s       " przejdz 30 sekund do przodu
```

> **Twoja konfiguracja**: Z `undofile = true`, `:earlier` dziala nawet po zamknieciu
> i ponownym otwarciu pliku! Mozesz otworzyc plik rano i napisac `:earlier 2h` zeby
> zobaczyc stan sprzed 2 godzin (jesli plik miał persistent undo).

### Informacje o undo

| Komenda | Opis |
|---------|------|
| `:undolist` | Pokaz liscie galezi undo tree |
| `:echo changenr()` | Numer biezacej zmiany |
| `:echo undotree()` | Struktura drzewa undo (szczegolowa, dla debuggowania) |

### Co wplywa na "granice zmian"?

Kazda zmiana w undo tree jest oddzielona granicami. Domyslne granice:

| Akcja | Tworzy nowa zmiane? |
|-------|---------------------|
| Wejscie w Insert i wyjscie (`i...Esc`) | Tak -- caly seans Insert = 1 zmiana |
| `dd`, `dw`, `x` w Normal | Tak -- kazda operacja = 1 zmiana |
| `3dd` | Tak -- 1 zmiana (mimo 3 linii) |
| Ruch w Insert (`Ctrl+o j`) | Nie (ale przerwa `Ctrl+g u` tak!) |

**Tip**: Jesli piszesz dluzszy tekst w trybie Insert i chcesz podzielic go na mniejsze
zmiany (dla lepszej granulacji undo), nacisnij `Ctrl+g u` w Insert mode -- to tworzy
punkt przerwania undo.

### Praktyczne wzorce

#### Wzorzec 1: "Bezpieczne eksperymentowanie"

```
1. Zrob zmiane eksperymentalna
2. Nie dziala? u -- cofnij
3. Sprobuj inaczej
4. Tez nie dziala? u -- cofnij
5. Oba rozwiazania sa zachowane w undo tree!
6. g-/g+ do nawigacji miedzy nimi
```

#### Wzorzec 2: "Checkpoint z zapisem"

```
1. Edytuj plik
2. :w -- zapisz (checkpoint)
3. Edytuj dalej
4. Cos poszlo nie tak
5. :earlier 1f -- wroc do ostatniego zapisu!
```

#### Wzorzec 3: "Odzyskaj z persistent undo"

```
1. Wczoraj edytowales plik
2. Dzis otwierasz ponownie
3. :earlier 1d -- wroc do stanu sprzed 1 dnia
4. Skopiuj potrzebny fragment
5. :later 1d -- wroc do biezacego stanu
6. Wklej fragment
```

### Czeste pulapki

| Pulapka | Rozwiazanie |
|---------|-------------|
| `u` nie cofa wystarczajaco daleko | Uzyj `:earlier` z czasem |
| Po undo + nowej zmianie nie moge redo | Uzyj `g-`/`g+` do nawigacji po drzewie |
| Stracam kontekst po wielu `u` | Uzyj `:earlier 5m` zamiast wielu `u` |
| Undo cofa za duzo (caly Insert seans) | Uzyj `Ctrl+g u` w Insert do tworzenia checkpointow |

## Cwiczenia

### Cwiczenie 1: Podstawowe undo/redo

Otworz plik:
```
nvim exercises/python/calculator.py
```

1. Przejdz do metody `add` (linia ~85)
2. `dd` -- usun linie z `def add`
3. `dd` -- usun nastepna linie (docstring)
4. `dd` -- usun jeszcze jedna
5. Teraz cofaj: `u` -- wroci ostatnia usunięta linie
6. `u` -- wroci druga
7. `u` -- wroci pierwsza
8. `Ctrl+r` -- redo: usunie ponownie pierwsza
9. `Ctrl+r` -- usunie druga
10. `u` `u` -- cofnij obie
11. Sprawdz: plik powinien byc w oryginalnym stanie

### Cwiczenie 2: Count z undo

W tym samym pliku:

1. Wykonaj 5 roznych zmian:
   - `dd` na linii ~85
   - `x` na jakims znaku
   - `cw` + `test` + `Esc` na jakims slowie
   - `dd` na kolejnej linii
   - `A` + ` # comment` + `Esc` na koncu jakiejs linii
2. `5u` -- cofnij wszystkie 5 zmian naraz!
3. `3Ctrl+r` -- ponow 3 zmiany
4. `2u` -- cofnij 2 z powrotem
5. Plik powinien miec tylko pierwsza zmiane ponowiona

### Cwiczenie 3: Undo tree -- galezienie

Wpisz w pliku cwiczeniowym:
```
nvim exercises/practice/registers.txt
```

Wpisz (lub dodaj) linie:
```
Original text here
```

1. `cw` -> wpisz `Modified` -> `Esc` (tekst: "Modified text here")
2. `u` -- cofnij (tekst: "Original text here")
3. `cw` -> wpisz `Changed` -> `Esc` (tekst: "Changed text here")
   - Teraz masz DWE galezi: "Modified" i "Changed"
4. `u` -- cofnij: "Original text here"
5. `Ctrl+r` -- redo: "Changed text here" (biezaca galaz)
6. `u` -- cofnij: "Original text here"
7. `g+` -- pozniejszy stan chronologicznie: "Changed text here"
8. `g-` -- wczesniejszy stan: "Original text here"
9. `g-` -- jeszcze wczesniejszy: moze dojsc do "Modified text here"!

### Cwiczenie 4: `:earlier` i `:later`

W tym samym pliku:

1. Zapisz plik: `:w`
2. Poczekaj 5 sekund
3. `dd` -- usun linie
4. `o` -> wpisz `New line 1` -> `Esc`
5. `o` -> wpisz `New line 2` -> `Esc`
6. `:earlier 5s` -- wroc do stanu sprzed 5 sekund!
7. Plik powinien byc w stanie z punktu 1 (po `:w`)
8. `:later 5s` -- wroc 5 sekund do przodu
9. `u` kilka razy -- wroc do czystego stanu

### Cwiczenie 5: `:earlier` z zapisami pliku

W pliku cwiczeniowym:

1. Wpisz: `Version 1` -> `Esc`
2. `:w` -- zapisz (checkpoint 1)
3. `cc` -> `Version 2` -> `Esc`
4. `:w` -- zapisz (checkpoint 2)
5. `cc` -> `Version 3` -> `Esc`
6. `:w` -- zapisz (checkpoint 3)
7. `:earlier 1f` -- cofnij o 1 zapis (Version 2)
8. `:earlier 1f` -- cofnij o kolejny zapis (Version 1)
9. `:later 2f` -- wroc o 2 zapisy do przodu (Version 3)
10. `u` kilka razy -- wroc do czystego stanu

### Cwiczenie 6: Persistent undo

To cwiczenie demonstrowane persistent undo. Wymaga zamkniecia i ponownego otwarcia pliku:

1. Otworz plik: `nvim exercises/practice/registers.txt`
2. Wpisz na koncu pliku: `o` -> `Persistent undo test: ABC` -> `Esc`
3. Zapisz: `:w`
4. Zmien `ABC` na `XYZ`: `$bciw` -> `XYZ` -> `Esc`
5. Zapisz: `:w`
6. Zamknij Vim: `:q`
7. Otworz ponownie: `nvim exercises/practice/registers.txt`
8. `u` -- cofnij! Powinno zmienic `XYZ` z powrotem na `ABC`
9. `u` -- cofnij dalej! Powinno usunac cala linie `Persistent undo test`
10. Persistent undo dziala -- historia przetrwala restart Vima!
11. `Ctrl+r` `Ctrl+r` -- przywroc zmiany

### Cwiczenie 7: Checkpoint z Ctrl+g u

1. Wejdz w Insert mode (`i` lub `o`)
2. Wpisz: `Czesc pierwsza zdania. `
3. Nacisnij `Ctrl+g u` (tworzy checkpoint undo BEZ wychodzenia z Insert!)
4. Wpisz: `Czesc druga zdania. `
5. Nacisnij `Ctrl+g u`
6. Wpisz: `Czesc trzecia zdania.`
7. `Esc` -- wroc do Normal
8. `u` -- cofnie TYLKO "Czesc trzecia" (dzieki checkpointom!)
9. `u` -- cofnie "Czesc druga"
10. `u` -- cofnie "Czesc pierwsza"
11. Bez `Ctrl+g u` -- jedno `u` cofneloby caly tekst naraz

### Cwiczenie 8: Praktyczny workflow -- eksperymentowanie

Otworz `exercises/python/calculator.py`:

1. Zapisz jako checkpoint: `:w`
2. **Eksperyment 1**: Zmien nazwe metody `add` na `sum` (uzyj `cw`)
3. Zmien cialo metody
4. Hmm, nie podoba Ci sie... `3u` -- cofnij
5. **Eksperyment 2**: Zmien nazwe na `plus` (uzyj `cw`)
6. Zmien cialo inaczej
7. Tez nie podoba... ale chcesz wrocic do eksperymentu 1!
8. `g-` kilka razy -- nawiguj chronologicznie az zobaczysz `sum`
9. `g+` kilka razy -- wroc do `plus`
10. Zdecyduj sie na jedno i cofnij reszta (`u` kilka razy)
11. `:w` -- zapisz finalna wersje

Alternatywnie: `:earlier 1f` wroci do stanu z kroku 1 (ostatni zapis)!

### Cwiczenie 9: Sprawdzanie undolist

1. Wykonaj kilka zmian w roznych galeziach (jak w cwiczeniu 3)
2. `:undolist` -- pokaz liste galezi
3. Wyswietli cos takiego:
   ```
   number changes  when               saved
       3      2    2026/02/18 14:30:00
       5      4    2026/02/18 14:30:15    1
   ```
4. Kazdy wiersz to lisc (koniec galezi) w drzewie undo

## Cwiczenie bonusowe

Otworz `exercises/python/calculator.py` i przeprowadz nastepujacy scenariusz:

1. **Checkpoint**: `:w`
2. Zrefaktoryzuj metode `divide` -- zmien nazwe na `safe_divide`, dodaj domyslna wartosc
   zwracana przy dzieleniu przez zero zamiast wyjatku
3. `:w` -- zapisz (checkpoint 2)
4. Zmien zdanie -- chcesz jednak wyjatek. Uzyj `:earlier 1f` zeby wrocic do checkpointu 1
5. Zrefaktoryzuj inaczej -- dodaj logowanie bledu przed wyrzuceniem wyjatku
6. Porownaj oba podejscia uzywajac `g-`/`g+`
7. Wybierz preferowane rozwiazanie
8. Cofnij wszystko do oryginalnego stanu: `:earlier 2f` (wroc o 2 zapisy)

**Wyzwanie**: Zamknij i ponownie otworz plik, potem uzyj `u` zeby cofnac sie do stanu
sprzed cwiczenia. Persistent undo powinno to umozliwic!

## Podsumowanie

### Nauczone komendy

| Kategoria | Komenda | Opis |
|-----------|---------|------|
| Podstawowe | `u` | Undo -- cofnij zmiane |
| Podstawowe | `Ctrl+r` | Redo -- ponow zmiane |
| Podstawowe | `U` | Cofnij wszystkie zmiany w linii |
| Count | `{n}u` | Cofnij N zmian |
| Count | `{n}Ctrl+r` | Ponow N zmian |
| Drzewo | `g-` | Poprzedni stan chronologicznie |
| Drzewo | `g+` | Nastepny stan chronologicznie |
| Czas | `:earlier {N}s/m/h/d` | Cofnij o czas |
| Czas | `:earlier {N}f` | Cofnij o N zapisow pliku |
| Czas | `:later {N}s/m/h/d` | Przejdz o czas do przodu |
| Czas | `:later {N}f` | Przejdz o N zapisow do przodu |
| Checkpoint | `Ctrl+g u` | Punkt undo w trybie Insert |
| Info | `:undolist` | Lista galezi undo tree |

### Konfiguracja uzyta w tej lekcji

| Ustawienie | Wartosc | Efekt |
|------------|---------|-------|
| `undofile` | `true` | Historia undo zapisywana na dysku |
| `undodir` | `~/.config/nvim/undodir` | Katalog z plikami undo |

### Kluczowe koncepcje

1. **Undo tree, nie undo list** -- kazda galaz jest zachowana, `g-`/`g+` nawiguje chronologicznie
2. **Persistent undo** -- historia przetrwa restart Neovima (undofile=true)
3. **Podroz w czasie** -- `:earlier 5m` cofnie do stanu sprzed 5 minut
4. **Checkpointy** -- `:w` tworzy punkt odniesienia dla `:earlier {N}f`
5. **Granulacja** -- `Ctrl+g u` w Insert dzieli dlugie sesje edycji na mniejsze zmiany

### Podsumowanie modulu 1

Gratulacje! Ukonczyles **modul 1** (lekcje 01-08). Oto co opanowales:

| Lekcja | Temat | Kluczowe umiejetnosci |
|--------|-------|-----------------------|
| 01 | Tryby pracy | Normal/Insert/Visual/Command, `h/j/k/l` |
| 02 | Ruchy (motions) | `w/b/e`, `f/t`, `{/}`, `gg/G`, `%` |
| 03 | Operatory | `d/c/y` + motions, `.` (dot repeat) |
| 04 | Text objects | `i/a` + `w/"/(/{/t/f/c/a` (z mini.ai) |
| 05 | Visual mode | `v/V/Ctrl+v`, block edit, indent |
| 06 | Szukanie | `/pattern`, `*/#`, `:%s///g`, inccommand |
| 07 | Rejestry | `"0`, `"a-z`, `"_`, `Ctrl+r`, clipboard |
| 08 | Undo/redo | `u/Ctrl+r`, `g-/g+`, `:earlier`, persistent undo |

Masz teraz solidne fundamenty do efektywnej pracy w Neovimie. Kolejne lekcje beda
budowac na tej wiedzy, wprowadzajac pluginy (Flash.nvim, snacks.nvim, bufferline),
zaawansowane techniki edycji, i workflow specyficzny dla programowania.
