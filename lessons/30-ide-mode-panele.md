# Lekcja 30: IDE mode i panele -- pelne srodowisko pracy

> Czas: ~30-45 min | Poziom: Advanced

---

## Cel lekcji

Nauczysz sie:

- Wlaczac i wylaczac IDE mode jednym skrotem (`<leader>i`)
- Rozumiec system wymiennych paneli (prawy slot: aerial vs git status)
- Korzystac z Which-key do odkrywania WSZYSTKICH dostepnych keybindow
- Budowac efektywne layouty do roznych zadan (code review, development, git workflow)
- Laczyc panele z nawigacja okien w spojny workflow

---

## Teoria

### IDE mode -- jeden skrot, pelne srodowisko

Tradycyjne IDE (VSCode, IntelliJ) startuja z domyslnym layoutem: eksplorator plikow po lewej,
outline po prawej, edytor w srodku. W Neovimie budujesz to srodowisko sam -- ale dzieki
`<leader>i` mozesz je wlaczyc i wylaczyc jednym ruchem.

| Klawisz | Dzialanie |
|---------|-----------|
| `<leader>i` | Toggle IDE mode -- otwiera/zamyka neo-tree + aerial jednoczesnie |

**Jak to dziala**:

```
  Przed <leader>i:               Po <leader>i:
  +--------------------------+   +------+---------------+------+
  |                          |   |      |               |      |
  |        edytor            |   | neo  |    edytor     | aeri |
  |                          |   | tree |               | al   |
  |                          |   |      |               |      |
  +--------------------------+   +------+---------------+------+
```

Mechanika:
1. Jesli oba panele sa zamkniete -> otwiera neo-tree (lewy panel), po 100ms otwiera aerial
   (prawy panel), potem ustawia focus na edytorze
2. Jesli oba panele sa otwarte -> zamyka oba jednoczesnie
3. Focus wraca do okna edytora -- nigdy nie zostajesz "uwieziony" w panelu bocznym

> **Twoja konfiguracja**: IDE mode uzywa 100ms delay miedzy otwarciem neo-tree a aerial.
> To zapobiega race condition -- oba pluginy potrzebuja chwili na inicjalizacje.

### Neo-tree -- eksplorator plikow

Neo-tree to panel plikow po lewej stronie. Mozesz go tez otworzyc samodzielnie:

| Klawisz | Dzialanie |
|---------|-----------|
| `<leader>e` | Toggle neo-tree (sam eksplorator, bez aerial) |

W neo-tree masz pelna kontrole nad plikami:

| Klawisz (w neo-tree) | Dzialanie |
|-----------------------|-----------|
| `Enter` | Otworz plik / rozwin katalog |
| `a` | Dodaj nowy plik / katalog |
| `d` | Usun plik |
| `r` | Zmien nazwe |
| `c` | Kopiuj plik |
| `m` | Przenies plik |
| `y` | Kopiuj nazwe pliku |
| `Y` | Kopiuj wzgledna sciezke |
| `.` | Pokaz ukryte pliki |
| `/` | Filtruj (szukaj w drzewie) |
| `?` | Pokaz pomoc (wszystkie keybindy) |

### Aerial -- outline kodu

Aerial to panel po prawej stronie pokazujacy **strukture biezacego pliku** -- klasy, funkcje,
metody, zmienne. Dziala jak "spis tresci" dla kodu.

| Klawisz | Dzialanie |
|---------|-----------|
| `<leader>o` | Toggle aerial (outline) |

W aerial:

| Klawisz (w aerial) | Dzialanie |
|---------------------|-----------|
| `Enter` | Skocz do symbolu |
| `{` / `}` | Poprzedni / nastepny symbol |
| `l` / `h` | Rozwin / zwin galaz |
| `L` / `H` | Rozwin / zwin wszystkie |
| `q` | Zamknij aerial |

Aerial automatycznie podswietla symbol, w ktorym aktualnie znajduje sie kursor -- przewija
sie razem z Toba w pliku. To daje poglad "gdzie jestem w strukturze kodu".

