# Cwiczenie 08: Undo/redo i historia zmian

> Powiazana lekcja: `lessons/08-undo-redo.md`

## Instrukcje
- Undo: `u` (cofnij), Redo: `Ctrl+r` (ponow)
- Count: `5u` (cofnij 5 zmian), `3Ctrl+r` (ponow 3)
- Undo tree: `g-` (wczesniejszy stan chronologicznie), `g+` (pozniejszy)
- Czas: `:earlier 5m` (stan sprzed 5 min), `:later 30s`
- Pliki: `:earlier 1f` (stan sprzed 1 zapisu), `:later 1f`
- Checkpoint w Insert: `Ctrl+g u` (przerywa pojedyncza zmiane)
- Persistent undo: `undofile=true` -- historia przetrwa restart Neovima
- Info: `:undolist`, `:echo changenr()`

## Cwiczenie 1: Precyzyjne undo/redo

Wykonaj dokladnie 6 zmian i cwicz cofanie/ponawianie.

```python
name = "Alice"          # stan poczatkowy
```

Wykonaj zmiany w tej kolejnosci (kazda zmiana to osobna operacja w Normal mode):
1. `A` -> ` # original` -> `Esc` (zmiana 1: dodanie komentarza)
2. `0ciw` -> `user` -> `Esc` (zmiana 2: `name` -> `user`)
3. `f"ci"` -> `Bob` -> `Esc` (zmiana 3: `Alice` -> `Bob`)
4. `$a` -> `\n` -> `age = 30` -> `Esc` (zmiana 4: nowa linia... ale uzyj `o` zamiast `\n`)
   Uwaga: lepiej `o` -> `age = 30` -> `Esc`
5. `O` -> `# user data` -> `Esc` (zmiana 5: komentarz powyzej)
6. `G` -> `o` -> `active = True` -> `Esc` (zmiana 6: nowa linia na koncu)

Teraz cofaj:
- `u` -- cofnie zmiane 6 (usunie `active = True`)
- `u` -- cofnie zmiane 5 (usunie `# user data`)
- `u` -- cofnie zmiane 4 (usunie `age = 30`)
- `Ctrl+r` -- ponowi zmiane 4 (wrocisz `age = 30`)
- `2u` -- cofnie 2 zmiany naraz (4 i 3)
- `3Ctrl+r` -- ponowi 3 zmiany (3, 4, 5)

Sprawdz: `:echo changenr()` -- numer biezacej zmiany

## Cwiczenie 2: Undo tree -- galezienie historii

Ten scenariusz tworzy dwie galezi w drzewie undo.

```
Original text
```

Krok po kroku:
1. `ciw` -> `Modified` -> `Esc` -- tekst: "Modified text"
2. `w` -> `ciw` -> `version_A` -> `Esc` -- tekst: "Modified version_A"
3. `u` -- cofnij: "Modified text"
4. `u` -- cofnij: "Original text"
5. `ciw` -> `Changed` -> `Esc` -- tekst: "Changed text" (NOWA GALAZ!)
6. `w` -> `ciw` -> `version_B` -> `Esc` -- tekst: "Changed version_B"

Teraz masz drzewo:
```
Original text
    |
Modified text
    |             \
Modified          Changed text     <-- galaz 2
version_A             |
(galaz 1)        Changed version_B  <-- aktualny stan
```

Nawigacja:
- `u` -- "Changed text" (w gore gałezi 2)
- `u` -- "Original text"
- `Ctrl+r` -- "Changed text" (redo idzie po gałezi 2!)
- `u` -- "Original text"
- `g+` -- idzie CHRONOLOGICZNIE do nastepnego stanu (moze byc "Modified text"!)
- `g-` -- idzie chronologicznie wstecz
- Cwicz `g-` / `g+` zeby przejsc przez WSZYSTKIE stany, wlacznie z obydwoma galeziami

## Cwiczenie 3: :earlier i :later z czasem

Cwicz podrozowanie w czasie.

```python
# Edytuj ten plik, potem cofaj sie w czasie

items = []
```

Krok po kroku (CZEKAJ miedzy krokami!):
1. `o` -> `items.append("first")` -> `Esc`
2. Poczekaj ~5 sekund
3. `o` -> `items.append("second")` -> `Esc`
4. Poczekaj ~5 sekund
5. `o` -> `items.append("third")` -> `Esc`
6. Poczekaj ~5 sekund
7. `o` -> `print(items)` -> `Esc`

Teraz podrozuj w czasie:
- `:earlier 5s` -- wroc o 5 sekund (powinno usunac `print`)
- `:earlier 5s` -- wroc o kolejne 5 sekund (usunie `third`)
- `:later 10s` -- przejdz 10 sekund do przodu
- `:earlier 20s` -- wroc o 20 sekund (prawie do stanu poczatkowego)
- `:later 1m` -- wroc o minute do przodu (do najnowszego stanu)

## Cwiczenie 4: Checkpointy z :w i :earlier Nf

Uzyj zapisow pliku jako checkpointow.

Otworz plik tymczasowy:
```
nvim /tmp/undo-test.py
```

1. Wpisz: `version = 1` -> `Esc`
2. `:w` -- CHECKPOINT 1
3. `cc` -> `version = 2` -> `Esc`
4. `o` -> `# added in v2` -> `Esc`
5. `:w` -- CHECKPOINT 2
6. `cc` na linii z `version`: -> `version = 3` -> `Esc`
7. `dd` -- usun komentarz
8. `o` -> `# v3 is the latest` -> `Esc`
9. `:w` -- CHECKPOINT 3

