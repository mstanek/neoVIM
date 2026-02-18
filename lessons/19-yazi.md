# Lekcja 19: Yazi — zaawansowany menedzer plikow

> Czas: ~30-45 min | Poziom: Intermediate

---

## Cel lekcji

Nauczysz sie:

- Otwierac Yazi z Neovim i tmux
- Nawigowac, kopiowac, przenosic i usuwac pliki w Yazi
- Korzystac z podgladu plikow (code, obrazy, PDF)
- Masowo zmieniac nazwy plikow (bulk rename)
- Rozumiec, kiedy uzywac Yazi zamiast Neo-tree

---

## Teoria

### Czym jest Yazi

Yazi to **terminalowy menedzer plikow** nowej generacji, napisany w Rust.
W przeciwienstwie do Neo-tree (ktory jest sidebarowym drzewem plikow w Neovim),
Yazi to pelnoekranowy file manager z:

- Podgladem plikow (kod z syntax highlighting, obrazy, PDF)
- Masowymi operacjami na plikach
- Szybka nawigacja (asynchroniczne ladowanie)
- Obsluga archiwow (zip, tar, etc.)

```
+------------------+---------------------------+----------------------+
| Parent dir       | Current dir               | Preview              |
|                  |                           |                      |
|  exercises/      |  calculator.py       │    | def add(a, b):       |
|  lessons/        |  models.py                |     """Add two."""   |
|  README.md       | >utils.py            ●    |     return a + b     |
|                  |  broken.py                |                      |
|                  |  data_processing.py       | def subtract(a, b):  |
|                  |                           |     return a - b     |
|                  |                           |                      |
+------------------+---------------------------+----------------------+
| ~ exercises/python          3/5   utils.py  1.2 KB   rw-r--r--    |
+------------------------------------------------------------------+
  ^ Parent             ^ Current                ^ Preview (live!)
```

### Yazi vs Neo-tree — kiedy uzywac czego

| Cecha                    | Neo-tree                | Yazi                       |
|--------------------------|-------------------------|----------------------------|
| Uzycie                   | Sidebar w edytorze      | Pelnoekranowy (floating)   |
| Podglad plikow           | Brak                    | Kod, obrazy, PDF           |
| Masowe operacje           | Pojedyncze pliki       | Bulk rename, multi-select  |
| Archiwa                  | Nie obsluguje           | Otwiera zip, tar, etc.     |
| Git status               | Ikony w drzewie         | Brak (lub ograniczony)     |
| Integracja z bufferami   | Otwiera w nvim          | Otwiera w nvim             |
| Idealne do               | Przegladanie struktury  | Zarzadzanie plikami         |

**Zasada:** Neo-tree do **przegladu**, Yazi do **akcji na plikach**.

### Twoja konfiguracja

> **Otwieranie Yazi:**
>
> | Skrot              | Dzialanie                                     |
> |--------------------|-----------------------------------------------|
> | `<leader>E`        | Yazi w floating window (90% ekranu, rounded)  |
> | `<leader>ew`       | Yazi w biezacym working directory              |
> | `Cmd+Shift+Y`      | Yazi w tmux popup (80% x 85%)                 |

**Roznica miedzy trybami:**

- `<leader>E` — otwiera Yazi w katalogu biezacego pliku. Floating window
  wewnatrz Neovim. Wybrany plik otworzy sie jako buffer.
- `<leader>ew` — otwiera Yazi w CWD projektu (`:pwd`). Przydatne, gdy
  chcesz przeglądac caly projekt, nie tylko katalog biezacego pliku.
- `Cmd+Shift+Y` — otwiera Yazi jako tmux popup. Niezalezny od Neovim —
  dziala nawet bez otwartego edytora.

### Nawigacja w Yazi

Yazi uzywa tego samego modelu nawigacji co Vim:

| Skrot      | Dzialanie                                       |
|-----------|--------------------------------------------------|
| `h`        | Katalog nadrzedny (w lewo)                      |
| `j` / `k`  | Gora / dol w liscie plikow                     |
| `l` / `Enter` | Wejdz do katalogu / otworz plik              |
| `~`        | Przejdz do home directory                       |
| `/`        | Szukaj w biezacym katalogu                      |
| `q`        | Wyjdz z Yazi (wroc do Neovim)                  |
| `G`        | Przejdz na koniec listy                         |
| `gg`       | Przejdz na poczatek listy                       |

### Operacje na plikach

| Skrot      | Dzialanie                                       |
|-----------|--------------------------------------------------|
| `a`        | Nowy plik (wpisz nazwe; `/` na koncu = katalog) |
| `r`        | Zmien nazwe                                     |
| `d`        | Usun do kosza (trash)                           |
| `D`        | Usun permanentnie                               |
| `y`        | Yank — kopiuj (zaznacz do schowka)              |
| `x`        | Cut — wytnij (zaznacz do przeniesienia)         |
| `p`        | Paste — wklej skopiowane/wyciete pliki          |
| `Space`    | Toggle zaznaczenie pliku (multi-select)         |
| `V`        | Zaznacz w trybie visual (zakres)                |

