# Cwiczenie 18: Neo-tree

> Powiazana lekcja: `lessons/18-neo-tree.md`

## Instrukcje
- `<leader>e` -- toggle Neo-tree (otworz/zamknij sidebar)
- `a` -- dodaj plik (wpisz nazwe; `/` na koncu = katalog)
- `A` -- dodaj katalog
- `d` -- usun plik/katalog (z potwierdzeniem)
- `r` -- zmien nazwe (rename)
- `c` / `m` / `p` -- kopiuj / wytnij (move) / wklej
- `H` -- toggle ukrytych plikow (dotfiles)
- `/` -- filtruj drzewo
- `R` -- odswiez drzewo
- `?` -- pokaz pomoc
- `s` / `S` -- otworz w vsplit / hsplit
- `Backspace` -- katalog nadrzedny

## Cwiczenie 1: Nawigacja i follow_current_file

1. Otworz Neo-tree: `<leader>e`
2. Uzywajac `Ctrl+l`, wroc do edytora
3. Otworz plik: `Ctrl+P` -> `calculator.py`
4. Przejdz do Neo-tree (`Ctrl+h`) -- zauwaz, ze `calculator.py` jest podswietlony
5. Wroc do edytora (`Ctrl+l`), przelacz buffer: `Shift+L`
6. Przejdz do Neo-tree -- podswietlenie podazyl o za Toba (follow_current_file)
7. Zamknij Neo-tree: `q`

## Cwiczenie 2: Otwieranie plikow na rozne sposoby

1. `<leader>e` -- otworz Neo-tree
2. Nawiguj do `exercises/typescript/api-service.ts`
3. Nacisnij `Enter` -- plik otworzy sie w edytorze
4. Wroc do Neo-tree (`Ctrl+h`)
5. Nawiguj do `exercises/typescript/interfaces.ts`
6. Nacisnij `s` -- plik otworzy sie w split pionowym obok pierwszego!
7. Wroc do Neo-tree, nawiguj do `exercises/typescript/store.ts`
8. Nacisnij `S` -- plik otworzy sie w split poziomym
9. Masz 3 pliki TypeScript w roznych splitach, otwarte z Neo-tree

## Cwiczenie 3: Tworzenie struktury projektu

Stworz nastepujaca strukture w `exercises/practice/`:

1. `<leader>e`, nawiguj do `exercises/practice/`
2. `A` -- wpisz `temp-project` -- nowy katalog
3. Wejdz do `temp-project/` (Enter)
4. `a` -- wpisz `app.py` -- nowy plik Python
5. `a` -- wpisz `config.yaml` -- nowy plik konfiguracji
6. `a` -- wpisz `tests/test_app.py` -- stworzy katalog `tests/` ORAZ plik wewnatrz!
7. Sprawdz -- powinna byc struktura:
   ```
   temp-project/
   ├── app.py
   ├── config.yaml
   └── tests/
       └── test_app.py
   ```

## Cwiczenie 4: Rename -- zmiana nazw

Kontynuujac ze struktura z cwiczenia 3:

1. Nawiguj do `app.py` w Neo-tree
2. `r` -- zmien nazwe na `main.py`
3. Nawiguj do `config.yaml`
4. `r` -- zmien nazwe na `settings.yaml`
5. Nawiguj do `tests/test_app.py`
6. `r` -- zmien nazwe na `test_main.py` (bo zmieniles `app.py` na `main.py`)
7. Jesli `main.py` byl otwarty w buforze -- sprawdz, czy buffer tez sie zaktualizowal

## Cwiczenie 5: Kopiowanie i przenoszenie miedzy katalogami

1. W Neo-tree nawiguj do `exercises/python/calculator.py`
2. `c` (copy) -- skopiowano do schowka Neo-tree
3. Nawiguj do `exercises/practice/temp-project/`
4. `p` (paste) -- `calculator.py` skopiowany do `temp-project/`
5. Teraz nawiguj do `exercises/practice/temp-project/calculator.py`
6. `m` (move/cut) -- zaznaczono do przeniesienia
7. Nawiguj do `exercises/practice/temp-project/tests/`
8. `p` (paste) -- plik przeniesiony do katalogu `tests/`

## Cwiczenie 6: Filtrowanie drzewa

1. `<leader>e` -- otworz Neo-tree (jesli zamkniety)
2. `/` -- wlacz filtr
3. Wpisz `.py` -- drzewo pokaze TYLKO pliki Python
4. Nawiguj po przefiltrowanym drzewie -- ile plikow .py jest w projekcie?
5. `Esc` kilka razy -- wyczysc filtr
6. `/` ponownie, wpisz `vue` -- tylko pliki Vue
7. `Esc` -- wyczysc
8. `/` wpisz `broken` -- znajdz wszystkie "zepsute" pliki cwiczeniowe

## Cwiczenie 7: Usuwanie z potwierdzeniem

Posprzataj pliki stworzone w cwiczeniach:

1. Nawiguj do `exercises/practice/temp-project/`
2. Staw kursor na katalogu `temp-project`
3. `d` -- Neo-tree zapyta o potwierdzenie
4. Potwierdz `y` -- caly katalog z zawartoscia zostanie usuniety
5. `R` -- odswiez drzewo, zeby upewnic sie, ze zniknal

UWAGA: `d` na katalogu usuwa rekurencyjnie -- wraz ze wszystkimi plikami wewnatrz.

## Cwiczenie 8: Eksploracja ukrytych plikow

1. W Neo-tree, bedzac w katalogu glownym projektu
2. Nacisnij `H` -- pojawia sie ukryte pliki (`.git/`, `.gitignore`, etc.)
3. Przejrzyj jakie dotfiles istnieja w projekcie
4. `H` ponownie -- ukryj je z powrotem
5. To przydatne, gdy musisz szybko edytowac `.gitignore` lub `.env`

## Cwiczenie bonusowe

**Scenariusz: reorganizacja modulu TypeScript**

Dostajesz zadanie: podziel monolityczny katalog `exercises/typescript/` na podkatalogi.
Wykonaj calą operacje z poziomu Neo-tree:

1. `<leader>e` -- otworz Neo-tree
2. Nawiguj do `exercises/typescript/`
3. Stworz katalogi: `A` -> `models/`, `A` -> `services/`, `A` -> `types/`
4. Przenoś pliki:
   - `interfaces.ts` -> `types/` (uzyj `m` na pliku, nawiguj do `types/`, `p`)
   - `api-service.ts` -> `services/` (analogicznie)
   - `store.ts` -> `models/`
5. Sprawdz nowa strukture
6. **Cofnij reorganizacje**: przenies wszystkie pliki z powrotem do `exercises/typescript/`
7. Usun puste katalogi `models/`, `services/`, `types/` (`d` na kazdym)
8. `R` -- odswiez i zweryfikuj, ze struktura jest jak na poczatku
