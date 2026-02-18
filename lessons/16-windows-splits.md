# Lekcja 16: Windows, splits i tmux

> Czas: ~30-45 min | Poziom: Intermediate

---

## Cel lekcji

Nauczysz sie:

- Tworzyc i zarzadzac splitami w Neovim
- Tworzyc panele i okna w tmux
- Plynnie nawigowac miedzy Neovim windows a tmux panes (`Ctrl+h/j/k/l`)
- Zmieniac rozmiar paneli w tmux
- Tworzyc efektywne layouty do pracy z kodem

---

## Teoria

### Neovim Windows (splits)

Window w Neovim to **viewport** — prostokat, w ktorym wyswietlany jest buffer.
Mozesz miec wiele windows pokazujacych rozne (lub ten sam!) buffer jednoczesnie.

| Komenda / Skrot  | Dzialanie                                      |
|------------------|-------------------------------------------------|
| `:vsplit` / `Ctrl+w v` | Split pionowy (nowe okno po prawej)      |
| `:split` / `Ctrl+w s`  | Split poziomy (nowe okno na dole)        |
| `Ctrl+w q`       | Zamknij biezace okno                           |
| `Ctrl+w o`       | Zamknij WSZYSTKIE okna oprocz biezacego        |
| `Ctrl+w =`       | Wyrownaj rozmiar wszystkich okien              |
| `Ctrl+w _`       | Maksymalizuj wysokosc biezacego okna           |
| `Ctrl+w \|`      | Maksymalizuj szerokosc biezacego okna          |
| `Ctrl+w r`       | Rotuj okna (zamien miejscami)                  |
| `Ctrl+w T`       | Przenies biezace okno do nowego taba           |
| `Ctrl+w x`       | Zamien biezace okno z nastepnym                |

### Twoja konfiguracja — split behavior

> W Twojej konfiguracji ustawione jest:
>
> ```lua
> vim.opt.splitbelow = true   -- nowy split poziomy otwiera sie NA DOLE
> vim.opt.splitright = true   -- nowy split pionowy otwiera sie PO PRAWEJ
> ```
>
> To bardziej naturalne zachowanie niz domyslne Vimowe (gora/lewo).

### Tmux — panele i okna

Tmux operuje na trzech poziomach:

| Poziom       | Co to jest                         | Odpowiednik              |
|-------------|-------------------------------------|--------------------------|
| **Session** | Grupa okien, trwa po odlaczeniu    | Projekt / workspace      |
| **Window**  | Pelnoekranowa zakladka w sesji     | Tab w przegladarce       |
| **Pane**    | Podzial okna na czesci             | Split w edytorze         |

```
+----------------------------------------------------------+
| Session: "projekt-api"                                    |
|                                                          |
| Window 1: "edytor"          Window 2: "serwer"           |
| +-------------+-----------+ +---------------------------+ |
| | Pane 1      | Pane 2    | | Pane 1                    | |
| | (nvim)      | (nvim)    | | (npm run dev)             | |
| |             |           | |                           | |
| +-------------+-----------+ +-------------+-------------+ |
| | Pane 3                  | | Pane 2      | Pane 3      | |
| | (terminal)              | | (logs)      | (tests)     | |
| +-------------------------+ +-------------+-------------+ |
+----------------------------------------------------------+
```

### Twoja konfiguracja — tmux

> **Prefix:** `Ctrl+Space`
>
> | Skrot                  | Dzialanie                                |
> |------------------------|------------------------------------------|
> | `prefix + \|`          | Split poziomy (nowy pane po prawej)      |
> | `prefix + -`           | Split pionowy (nowy pane na dole)        |
> | `prefix + c`           | Nowe okno (window)                       |
> | `prefix + $`           | Zmien nazwe sesji                        |
> | `prefix + ,`           | Zmien nazwe okna                         |
> | `prefix + z`           | Zoom — fullscreen biezacego pane'a       |
> | `prefix + x`           | Zamknij biezacy pane                     |

### Nawigacja — bezszwowe przechodzenie

To jedna z najwazniejszych cech Twojego setupu. Dzieki **vim-tmux-navigator**:

> **`Ctrl+h/j/k/l` dziala IDENTYCZNIE w Neovim i tmux!**
>
> Nie musisz wiedziec, czy jestes w oknie Neovim czy panelu tmux —
> po prostu naciskasz `Ctrl+h` zeby przejsc w lewo, `Ctrl+l` w prawo itd.

| Skrot      | Kierunek  |
|-----------|-----------|
| `Ctrl+h`  | Lewo      |
| `Ctrl+j`  | Dol       |
| `Ctrl+k`  | Gora      |
| `Ctrl+l`  | Prawo     |

Dodatkowe metody nawigacji tmux:

| Skrot                              | Dzialanie                          |
|------------------------------------|------------------------------------|
| `Alt+strzalki`                     | Nawigacja miedzy panes             |
| `Alt+Shift+Left/Right`            | Poprzednie/nastepne okno tmux      |
| `Alt+1` do `Alt+9`                | Bezposrednio do okna nr N          |
| `Alt+n` / `Alt+p`                 | Nastepne / poprzednie okno         |

### Resize — zmiana rozmiaru paneli

> **Tmux resize (powtarzalne — trzymaj klawisz):**
>
> | Skrot           | Dzialanie                              |
> |----------------|----------------------------------------|
> | `prefix + H`   | Zmniejsz szerokosc o 5 kolumn (lewo)  |
> | `prefix + J`   | Zwieksz wysokosc o 5 wierszy (dol)    |
> | `prefix + K`   | Zmniejsz wysokosc o 5 wierszy (gora)  |
> | `prefix + L`   | Zwieksz szerokosc o 5 kolumn (prawo)  |

Te skroty sa **repeatable** — po nacisnieciu `prefix` mozesz trzymac `H/J/K/L`
bez ponownego wciskania prefixu.

### Zoom — fullscreen pane

`prefix + z` **toggle zoom** — powieksza biezacy pane do pelnego okna tmux.
Nacisnij ponownie, zeby wrocic do layoutu. Idealny, gdy potrzebujesz na chwile
pelnego ekranu, np. do przegladania dlugiego pliku.

Na pasku tmux pojawi sie `Z` przy nazwie okna, gdy zoom jest aktywny.

### Neovim resize

W samym Neovim rowniez mozesz zmieniac rozmiar okien:

| Komenda        | Dzialanie                               |
|----------------|-----------------------------------------|
| `Ctrl+w >`     | Poszerz okno o 1 kolumne               |
| `Ctrl+w <`     | Zwez okno o 1 kolumne                  |
| `Ctrl+w +`     | Zwieksz wysokosc o 1 wiersz            |
| `Ctrl+w -`     | Zmniejsz wysokosc o 1 wiersz           |
| `10 Ctrl+w >`  | Poszerz o 10 kolumn                    |
| `Ctrl+w =`     | Wyrownaj wszystkie okna                |

W praktyce czesciej uzywasz tmux resize (`prefix+H/J/K/L`) bo jest wygodniejszy.

---

## Cwiczenia

### Cwiczenie 1: Pierwszy split w Neovim

1. Otworz plik `exercises/python/calculator.py`
2. Nacisnij `Ctrl+w v` — powstanie split pionowy (ten sam plik w obu oknach)
3. W nowym oknie otworz inny plik: `:e exercises/python/utils.py`
4. Nawiguj miedzy oknami: `Ctrl+h` (lewo) i `Ctrl+l` (prawo)
5. Zamknij prawe okno: `Ctrl+w q` (bedzac w nim)

### Cwiczenie 2: Split poziomy

1. Otworz dowolny plik
2. Nacisnij `Ctrl+w s` — split poziomy (nowy na dole, bo `splitbelow=true`)
3. W dolnym oknie otworz `:e exercises/typescript/interfaces.ts`
4. Nawiguj: `Ctrl+k` (gora) i `Ctrl+j` (dol)
5. Uzyj `Ctrl+w =` zeby wyrownac okna
6. Uzyj `Ctrl+w _` bedzac w gornym oknie — zajmie cala wysokosc

### Cwiczenie 3: Layout z 3 oknami

1. Otworz `calculator.py`
2. `Ctrl+w v` — split pionowy
3. Przejdz do prawego okna (`Ctrl+l`) i nacisnij `Ctrl+w s` — split poziomy
4. Masz teraz layout: 1 duze okno po lewej, 2 male po prawej
5. W kazdym oknie otworz inny plik (`:e ...`)
6. Przetrenuj nawigacje `Ctrl+h/j/k/l` miedzy wszystkimi trzema oknami