### Multi-select — zaznaczanie wielu plikow

Yazi pozwala zaznaczac wiele plikow jednoczesnie:

1. `Space` na pliku — toggle zaznaczenia (plik zostaje podswietlony)
2. Powtorz na kolejnych plikach
3. Teraz `y` (kopiuj), `x` (wytnij) lub `d` (usun) — dziala na WSZYSTKICH zaznaczonych

To kluczowa roznica vs Neo-tree, gdzie operujesz na jednym pliku naraz.

### Podglad plikow (preview)

Prawa kolumna Yazi to **live preview**:

| Typ pliku         | Podglad                                    |
|-------------------|--------------------------------------------|
| Kod zrodlowy      | Syntax highlighting (bat/bat-based)        |
| Obrazy (PNG/JPG)  | Podglad w terminalu (Kitty image protocol) |
| PDF               | Tekst z pierwszych stron                   |
| Archiwa (zip/tar) | Lista plikow w archiwum                    |
| Katalogi          | Lista plikow w katalogu                    |
| Markdown          | Renderowany podglad                        |

Kitty terminal wspiera **image protocol**, wiec Yazi moze wyswietlac
faktyczne obrazy w terminalu — nie ASCII art, ale prawdziwe piksele.

### Bulk rename

Jedna z najsilniejszych cech Yazi. Pozwala masowo zmieniac nazwy plikow:

1. Zaznacz pliki (`Space` na kazdym lub `V` + zakres)
2. Nacisnij `r` (rename) — otworzy sie edytor z lista nazw
3. Edytuj nazwy w edytorze (mozesz uzywac Vim macros, `:s/pattern/replace/`)
4. Zapisz i zamknij — nazwy zostana zmienione

To odpowiednik `mmv` lub `rename` w shellu, ale z interfejsem Vim.

### Sortowanie i filtrowanie

| Skrot      | Dzialanie                                       |
|-----------|--------------------------------------------------|
| `,m`       | Sortuj po dacie modyfikacji                     |
| `,n`       | Sortuj po nazwie                                |
| `,s`       | Sortuj po rozmiarze                             |
| `,e`       | Sortuj po rozszerzeniu                          |
| `.`        | Toggle ukrytych plikow (dotfiles)               |
| `f`        | Filtruj po nazwie (tymczasowy filtr)            |

### Archiwa

Yazi potrafi otwierac archiwa jak katalogi:

- Nawiguj do pliku `.zip`, `.tar.gz`, `.7z`
- Nacisnij `l` lub `Enter` — Yazi "wejdzie" do archiwum
- Mozesz przegladac zawartosc i kopiowac pliki

---

## Cwiczenia

### Cwiczenie 1: Otworz Yazi z Neovim

1. Bedzac w Neovim, nacisnij `<leader>E`
2. Yazi otworzy sie w floating window
3. Zauwaz 3 kolumny: parent, current, preview
4. Nawiguj `j/k` — podglad zmienia sie w czasie rzeczywistym
5. Nacisnij `q` — wroc do Neovim

### Cwiczenie 2: Nawigacja po projekcie

1. Otworz Yazi (`<leader>E`)
2. Uzyj `h` zeby przejsc do katalogu nadrzednego
3. Uzyj `l` lub `Enter` zeby wejsc do `exercises/`
4. Nawiguj do `python/` → zauwaz podglad kodu z syntax highlighting
5. Przejdz do `typescript/` — podglad tez ma kolory TypeScript
6. Uzyj `~` zeby przejsc do home directory
7. `q` — wyjdz

### Cwiczenie 3: Otwarcie pliku w Neovim

1. `<leader>E` — otworz Yazi
2. Nawiguj do `exercises/python/calculator.py`
3. Nacisnij `Enter` — plik otworzy sie w buforze Neovim
4. Yazi sie zamknie, jestes z powrotem w edytorze z otwartym plikiem
5. Sprawdz bufferline — nowy buffer pojawil sie na liscie

### Cwiczenie 4: Yazi w CWD

1. Nacisnij `<leader>ew` — Yazi otworzy sie w root projektu
2. Porownaj z `<leader>E` (ktory otwiera w katalogu biezacego pliku)
3. Przydatne, gdy chcesz zobaczyc caly projekt od korzenia

### Cwiczenie 5: Tworzenie plikow

