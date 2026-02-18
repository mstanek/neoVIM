# Lekcja 18: Neo-tree — drzewo plikow

> Czas: ~30-45 min | Poziom: Intermediate

---

## Cel lekcji

Nauczysz sie:

- Otwierac i zamykac sidebar Neo-tree
- Tworzyc, usuwac, przenosic i zmieniac nazwy plikow/katalogow
- Czytac ikony git status w drzewie plikow
- Filtrowac i przegladac ukryte pliki
- Efektywnie zarzadzac struktura projektu bez opuszczania edytora

---

## Teoria

### Czym jest Neo-tree

Neo-tree to **sidebar z drzewem plikow** — odpowiednik panelu plikow
z VS Code, IntelliJ czy innych IDE. Wyswietla sie po lewej stronie
ekranu i pokazuje strukture katalogow projektu.

```
+------------------+--------------------------------------+
| 󰙅 vim-tutor      |                                      |
| ├── exercises    |                                      |
| │   ├── python   |   (aktywny buffer)                   |
| │   │   ├──  cal |                                      |
| │   │   ├──  uti |   def calculate_total(items):        |
| │   │   └──  mod |       return sum(i.price for i in    |
| │   ├── typescri |           items)                     |
| │   │   ├── 󰛦 int|                                      |
| │   │   └── 󰛦 uti|                                      |
| │   └── vue      |                                      |
| │       └── 󰡄 Use|                                      |
| ├── lessons      |                                      |
| │   ├── 15-buf...|                                      |
| │   └── ...      |                                      |
| └── README.md    |                                      |
+------------------+--------------------------------------+
  ^ Neo-tree (35 col)  ^ Okno edytora
```

### Twoja konfiguracja

> **Toggle:** `<leader>e` — otworz/zamknij Neo-tree
>
> **Ustawienia:**
> - Szerokosc: **35 kolumn**
> - `follow_current_file = true` — automatycznie podswietla plik, ktory edytujesz
> - `group_empty_dirs = true` — kompaktowe sciezki (np. `src/utils` zamiast `src` → `utils`)
> - `close_if_last_window = true` — Neo-tree zamyka sie, jesli jest ostatnim oknem

### Skroty klawiszowe wewnatrz Neo-tree

Gdy kursor jest w oknie Neo-tree, dzialaja specjalne keybindings:

> **Operacje na plikach:**
>
> | Skrot | Dzialanie                                              |
> |-------|--------------------------------------------------------|
> | `a`   | Dodaj plik (wpisz nazwe; `/` na koncu = katalog)      |
> | `A`   | Dodaj katalog                                          |
> | `d`   | Usun plik/katalog (z potwierdzeniem)                   |
> | `r`   | Zmien nazwe (rename)                                   |
> | `c`   | Kopiuj do schowka Neo-tree                             |
> | `m`   | Wytnij (move/cut)                                      |
> | `p`   | Wklej ze schowka                                       |
>
> **Nawigacja i wyswietlanie:**
>
> | Skrot | Dzialanie                                              |
> |-------|--------------------------------------------------------|
> | `Enter` / `o` | Otworz plik / rozwin katalog                 |
> | `s`   | Otworz w split pionowym                                |
> | `S`   | Otworz w split poziomym                                |
> | `H`   | Toggle ukrytych plikow (dotfiles)                      |
> | `/`   | Filtruj drzewo (wpisz tekst)                           |
> | `R`   | Odswiez drzewo                                         |
> | `?`   | Pokaz pomoc (lista wszystkich keybindow)               |
> | `q`   | Zamknij Neo-tree                                       |
> | `<BS>` (Backspace) | Przejdz do katalogu nadrzednego          |
> | `P`   | Przejdz do katalogu rodzica biezacego elementu         |

### Dodawanie plikow — szczegoly

Gdy naciskasz `a` w Neo-tree, pojawia sie prompt do wpisania nazwy:

```
Tworzysz plik w: exercises/python/
Wpisz nazwe: _
```

- `helpers.py` — tworzy plik `exercises/python/helpers.py`
- `tests/` — tworzy katalog `exercises/python/tests/` (uwaga na `/` na koncu!)
- `tests/test_calc.py` — tworzy katalog `tests` ORAZ plik `test_calc.py` w nim

### follow_current_file