> **Twoja konfiguracja**: Aerial wyswietla ikony z Nerd Fonts dla roznych typow symboli
> (klasa, funkcja, zmienna, interfejs itd.). Kolory sa dopasowane do Catppuccin Mocha.

### System wymiennych paneli -- prawy slot

To jeden z kluczowych elementow Twojego setupu. Prawy panel jest **wspoldzielony** miedzy
aerial a git status. Nie mozesz miec obu jednoczesnie -- jeden zastepuje drugi:

| Klawisz | Otwiera | Zamyka (jesli otwarty) |
|---------|---------|------------------------|
| `<leader>o` | Aerial (outline) | Git status |
| `<leader>gs` | Git status | Aerial |

**Logika**:
- Naciskasz `<leader>o` -> jesli git status jest otwarty w prawym panelu, zamyka go i otwiera
  aerial w tym samym miejscu
- Naciskasz `<leader>gs` -> jesli aerial jest otwarty, zamyka go i otwiera git status
- To zapobiega "puchnięciu" interfejsu -- zawsze masz maksymalnie 3 kolumny

```
  Layout z aerial:                Layout z git status:
  +------+---------------+------+ +------+---------------+------+
  |      |               |      | |      |               |      |
  | neo  |    edytor     | aeri | | neo  |    edytor     | git  |
  | tree |               | al   | | tree |               | stat |
  |      |               |      | |      |               |      |
  +------+---------------+------+ +------+---------------+------+
```

### Which-key -- odkrywanie keybindow

Which-key to plugin, ktory rozwiazuje fundamentalny problem: "jakie skroty sa dostepne?".
Nacisnij `<Space>` (leader) i **poczekaj ~300ms** -- pojawi sie popup z WSZYSTKIMI
dostepnymi keybindami pogrupowanymi w kategorie.

| Kategoria | Prefix | Przyklady |
|-----------|--------|-----------|
| Buffers | `<leader>b` | `bd` delete, `bp` prev, `bn` next |
| Code/Comments | `<leader>c` | `cc` toggle comment |
| Dropbar | `<leader>d` | breadcrumbs navigation |
| Explorer | `<leader>e` | toggle neo-tree |
| Find (Telescope) | `<leader>f` | `ff` files, `fg` grep, `fb` buffers |
| Git | `<leader>g` | `gs` status, `gb` blame, `gd` diff |
| LSP | `<leader>l` | `lr` rename, `la` code action |
| Markdown | `<leader>m` | preview, render |
| Outline | `<leader>o` | toggle aerial |
| Rename | `<leader>r` | refactoring |
| Search/Spectre | `<leader>s` | `S` Spectre, `sw` search word |
| Todo | `<leader>t` | `ta` add, `td` done, `ft` find todos |
| Vim config | `<leader>v` | `ve` edit, `vr` reload |
| Save | `<leader>w` | quick save |
| Trouble | `<leader>x` | diagnostics panel |

> **Twoja konfiguracja**: Which-key jest zainstalowany z domyslna konfiguracja i automatycznie
> wykrywa wszystkie keymapy. Nie musisz go konfigurowac -- po prostu nacisnij Space i czekaj.

**Tip**: Mozesz tez naciskac Space a potem litere kategorii (np. `<leader>f`) i czekac --
which-key pokaze wszystkie keybindy **w tej kategorii**. Idealne do eksploracji.

### Layouty do roznych zadan

IDE mode to punkt wyjscia, ale mozesz dostosowac layout do konkretnego zadania:

| Zadanie | Layout | Jak uzyskac |
|---------|--------|-------------|
| Development | neo-tree + edytor + aerial | `<leader>i` |
| Code review | neo-tree + edytor + diffview | `<leader>i`, potem `<leader>gs` zamiast aerial |
| Git workflow | neo-tree + edytor + git status | `<leader>e` + `<leader>gs` |
| Debugging | edytor + trouble (bottom) | `<leader>xx` lub `<leader>xd` |
| Czysty edytor | sam edytor | zamknij wszystko lub nie wlaczaj IDE mode |
| Eksploracja kodu | neo-tree + edytor + aerial | `<leader>i`, klikaj symbole w aerial |