1. Otworz Yazi (`<leader>E`)
2. Nawiguj do `exercises/python/`
3. Nacisnij `a` — wpisz `sandbox_test.py` → `Enter`
4. Plik zostal utworzony
5. Nacisnij `a` ponownie — wpisz `temp_dir/` (ze slashem) → `Enter`
6. Katalog zostal utworzony

### Cwiczenie 6: Kopiowanie i przenoszenie

1. W Yazi nawiguj do `exercises/python/`
2. Staw kursor na `sandbox_test.py`
3. Nacisnij `y` (yank/copy)
4. Nawiguj do `exercises/typescript/` (`h` potem do `typescript/`)
5. Nacisnij `p` (paste) — plik skopiowany!
6. Wroc do `exercises/python/`, staw na `sandbox_test.py`
7. Nacisnij `x` (cut), nawiguj gdzies indziej, `p` — przeniesiony

### Cwiczenie 7: Multi-select i usuwanie

1. W Yazi nawiguj do katalogu z plikami do posprzatania
2. Uzyj `Space` na kilku plikach — zauwaz, ze sa podswietlone
3. Nacisnij `d` — wszystkie zaznaczone pliki zostana usuniete do kosza
4. Alternatywnie: `D` kasuje permanentnie (uwaga!)

### Cwiczenie 8: Podglad roznych typow plikow

1. Otworz Yazi i nawiguj do plikow Python — zauwaz syntax highlighting
2. Nawiguj do plikow TypeScript — inny schemat kolorow
3. Nawiguj do plikow Vue — HTML + JS + CSS w jednym podgladzie
4. Jesli masz jakies obrazy w projekcie — zauwaz podglad w Kitty
5. Przeglad bez otwierania plikow — szybki recon projektu

### Cwiczenie 9: Tmux popup

1. Z dowolnego miejsca (nawet bez Neovim) nacisnij `Cmd+Shift+Y`
2. Yazi otworzy sie w tmux popup (overlay nad wszystkim)
3. Nawiguj, przegladaj pliki
4. `q` — popup sie zamknie, wrócisz do tego co robiles
5. Ten tryb jest niezalezny od Neovim — dziala zawsze w tmux

### Cwiczenie 10: Sortowanie i ukryte pliki

1. Otworz Yazi w katalogu projektu
2. Nacisnij `.` — pokaz ukryte pliki (`.gitignore`, `.git/`, etc.)
3. Nacisnij `.` ponownie — ukryj je
4. Nacisnij `,m` — sortuj po dacie modyfikacji (najnowsze na gorze)
5. Nacisnij `,n` — wroc do sortowania po nazwie
6. Nacisnij `,s` — sortuj po rozmiarze

---

## Cwiczenie bonusowe

**Scenariusz: porzadkowanie projektu po code review**

Dostajesz feedback: "Przeorganizuj pliki w katalogu exercises/".

1. Otworz Yazi (`<leader>E`) i nawiguj do `exercises/`
2. Stworz nowy katalog: `a` → `shared/` (ze slashem)
3. Znajdz pliki `utils.py` i `utils.ts`:
   - Na `utils.py` nacisnij `Space` (zaznacz)
   - Nawiguj do `utils.ts`, nacisnij `Space`
4. Nacisnij `x` (cut) — oba pliki zaznaczone do przeniesienia
5. Nawiguj do `shared/`, nacisnij `p` — pliki przeniesione!
6. Teraz zmien nazwe: staw na pliku, `r`, zmien nazwe
7. Sprawdz preview kazdego pliku bez otwierania — szybki review
8. `q` — wroc do Neovim
9. Na koncu posprzataj — usun to, co utworzyles w cwiczeniach

**Porownaj:** ta sama operacja w Neo-tree wymagalaby wielokrotnego
`m` + `p` na pojedynczych plikach. Yazi z multi-select jest duzo szybszy.

---

## Podsumowanie

| Skrot / Komenda       | Dzialanie                                |
|-----------------------|------------------------------------------|
| `<leader>E`           | Yazi floating (katalog biezacego pliku)  |
| `<leader>ew`          | Yazi floating (CWD projektu)             |
| `Cmd+Shift+Y`         | Yazi w tmux popup                        |
| `h/j/k/l`             | Nawigacja w Yazi                         |
| `a`                   | Nowy plik/katalog                        |
| `r`                   | Zmien nazwe                              |
| `y` / `x` / `p`      | Kopiuj / wytnij / wklej                  |
| `Space`               | Toggle zaznaczenie (multi-select)        |
| `d` / `D`             | Usun do kosza / permanentnie             |
| `.`                   | Toggle hidden files                      |
| `,m` / `,n` / `,s`   | Sortuj: data / nazwa / rozmiar           |
| `q`                   | Wyjdz z Yazi                             |

**Nastepna lekcja:** Folding — zwijanie blokow kodu, zeby skupic sie
na tym, co wazne i ukryc szum.