Ta opcja sprawia, ze Neo-tree **automatycznie podaza za Toba**. Gdy
przelaczysz buffer na inny plik (np. przez `Ctrl+P` lub `Shift+H/L`),
Neo-tree rozwinnie odpowiedni katalog i podswietli aktywny plik.

Dzieki temu zawsze wiesz, gdzie w strukturze projektu aktualnie jestes.

### group_empty_dirs

Gdy katalog zawiera tylko jeden podkatalog (i nic wiecej), Neo-tree
kompaktuje sciezke:

```
Bez group_empty_dirs:     Z group_empty_dirs:
├── src                   ├── src/components
│   └── components        │   ├── Button.vue
│       ├── Button.vue    │   └── Input.vue
│       └── Input.vue
```

Zmniejsza to zagniezdzenie i poprawia czytelnosc.

### Git status w Neo-tree

Neo-tree pokazuje ikony git status obok plikow i katalogow.
Kolory i ikony informuja o stanie pliku w repozytorium:

| Ikona  | Znaczenie           | Kolor         |
|--------|---------------------|---------------|
| `✚`    | Added (nowy plik)   | Zielony       |
| `●`    | Modified (zmieniony)| Zolty         |
| `✖`    | Deleted (usuniety)  | Czerwony      |
| `󰁕`    | Renamed             | Niebieski     |
| ``    | Untracked           | Szary         |
| ``    | Staged              | Zielony       |
| ``    | Conflict            | Czerwony      |

Katalogi rowniez pokazuja status — jesli jakis plik w katalogu jest
zmodyfikowany, katalog tez bedzie oznaczony.

### Neo-tree vs inne narzedzia

| Narzedzie          | Kiedy uzywac                                   |
|--------------------|------------------------------------------------|
| **Neo-tree**       | Przeglad struktury, szybkie operacje plikowe   |
| **Telescope** (`<leader>ff`) | Szukanie pliku po nazwie               |
| **Yazi** (`<leader>E`)    | Masowe operacje, podglad plikow, archiwa |
| **Ctrl+P** (smart) | Najszybsze otwieranie znanego pliku            |

Neo-tree jest najlepszy, gdy chcesz **zobaczyc kontekst** — gdzie plik
jest w projekcie, jakie sa sąsiednie pliki, jak wyglada struktura.

### Nawigacja miedzy Neo-tree a edytorem

- `<leader>e` — przejdz do Neo-tree (lub otworz, jesli zamkniety)
- `Ctrl+l` — z Neo-tree wroc do okna edytora (bo edytor jest po prawej)
- `q` — zamknij Neo-tree i wroc do edytora

Dzieki vim-tmux-navigator, `Ctrl+h/j/k/l` dziala naturalnie miedzy
Neo-tree a oknami edytora.

---

## Cwiczenia

### Cwiczenie 1: Otworz i zamknij Neo-tree

1. Nacisnij `<leader>e` — Neo-tree pojawi sie po lewej
2. Zauwaz, ze aktualnie edytowany plik jest podswietlony
3. Nawiguj strzalkami lub `j/k` po drzewie
4. Nacisnij `<leader>e` ponownie — Neo-tree sie zamknie
5. Alternatywnie: `q` zamyka Neo-tree bedzac w jego oknie

### Cwiczenie 2: Przegladanie struktury

1. Otworz Neo-tree (`<leader>e`)
2. Przejdz do katalogu `exercises/` — nacisnij `Enter` zeby rozwinac
3. Rozwin `python/`, `typescript/`, `vue/`
4. Zauwaz ikony typow plikow: `` dla Python, `󰛦` dla TypeScript, `󰡄` dla Vue
5. Uzyj `Backspace` zeby wrocic do katalogu wyzej

### Cwiczenie 3: Otwarcie pliku z Neo-tree

1. W Neo-tree nawiguj do `exercises/python/calculator.py`
2. Nacisnij `Enter` — plik otworzy sie w oknie edytora
3. Zauwaz, ze Neo-tree nadal jest otwarty, a plik podswietlony
4. Uzyj `Ctrl+l` zeby przejsc do okna edytora
5. Teraz z edytora `Ctrl+h` — wroc do Neo-tree

### Cwiczenie 4: Tworzenie nowego pliku

