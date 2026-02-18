# Lekcja 33: PPM, Command Palette i zaawansowane triki

> Czas: ~30-45 min | Poziom: Advanced

---

## Cel lekcji

Nauczysz sie:

- Korzystac z PPM (right-click popup menu) jako szybkiego dostepu do komend
- Uzywac Command Palette i Smart Open do odkrywania funkcji
- Zarzadzac konfiguracja Neovima z poziomu edytora
- Stosowac zaawansowane triki Vima, ktore przyspieszaja codziennia prace

---

## Teoria

### PPM -- right-click popup menu

PPM to custom menu po prawym kliknieciu myszy. Daje szybki dostep do komend **bez
pamietania skrotow**. Kazda opcja pokazuje keybind w nawiasach kwadratowych.

**Sekcje menu (Normal mode):**

| Sekcja | Opcje | Skrot w `[]` |
|--------|-------|-------------|
| Clipboard | Cut, Copy, Paste, Select All | `[d]`, `[y]`, `[p]`, `[ggVG]` |
| Edit | Comment, Indent Left/Right | `[gcc]`, `[<]`, `[>]` |
| Navigate | Definition, Peek, References, Implementation | `[gd]`, `[gp]`, `[gr]`, `[gri]` |
| Info | Hover, Signature, Diagnostics | `[K]`, `[gK]`, `[<leader>xd]` |
| Refactor | Rename, Code Action, Format | `[<leader>lr]`, `[<leader>la]`, `[<leader>lf]` |
| Search | File, Grep, Symbol, Word | `[<leader>ff]`, `[<leader>fg]`, `[<leader>fs]` |
| Git | Blame, Diff, History, LazyGit | `[<leader>gb]`, `[<leader>gd]` |
| Folds | Fold/Unfold/All | `[za]`, `[zR]`, `[zM]` |
| Panels | IDE Mode, Explorer, Outline, Git Status | `[<leader>i]`, `[<leader>e]` |

**W Visual mode** menu zawiera operacje na zaznaczeniu: Cut, Copy, Paste, Comment,
Indent, Format Selection.

> **Twoja konfiguracja**: PPM jest customowym pluginem zastepujacym domyslne menu.
> Kazda sekcja ma separator wizualny. Menu dziala kontekstowo -- rozne opcje w Normal
> i Visual mode.

### Command Palette i Smart Open

| Klawisz | Dzialanie |
|---------|-----------|
| `Cmd+Shift+P` (Kitty -> `Ctrl+Q`) | Command Palette -- WSZYSTKIE komendy Vim + pluginow |
| `Cmd+P` (Kitty -> `Ctrl+P`) | Smart Open -- pliki + recent + bufory w jednym pickerze |

**Command Palette** dziala jak w VSCode -- wpisujesz fragment nazwy komendy (fuzzy search),
lista sie filtruje, Enter uruchamia. Idealne do odkrywania nowych komend pluginow i
uruchamiania rzadko uzywanych akcji.

**Smart Open** laczy trzy wyszukiwania w jedno:
1. **Otwarte bufory** -- najwyzszy priorytet
2. **Ostatnio otwierane** -- pliki edytowane niedawno
3. **Pliki w projekcie** -- reszta plikow w katalogu roboczym

### Konfiguracja i autocompletion

| Klawisz | Dzialanie |
|---------|-----------|
| `<leader>ve` | Otworz `init.lua` do edycji |
| `<leader>vr` | Przeladuj konfiguracje (bez restartu Neovima) |

**nvim-cmp (autocompletion):**

| Klawisz | Dzialanie |
|---------|-----------|
| `Tab` / `Shift+Tab` | Nastepna / poprzednia sugestia |
| `Enter` | Zatwierdz sugestie |
| `Ctrl+Space` | Wymus otwarcie listy sugestii |
| `Ctrl+e` | Anuluj / zamknij liste |

Zrodla sugestii (w kolejnosci priorytetu): **LSP** (typy, metody) > **LuaSnip** (snippety
z friendly-snippets, `Tab` skacze miedzy placeholder-ami) > **Buffer** (slowa z pliku) >
**Path** (sciezki).

### Pluginy UX -- co dziala automatycznie