### Nawigacja miedzy oknami -- przypomnienie

Kiedy masz otwarty layout z panelami, nawigacja jest kluczowa:

| Klawisz | Dzialanie |
|---------|-----------|
| `Ctrl+h` | Przejdz do okna po lewej |
| `Ctrl+j` | Przejdz do okna na dole |
| `Ctrl+k` | Przejdz do okna na gorze |
| `Ctrl+l` | Przejdz do okna po prawej |

Nawigacja dziala plynnie miedzy neo-tree, edytorem, aerial i tmux panes (dzieki
vim-tmux-navigator). Nie musisz wiedziec "w jakim oknie jestem" -- po prostu nawigujesz
w kierunku, w ktorym chcesz byc.

---

## Cwiczenia

### Cwiczenie 1: Wlacz i wylacz IDE mode

1. Upewnij sie, ze masz otwarty jakis plik, np. `exercises/python/data_processing.py`
2. Nacisnij `<leader>i` (Space, potem i)
3. Obserwuj: po lewej pojawia sie neo-tree, po prawej aerial z struktura pliku
4. Sprawdz, ze kursor jest w oknie edytora (nie w panelu bocznym)
5. Nacisnij `<leader>i` ponownie -- oba panele sie zamykaja
6. Powtorz 2-3 razy, zeby zapamietac skrot

### Cwiczenie 2: Nawigacja miedzy panelami

1. Wlacz IDE mode (`<leader>i`)
2. `Ctrl+h` -- przejdz do neo-tree (eksplorator plikow)
3. Nawiguj po drzewie plikow klawiszami `j`/`k`
4. `Ctrl+l` -- wroc do edytora
5. `Ctrl+l` -- przejdz do aerial (outline)
6. Nawiguj po symbolach w aerial (`j`/`k`)
7. Nacisnij `Enter` na jakims symbolu -- kursor przeniesie sie do niego w edytorze
8. `Ctrl+h` -- wroc do edytora

### Cwiczenie 3: Wymiana panelu prawego

1. Wlacz IDE mode (`<leader>i`) -- masz neo-tree + aerial
2. Nacisnij `<leader>gs` -- aerial zamyka sie, otwiera sie git status
3. Przejrzyj zmiany w git status (`Ctrl+l`, potem `j`/`k`)
4. Nacisnij `<leader>o` -- git status zamyka sie, wraca aerial
5. Powtorz kilka razy -- `<leader>gs`, `<leader>o`, `<leader>gs`
6. Zauwaz: lewy panel (neo-tree) nie zmienia sie -- wymiana dotyczy tylko prawego slotu

### Cwiczenie 4: Eksploracja kodu z aerial

1. Otworz `exercises/python/data_processing.py`
2. Wlacz aerial: `<leader>o`
3. Przejdz do aerial: `Ctrl+l`
4. Znajdz klase `Pipeline` w liscie symboli (j/k do nawigacji)
5. Rozwin ja klawiszem `l` -- zobaczysz jej metody
6. Nacisnij `Enter` na metodzie `process` -- kursor w edytorze skoczy do tej metody
7. Obserwuj, ze aerial podswietla biezacy symbol, gdy poruszasz sie po pliku
8. Zamknij aerial: `<leader>o`

### Cwiczenie 5: Which-key -- odkrywanie skrotow

1. Nacisnij `<Space>` i **czekaj** (~300ms) -- pojawi sie popup which-key
2. Przeczytaj dostepne kategorie (b, c, d, e, f, g, l, m, o, s, t, v, w, x)
3. Nacisnij `Esc` zeby zamknac
4. Nacisnij `<Space>f` i czekaj -- zobaczysz wszystkie skroty "Find" (Telescope)
5. Nacisnij `Esc`
6. Nacisnij `<Space>g` i czekaj -- zobaczysz wszystkie skroty "Git"
7. Nacisnij `Esc`
8. Poeksperymentuj z innymi kategoriami: `<Space>l` (LSP), `<Space>t` (Todo)