1. W Neo-tree nawiguj do katalogu `exercises/python/`
2. Nacisnij `a` — pojawi sie prompt
3. Wpisz `test_calculator.py` i nacisnij `Enter`
4. Plik zostanie utworzony i otwarty w edytorze
5. Wpisz jakis kod testowy, zapisz (`:w`)
6. Sprawdz w Neo-tree — plik pojawil sie w drzewie

### Cwiczenie 5: Tworzenie katalogu

1. W Neo-tree nawiguj do `exercises/`
2. Nacisnij `A` (duze A) — tworzysz katalog
3. Wpisz `sandbox` i nacisnij `Enter`
4. Katalog pojawil sie w drzewie
5. Alternatywnie: `a` i wpisz `sandbox2/` (ze slashem na koncu) — tez tworzy katalog

### Cwiczenie 6: Zmiana nazwy

1. W Neo-tree nawiguj do pliku, ktory utworzyles w cwiczeniu 4
2. Nacisnij `r` — pojawi sie prompt z aktualna nazwa
3. Zmien nazwe (np. na `test_calc.py`)
4. Nacisnij `Enter` — nazwa zmieniona
5. Zauwaz, ze jesli plik byl otwarty w buforze, buffer tez sie zaktualizowal

### Cwiczenie 7: Kopiowanie i przenoszenie

1. W Neo-tree nawiguj do jakiegos pliku
2. Nacisnij `c` (copy) — plik skopiowany do wewnetrznego schowka Neo-tree
3. Nawiguj do innego katalogu
4. Nacisnij `p` (paste) — plik skopiowany
5. Teraz na innym pliku nacisnij `m` (move/cut) i `p` w nowym miejscu — przeniesiony

### Cwiczenie 8: Toggle hidden files

1. W Neo-tree nacisnij `H` — pokaz ukryte pliki (zaczynajace sie od `.`)
2. Zauwaz pliki jak `.gitignore`, `.git/` (jesli istnieja)
3. Nacisnij `H` ponownie — ukryj je z powrotem

### Cwiczenie 9: Filtrowanie

1. W Neo-tree nacisnij `/`
2. Wpisz `.py` — drzewo pokaze tylko pliki pasujace do wzorca
3. Nacisnij `Esc` lub `Backspace` kilka razy zeby wyczyscic filtr
4. Sprobuj filtrowac po `test` — zobaczysz tylko pliki zawierajace "test"

### Cwiczenie 10: Obserwowanie git status

1. Otworz Neo-tree i zauwaz ikony git status (jesli projekt jest git repo)
2. Otworz plik z edytora i zrob jakas zmiane (nie zapisuj jeszcze)
3. Zapisz plik (`:w`)
4. Nacisnij `R` w Neo-tree — odswiez
5. Zauwaz, ze ikona przy pliku zmienila sie na `●` (modified)

---

## Cwiczenie bonusowe

**Reorganizacja struktury projektu:**

1. Otworz Neo-tree (`<leader>e`)
2. Stworz nastepujaca strukture w `exercises/sandbox/`:
   ```
   sandbox/
   ├── src/
   │   ├── main.py
   │   └── helpers.py
   ├── tests/
   │   └── test_main.py
   └── README.md
   ```
3. Uzyj `A` dla katalogow, `a` dla plikow
4. Przenies (`m` + `p`) jeden z plikow do innego katalogu
5. Zmien nazwe (`r`) pliku
6. Usun (`d`) plik README.md (potwierdzenie: `y`)
7. Sprawdz git status ikon — nowe pliki powinny byc untracked (``)
8. Na koniec usun caly katalog `sandbox/` (`d` na katalogu)

---

## Podsumowanie

| Skrot (w Neo-tree) | Dzialanie                                |
|---------------------|------------------------------------------|
| `<leader>e`         | Toggle Neo-tree                          |
| `a`                 | Dodaj plik (lub katalog z `/` na koncu)  |
| `A`                 | Dodaj katalog                            |
| `d`                 | Usun                                     |
| `r`                 | Zmien nazwe                              |
| `c` / `m` / `p`    | Kopiuj / wytnij / wklej                  |
| `H`                 | Toggle hidden files                      |
| `/`                 | Filtruj drzewo                           |
| `R`                 | Odswiez                                  |
| `?`                 | Pomoc                                    |
| `Ctrl+h/l`         | Nawigacja miedzy Neo-tree a edytorem     |

**Nastepna lekcja:** Yazi — zaawansowany menedzer plikow z podgladem,
masowymi operacjami i obsluga archiwow.