Te pluginy dzialaja w tle i nie wymagaja zadnych skrotow:

| Plugin | Co robi |
|--------|---------|
| **Colorizer** | Podswietla kody kolorow (#ff0000, rgb(), hsl()) we wszystkich plikach |
| **Snacks: Dashboard** | Ekran powitalny z ostatnimi plikami |
| **Snacks: Notifier** | Powiadomienia w rogu ekranu (3s timeout) zamiast `:messages` |
| **Snacks: Smooth scroll** | Plynna animacja `Ctrl+d/u` |
| **Snacks: Indent guides** | Pionowe linie wciecia `│` z podswietleniem scope |
| **Snacks: Word highlight** | Podswietla wszystkie wystapienia slowa pod kursorem |
| **Snacks: Bigfile** | Wylacza ciezkie feature'y dla plikow >1MB |
| **Snacks: Image** | Wyswietla obrazki inline (Kitty protocol) |
| **Noice** | Ladniejszy command line, search, messages i LSP progress |
| **Highlight on yank** | 200ms flash po skopiowaniu tekstu (wizualne potwierdzenie) |
| **Remember position** | Auto-skok do ostatniej pozycji kursora po ponownym otwarciu pliku |

### Zaawansowane triki Vima

**Nawigacja i selekcja:**

| Komenda | Opis |
|---------|------|
| `gv` | Ponownie zaznacz ostatnia selekcje Visual |
| `gi` | Wroc do ostatniego miejsca Insert i wejdz w Insert mode |
| `Ctrl+o` (w Insert) | Wykonaj JEDNA komende Normal mode, wroc do Insert |

**Zmiana wielkosci liter:**

| Komenda | Opis |
|---------|------|
| `gU{motion}` | Uppercase -- np. `gUw` zamienia slowo na WIELKIE LITERY |
| `gu{motion}` | Lowercase -- np. `guw` zamienia na male litery |
| `g~{motion}` | Toggle case |
| `gUU` / `guu` | Cala linia na uppercase / lowercase |

**Inkrement / dekrement:**

| Komenda | Opis |
|---------|------|
| `Ctrl+a` / `Ctrl+x` | Zwieksz / zmniejsz liczbe pod kursorem |
| `5 Ctrl+a` | Zwieksz o 5 |
| `g Ctrl+a` | Tworzenie sekwencji w Visual Block (0,0,0 -> 1,2,3) |

**Undo time travel:**

| Komenda | Opis |
|---------|------|
| `:earlier 5m` | Cofnij stan pliku o 5 minut |
| `:later 5m` | Przejdz do przodu o 5 minut |
| `:earlier 3f` | Cofnij o 3 zapisy pliku |

**Marks (zakladki):**

| Komenda | Opis |
|---------|------|
| `m{a-z}` | Ustaw mark lokalny (w biezacym pliku) |
| `` `{a-z} `` | Skocz do dokladnej pozycji marku |
| `m{A-Z}` | Ustaw mark globalny (dziala miedzy plikami!) |
| `` `{A-Z} `` | Skocz do globalnego marku (otworzy plik) |

**Komendy shell:**

| Komenda | Opis |
|---------|------|
| `:!command` | Uruchom komende shell (wynik w okienku) |
| `:.!command` | Zamien biezaca linie na wyjscie komendy |
| `:%!command` | Przepusc caly plik przez komende (np. `:%!jq .` formatuje JSON) |

---

## Cwiczenia

### Cwiczenie 1: PPM -- eksploracja menu

1. Otworz `exercises/python/data_processing.py`
2. Kliknij prawym przyciskiem myszy na nazwie funkcji
3. Przejrzyj menu -- zwroc uwage na skroty w `[nawiasach]`
4. Wybierz "Go to Definition" -- zadziala jak `gd`
5. Wroc: `Ctrl+O`
6. Kliknij prawym na innym symbolu, wybierz "References"

### Cwiczenie 2: PPM w Visual mode

1. Zaznacz kilka linii: `V`, potem `j/k`
2. Kliknij prawym przyciskiem -- inne opcje niz w Normal mode
3. Wybierz "Comment" -- zakomentuje zaznaczone linie
4. Zaznacz ponownie (`gv`) i odkomentuj przez menu

### Cwiczenie 3: Command Palette

1. Nacisnij `Cmd+Shift+P` (lub `Ctrl+Q`)
2. Wpisz `telescope` -- zobaczysz komendy Telescope
3. `Esc`, otwrz ponownie, wpisz `mason` -- komendy Mason
4. Wpisz `lazy` -- komendy Lazy (plugin manager)
5. Cel: Command Palette to "discovery tool" -- wpisz nazwe i zobacz co jest

### Cwiczenie 4: Smart Open

1. Nacisnij `Cmd+P` (lub `Ctrl+P`)
2. Wpisz `calc` -- powinien pojawic sie `calculator.py`, Enter
3. `Cmd+P` ponownie, wpisz `api` -- powinny pojawic sie pliki API
4. Zauwaz kolejnosc: otwarte bufory na gorze, potem recent, potem reszta

### Cwiczenie 5: Inkrement i tworzenie sekwencji

1. Otworz pusty bufor: `:enew`
2. Wpisz `margin: 10px;` (Insert mode, potem `Esc`)
3. Ustaw kursor na `10`, nacisnij `Ctrl+a` -- zmienia sie na `11`
4. `5 Ctrl+a` -- zmienia sie na `16`, `Ctrl+x` -- na `15`
5. Teraz wpisz 5 linii z `item 0` (kazda taka sama)
6. Ustaw kursor na pierwszym `0`, `Ctrl+v` (Visual Block), zaznacz wszystkie `0` w dol
7. `g Ctrl+a` -- zamienia `0` na sekwencje `1, 2, 3, 4, 5`

### Cwiczenie 6: Zmiana wielkosci liter

1. Wpisz: `hello world` w pustym buforze
2. Kursor na `h`, nacisnij `gUw` -- `hello` -> `HELLO`
3. `guw` -- `HELLO` -> `hello`
4. `gUU` -- cala linia uppercase, `guu` -- cala lowercase
5. Zaznacz `hello` (`viw`), nacisnij `g~` -- toggle case
6. Przydatne: `gUi"` -- uppercase wewnatrz cudzyslowu

### Cwiczenie 7: Marks -- lokalne i globalne

1. Otworz `exercises/python/data_processing.py`
2. Przejdz do klasy `Pipeline` i ustaw mark: `ma`
3. Przejdz do `DataLoader` i ustaw mark: `mb`
4. Idz na koniec pliku: `G`
5. `` `a `` -- wracasz na `Pipeline`, `` `b `` -- na `DataLoader`
6. Ustaw mark globalny: `mA` (wielka litera)
7. Otworz `exercises/typescript/api-service.ts`, ustaw mark: `mB`
8. `` `A `` -- wraca do Python, `` `B `` -- wraca do TypeScript

### Cwiczenie 8: Komendy shell i undo time travel

1. Otworz pusty bufor: `:enew`
2. Wpisz kilka linii tekstu
3. Na pustej linii uzyj `:r !date` -- wstawi biezaca date
4. `:.!echo "wstawione z shell"` -- zamieni linie na wyjscie komendy
5. Poczekaj minute, dodaj nowy tekst
6. `:earlier 1m` -- cofnij stan pliku o minute
7. `:later 1m` -- wroc do przodu

---

## Cwiczenie bonusowe

**Speedrun codziennych operacji** (cel: <5 sekund kazda):

1. Otworz plik: `Cmd+P`, `calc`, Enter
2. Skocz do funkcji: `/add`, Enter
3. Skopiuj cala funkcje: `V` + zaznacz + `y`
4. Otworz drugi plik obok: `Ctrl+w v`, `Cmd+P`, `util`, Enter
5. Wklej: `p`
6. Zmien nazwe na uppercase: zaznacz, `gU`
7. Sprawdz git: `Cmd+Shift+D` (LazyGit), przejrzyj, `q`
8. Cofnij: `u` wielokrotnie
9. Zamknij split: `Ctrl+w q`

---

## Podsumowanie

### Nauczone komendy

| Komenda | Opis |
|---------|------|
| Right-click | PPM -- popup menu z kontekstowymi opcjami |
| `Cmd+Shift+P` / `Ctrl+Q` | Command Palette -- szukaj dowolnej komendy |
| `Cmd+P` / `Ctrl+P` | Smart Open -- pliki + recent + bufory |
| `<leader>ve` / `<leader>vr` | Edytuj / przeladuj konfiguracje |
| `gv` | Ponownie zaznacz ostatnia selekcje Visual |
| `gi` | Wroc do ostatniego Insert |
| `Ctrl+a` / `Ctrl+x` | Inkrement / dekrement liczby |
| `g Ctrl+a` | Tworzenie sekwencji (Visual Block) |
| `gU{motion}` / `gu{motion}` | Uppercase / lowercase |
| `:earlier Xm` / `:later Xm` | Undo time travel |
| `m{a-z}` / `` `{a-z} `` | Lokalne marks |
| `m{A-Z}` / `` `{A-Z} `` | Globalne marks (miedzy plikami) |
| `:.!command` | Zamien linie na wyjscie komendy shell |
| `Ctrl+o` (w Insert) | Jedna komenda Normal, potem z powrotem Insert |

### Konfiguracja uzyta w tej lekcji

| Element | Wartosc / Opis |
|---------|---------------|
| PPM | Custom right-click menu, kontekstowe (Normal / Visual) |
| Command Palette | `Ctrl+Q` -> Telescope commands |
| Smart Open | `Ctrl+P` -> Snacks.picker.smart() |
| nvim-cmp | Tab/S-Tab, CR, C-Space, C-e. Zrodla: LSP > LuaSnip > Buffer > Path |
| Snacks.nvim | Dashboard, notifier, scroll, indent guides, word highlight, bigfile |
| Noice.nvim | Ladny command line, search, messages |

---

## Podsumowanie modulu 6

Modul 6 (lekcje 30-33) pokryl **pelne srodowisko pracy**:

| Lekcja | Temat | Kluczowe skroty |
|--------|-------|----------------|
| 30 | IDE mode i panele | `<leader>i`, `<leader>o`, `<leader>gs`, `<Space>` which-key |
| 31 | Spectre i Todo | `<leader>S`, `<leader>ft`, `]t`/`[t`, `<leader>ta/tx` |
| 32 | Terminal i tmux | `Ctrl+\`, `Cmd+Shift+D/Y/T`, `prefix+[`, `prefix+z` |
| 33 | Triki i UX | PPM, `Cmd+P`, `Cmd+Shift+P`, `gv`, `gi`, `Ctrl+a`, marks |

---

## Podsumowanie calego kursu

Przeszedlesz caly kurs Vim Tutor dostosowany do Twojego setupu.

| Modul | Lekcje | Czego nauczyles sie |
|-------|--------|---------------------|
| 1. Fundamenty | 01-05 | Tryby, ruchy, operatory, text objects, visual mode |
| 2. Edycja | 06-10 | Rejestry, makra, search/replace, surround, dot command |
| 3. Nawigacja | 11-15 | Telescope, marks, jumps, folds, bufory |
| 4. Windows | 16-20 | Splits, tmux, tabs, sessions, nawigacja miedzy oknami |
| 5. IDE | 21-29 | LSP, diagnostyka, completion, git, formatowanie, debugging |
| 6. Zaawansowane | 30-33 | IDE mode, Spectre, terminal, popups, triki |

**Nastepne kroki:**

1. **Cwiicz codziennie** -- ponownie przejdz cwiczenia z najtrudniejszych lekcji
2. **Dostosowuj config** -- `<leader>ve` to Twoj najlepszy przyjaciel
3. **Czytaj `:help`** -- Neovim ma swietna dokumentacje (`:help usr_01.txt` na start)
4. **Eksploruj pluginy** -- Command Palette (`Cmd+Shift+P`) pokaze co juz masz
5. **Czytaj kody zrodlowe** -- `gd` na funkcji pluginu przeniesie Cie do jego kodu
6. **Uzyj which-key** -- nacisnij `<Space>` i czekaj, zeby odkrywac nowe skroty

Mistrzem Vima nie staje sie po jednym kursie. To **ciagle doskonalenie** -- co tydzien
odkrywasz nowy trik, ktory oszczedza kilka sekund. Po roku te sekundy skladaja sie
w godziny.