### Cwiczenie 6: Which-key -- znajdz nieznany keybind

1. Nacisnij `<Space>` i czekaj na popup
2. Znajdz kategorie `x` -- to Trouble (diagnostyka)
3. Nacisnij `x` -- zobaczysz podmenu z opcjami trouble
4. Przeczytaj opcje ale nacisnij `Esc` (na razie nie uruchamiaj)
5. Powtorz z kategoria `c` -- znajdz skrot do komentowania
6. Cel: zapamietaj, ze which-key to Twoj "cheat sheet" wbudowany w edytor

### Cwiczenie 7: Layout do code review

1. Wlacz IDE mode: `<leader>i`
2. W neo-tree (`Ctrl+h`) znajdz plik `exercises/typescript/api-service.ts` i otworz go (Enter)
3. Zamien aerial na git status: `<leader>gs`
4. Masz teraz: neo-tree (pliki) + edytor (kod) + git status (zmiany)
5. Przegladnij git status -- jesli sa jakies zmiany, wybierz plik
6. Wroc do layoutu development: `<leader>o` (zamieni git status na aerial)

### Cwiczenie 8: Samodzielne panele

1. Zamknij wszystko: `<leader>i` (jesli IDE mode jest wlaczony)
2. Otworz sam neo-tree: `<leader>e`
3. Uzyj neo-tree do nawigacji, otworz kilka plikow
4. Zamknij neo-tree: `<leader>e`
5. Otworz sam aerial: `<leader>o`
6. Przejrzyj strukture biezacego pliku
7. Zamknij aerial: `<leader>o`
8. Wniosek: `<leader>i` to combo, ale kazdy panel mozesz kontrolowac osobno

---

## Cwiczenie bonusowe

**Zbuduj swoj idealny workflow od zera:**

1. Otworz `exercises/python/data_processing.py` w czystym edytorze (bez paneli)
2. Chcesz zrozumiec strukture pliku -- wlacz aerial (`<leader>o`)
3. Przejdz do aerial, znajdz klase `BaseTransformer`, skocz do niej (Enter)
4. Chcesz zobaczyc jakie pliki sa w projekcie -- dodaj neo-tree (`<leader>e`)
5. Nawiguj w neo-tree, otworz `exercises/python/models.py`
6. Chcesz sprawdzic git status -- zamien aerial na git: `<leader>gs`
7. Przegladnij status, wroc do aerial: `<leader>o`
8. Koniec pracy -- zamknij wszystko: `<leader>i` (lub `<leader>e` + `<leader>o` osobno)
9. Cel: naucz sie budowac layout "na biezaco" w zaleznosci od potrzeby

---

## Podsumowanie

| Skrot | Dzialanie |
|-------|-----------|
| `<leader>i` | Toggle IDE mode (neo-tree + aerial + focus edytor) |
| `<leader>e` | Toggle neo-tree (eksplorator plikow) |
| `<leader>o` | Toggle aerial / zamyka git status jesli otwarty |
| `<leader>gs` | Toggle git status / zamyka aerial jesli otwarty |
| `<Space>` + czekaj | Which-key -- pokaz WSZYSTKIE dostepne keybindy |
| `Ctrl+h/j/k/l` | Nawigacja miedzy oknami (panele + edytor + tmux) |

### Konfiguracja uzyta w tej lekcji

| Element | Wartosc / Opis |
|---------|---------------|
| IDE mode | `<leader>i` -- combo neo-tree + aerial z 100ms delay |
| Prawy slot | Wspoldzielony miedzy aerial i git status |
| Which-key | Domyslna konfiguracja, auto-discovers keymapy |
| vim-tmux-navigator | Bezszwowa nawigacja Ctrl+h/j/k/l |

### Co dalej?

W **lekcji 31** poznasz **Spectre** (project-wide search & replace z podgladem) i **todo-comments**
-- system zarzadzania zadaniami bezposrednio w kodzie i plikach notatek.