Nawigacja po checkpointach:
- `:earlier 1f` -- wroc do CHECKPOINTU 2 (stan po zapisie 2)
- `:earlier 1f` -- wroc do CHECKPOINTU 1 (stan po zapisie 1)
- `:later 2f` -- przejdz o 2 zapisy do przodu (CHECKPOINT 3)
- `:earlier 3f` -- wroc o 3 zapisy (poczatkowy stan -- pusty plik!)

## Cwiczenie 5: Ctrl+g u -- granulacja undo w Insert mode

Bez `Ctrl+g u` caly seans Insert jest JEDNA zmiana. Z nim mozesz dzielic na mniejsze.

```
# Wpisz tutaj 3 zdania jako 3 oddzielne zmiany undo:
```

Zadanie:
1. `o` -- wejdz w Insert pod ta linia
2. Wpisz: `Pierwsze zdanie jest krotkie. `
3. `Ctrl+g u` -- checkpoint undo (ale dalej jestes w Insert!)
4. Wpisz: `Drugie zdanie jest srednie dlugosci. `
5. `Ctrl+g u`
6. Wpisz: `Trzecie zdanie konczy akapit.`
7. `Esc` -- wroc do Normal

Teraz testuj:
- `u` -- cofnie TYLKO "Trzecie zdanie..."
- `u` -- cofnie TYLKO "Drugie zdanie..."
- `u` -- cofnie TYLKO "Pierwsze zdanie..."
- `Ctrl+r` `Ctrl+r` `Ctrl+r` -- przywroc wszystkie 3

Porownaj: bez `Ctrl+g u` jedno `u` cofneloby CALY tekst naraz.

## Cwiczenie 6: Persistent undo -- historia po restarcie

To cwiczenie wymaga zamkniecia i ponownego otwarcia pliku.

1. Otworz: `nvim /tmp/persistent-test.py`
2. Wpisz: `state = "original"` -> `Esc` -> `:w`
3. `cc` -> `state = "modified"` -> `Esc` -> `:w`
4. `cc` -> `state = "final"` -> `Esc` -> `:w`
5. `:q` -- zamknij Neovima
6. Otworz ponownie: `nvim /tmp/persistent-test.py`
7. `u` -- cofnie do `state = "modified"` (persistent undo!)
8. `u` -- cofnie do `state = "original"`
9. `Ctrl+r` `Ctrl+r` -- wroc do `state = "final"`

Persistent undo dziala dzieki `undofile=true`. Historia jest przechowywana
w `~/.config/nvim/undodir/`.

## Cwiczenie 7: Eksperymentowanie z galeziami

Scenariusz: probowanie dwoch roznych podejsc do tego samego problemu.

```python
def calculate(a, b):
    return a + b
```

Eksperyment 1:
1. `cc` na `return`: -> `    result = a * b` -> `Esc`
2. `o` -> `    return result` -> `Esc`

Nie podoba sie? Cofnij i sprobuj inaczej:
3. `2u` -- cofnij obie zmiany (wroc do `return a + b`)

Eksperyment 2:
4. `cc` na `return`: -> `    if b == 0: return 0` -> `Esc`
5. `o` -> `    return a / b` -> `Esc`

Teraz masz DWA eksperymenty w undo tree!
6. `2u` -- wroc do `return a + b`
7. `g+` -- idz chronologicznie: zobaczysz stan z eksperymentu 1
8. `g+` -- dalej: nastepny stan z eksperymentu 1
9. `g+` -- dalej: stany z eksperymentu 2
10. `g-` -- wstecz: wroc do eksperymentu 1

`:undolist` -- pokaz strukture galezi

## Cwiczenie 8: Praktyczny workflow -- bezpieczny refactoring

Otworz `exercises/python/utils.py` i wykonaj "bezpieczny refactoring":

1. `:w` -- CHECKPOINT (zapamietaj: mozesz tu wrocic!)
2. Znajdz funkcje `format_currency`. Zmien nazwe na `format_money`:
   - Kursor na `format_currency`. `ciw` -> `format_money` -> `Esc`
3. Zmien domyslna walute z `"USD"` na `"EUR"`:
   - Znajdz `"USD"`. `ci"` -> `EUR` -> `Esc`
4. Hmm, nie podoba sie. `:earlier 1f` -- wroc do ostatniego zapisu!
5. Sprobuj inaczej: zmien tylko nazwe, zostaw walute:
   - `ciw` na `format_currency` -> `money_format` -> `Esc`
6. `:w` -- NOWY CHECKPOINT
7. Kontynuuj edycje...
8. Jesli cos popsules: `:earlier 1f` -- bezpieczny powrot!
9. Na koncu: `u` wielokrotnie az do oryginalnego stanu

## Cwiczenie bonusowe

Otworz `exercises/python/calculator.py` i przeprowadz scenariusz:

1. `:w` -- checkpoint poczatkowy
2. Zrefaktoryzuj metode `divide`:
   - Zmien blok `try/except` na proste sprawdzenie `if b == 0`
   - Zmien wiadomosc bledu
   - `:w` -- checkpoint po refaktorze
3. Teraz zmien zdanie: chcesz jednak `try/except`:
   - `:earlier 1f` -- wroc do checkpointu
   - Zrob inna wersje refaktoru (np. dodaj logging)
   - `:w`
4. Porownaj obie wersje:
   - `g-` wielokrotnie -- znajdz pierwsza wersje refaktoru
   - `g+` wielokrotnie -- znajdz druga wersje
   - Zdecyduj sie na jedna
5. Cofnij do oryginalu: `:earlier 3f` (wroc o 3 zapisy)

Wyzwanie: zamknij i otworz ponownie plik, potem uzyj `u` zeby potwierdzic
ze persistent undo zachowalo cala historie (wlacznie z galeziami!).