### Cwiczenie 4: Tmux split

1. Wyjdz z Neovim lub uzyj tmux z poziomu panelu obok
2. `Ctrl+Space` potem `|` — nowy pane po prawej
3. `Ctrl+Space` potem `-` — nowy pane na dole (w aktywnym pane)
4. Nawiguj miedzy panes: `Ctrl+h/j/k/l`
5. W jednym pane uruchom `nvim`, w drugim zostaw terminal
6. Sprawdz, ze `Ctrl+h/j/k/l` plynnie przenosi Cie z nvim do terminala!

### Cwiczenie 5: Resize paneli tmux

1. Majac layout z cwiczenia 4 (min. 2 panes):
2. `prefix + L` — poszerz aktywny pane w prawo (trzymaj L kilka razy)
3. `prefix + H` — zwez z powrotem
4. `prefix + J` / `prefix + K` — zmien wysokosc
5. Poeksperymentuj z proporcjami

### Cwiczenie 6: Zoom

1. Majac kilka panes w tmux:
2. Nacisnij `prefix + z` — biezacy pane zajmie caly ekran
3. Zauwaz `Z` na pasku tmux przy nazwie okna
4. Nacisnij `prefix + z` ponownie — powrot do layoutu
5. Przydatne, gdy potrzebujesz szybko zobaczyc cos na pelnym ekranie

### Cwiczenie 7: Tmux windows

1. `prefix + c` — nowe okno tmux (jak nowa zakladka)
2. `prefix + ,` — zmien nazwe okna na "edytor"
3. `Alt+1` — wroc do okna 1
4. `Alt+2` — przejdz do okna 2
5. `Alt+n` / `Alt+p` — nastepne / poprzednie okno

### Cwiczenie 8: Polaczony workflow

1. Stworz tmux layout: Neovim po lewej (70%), terminal po prawej (30%)
2. W Neovim otworz 2 pliki w splitach (`Ctrl+w v`)
3. Masz teraz 3 panele: 2 nvim windows + 1 tmux pane
4. Nawiguj miedzy WSZYSTKIMI uzywajac `Ctrl+h/j/k/l`
5. Uzyj `prefix + z` w panelu terminala, uruchom komende, `prefix + z` z powrotem

---

## Cwiczenie bonusowe

**Stworz idealny workspace do pracy nad API:**

1. Tmux: stworz 2 okna — "code" i "server"
2. W oknie "code":
   - Lewy pane: Neovim z 2 splitami (model + controller)
   - Prawy pane: terminal na testy
3. W oknie "server":
   - Gorny pane: serwer dev
   - Dolny pane: logi
4. Przetrenuj:
   - Nawigacja `Ctrl+h/j/k/l` miedzy nvim splits a tmux panes
   - Przelaczanie okien tmux: `Alt+1` / `Alt+2`
   - Zoom pane z logami: `prefix + z`
   - Resize pane z testami: `prefix + H/L`
5. Zapamietaj ten layout — w przyszlosci mozesz go zapisac w tmuxinator

---

## Podsumowanie

| Skrot / Komenda          | Dzialanie                                |
|--------------------------|------------------------------------------|
| `Ctrl+w v` / `Ctrl+w s` | Split pionowy / poziomy (Neovim)         |
| `prefix + \|` / `prefix + -` | Split poziomy / pionowy (tmux)      |
| `Ctrl+h/j/k/l`          | Nawigacja bezszwowa (nvim + tmux)        |
| `prefix + H/J/K/L`      | Resize paneli tmux (5 cells, repeatable) |
| `prefix + z`             | Zoom toggle (fullscreen pane)            |
| `prefix + c`             | Nowe okno tmux                           |
| `Alt+1-9`                | Bezposrednio do okna tmux N              |
| `Ctrl+w =`               | Wyrownaj okna Neovim                     |
| `Ctrl+w q`               | Zamknij okno Neovim                      |

**Nastepna lekcja:** Telescope — potezny fuzzy finder, ktory pozwala znalezc
pliki, tekst, keymaps, symbole i diagnostyki w kilka sekund.
