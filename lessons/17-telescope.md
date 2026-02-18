# Lekcja 17: Telescope — fuzzy finder

> Czas: ~30-45 min | Poziom: Intermediate

---

## Cel lekcji

Nauczysz sie:

- Uzywac wszystkich pickerow Telescope w codziennej pracy
- Efektywnie wyszukiwac pliki, tekst, keymaps i symbole
- Nawigowac wewnatrz okna Telescope
- Laczyc Telescope z innymi narzedziami (LSP, Aerial, diagnostics)
- Wznawiać ostatnie wyszukiwanie

---

## Teoria

### Czym jest Telescope

Telescope to **fuzzy finder** — narzedzie do przeszukiwania praktycznie
wszystkiego w projekcie. Wpisujesz fragment tekstu, a Telescope filtruje
wyniki w czasie rzeczywistym, pokazujac podglad (preview) wybranego elementu.

```
+---------------------------------------------+---------------------------+
| > calc                                      |                           |
|                                             |  def add(a, b):           |
| exercises/python/calculator.py         [1]  |      """Add two nums"""   |
| exercises/python/utils.py              [2]  |      return a + b         |
| docs/calculations.md                   [3]  |                           |
|                                             |  def subtract(a, b):      |
|   (wpisz tekst aby filtrowac)               |      return a - b         |
+---------------------------------------------+---------------------------+
  ^ Prompt (fuzzy input)                        ^ Preview (podglad pliku)
```

Telescope uzywa **fzf-native** jako backend do fuzzy matching — jest szybki
nawet w duzych projektach.

### Twoja konfiguracja — wszystkie pickery

> **Glowne pickery:**
>
> | Skrot          | Picker              | Co robi                                    |
> |----------------|---------------------|--------------------------------------------|
> | `<leader>ff`   | Find Files          | Szuka plikow po nazwie (.gitignore aware)  |
> | `<leader>fg`   | Live Grep           | Szuka TRESCI w plikach (ripgrep)           |
> | `<leader>fb`   | Buffers             | Lista otwartych bufferow z preview         |
> | `<leader>fh`   | Help Tags           | Przeszukuje dokumentacje Vim/pluginow      |
> | `<leader>fr`   | Recent Files        | Ostatnio otwierane pliki (oldfiles)        |
> | `<leader>fk`   | Keymaps             | WSZYSTKIE zmapowane skroty klawiszowe      |
> | `<leader>fs`   | Symbols (Aerial)    | Funkcje, klasy, metody w biezacym pliku    |
>
> **Wyszukiwanie zaawansowane:**
>
> | Skrot          | Picker              | Co robi                                    |
> |----------------|---------------------|--------------------------------------------|
> | `<leader>sr`   | Search Resume       | Wznawia ostatnie wyszukiwanie Telescope    |
> | `<leader>sw`   | Search Word         | Grep slowa pod kursorem                   |
> | `<leader>sd`   | Search Diagnostics  | Wszystkie bledy/warningi LSP               |
> | `<leader>/`    | Fuzzy Buffer        | Fuzzy search w biezacym pliku (dropdown)   |

### Find Files (`<leader>ff`)

Przeszukuje pliki w projekcie po nazwie. Kluczowe cechy:

- Respektuje `.gitignore` — nie pokaze `node_modules`, `__pycache__`, `.git`
- Uzywa `fd` (szybsza alternatywa dla `find`)
- Fuzzy matching: wpisz `calcpy` — znajdzie `calculator.py`
- Sortuje po trafnosci

**Kiedy uzywac:** Gdy znasz (czesciowa) nazwe pliku, ale nie pamietasz sciezki.

### Live Grep (`<leader>fg`)

Przeszukuje **zawartosc** wszystkich plikow w projekcie. Uzywa `ripgrep` (rg).

- Szuka w czasie rzeczywistym — wyniki pojawiaja sie podczas pisania
- Pokazuje plik + linie z dopasowaniem
- Tez respektuje `.gitignore`

**Kiedy uzywac:** Gdy szukasz konkretnego kodu — nazwy funkcji, stringa,
wzorca. Np. "gdzie jest zdefiniowane `UserService`?"

### Buffers (`<leader>fb`)

Lista otwartych bufferow z podgladem. Szybsze niz `:ls` bo widzisz
zawartosc kazdego buffera.

**Kiedy uzywac:** Gdy masz otwartych 5+ plikow i chcesz szybko przeskoczyc
do konkretnego. Alternatywa dla `Shift+H/L` gdy bufferow jest duzo.

### Help Tags (`<leader>fh`)

Przeszukuje cala dokumentacje Vim i zainstalowanych pluginow.

**Kiedy uzywac:** Zamiast `:help cos` — szybciej i z podgladem.
Np. `<leader>fh` → wpisz `telescope` → czytasz dokumentacje.

### Recent Files (`<leader>fr`)

Pliki, ktore ostatnio otwieralies (Vim `oldfiles`). Przydatne, gdy
zamknales plik i chcesz go szybko otworzyc ponownie.

### Keymaps (`<leader>fk`)

**Jeden z najuzyteczniejszych pickerow!** Pokazuje WSZYSTKIE zmapowane
skroty klawiszowe — zarowno Twoje customowe, jak i pluginowe.

- Wpisz `buffer` — zobaczysz wszystkie skroty zwiazane z bufferami
- Wpisz `telescope` — skroty Telescope
- Wpisz `<leader>` — wszystkie skroty zaczynajace sie od leadera

**Kiedy uzywac:** Gdy nie pamietasz skrotu. To Twoja "sciagawka na zywo".

### Symbols / Aerial (`<leader>fs`)

Pokazuje strukture biezacego pliku — funkcje, klasy, metody, zmienne.
Uzywa Aerial (ktory bazuje na LSP/treesitter).

**Kiedy uzywac:** W dlugim pliku, gdy szukasz konkretnej funkcji.
Szybsze niz scrollowanie.

### Search Resume (`<leader>sr`)

Wznawia **ostatnie** wyszukiwanie Telescope z dokladnie tym samym
stanem — query, pozycja, wyniki. Bardzo przydatne, gdy przypadkowo
zamknales Telescope.

### Search Word (`<leader>sw`)

Ustawia kursor na slowie, naciskasz `<leader>sw` — Telescope otwiera
Live Grep z tym slowem jako query. Odpowiednik "Find usages" z IDE.

### Search Diagnostics (`<leader>sd`)

Pokazuje WSZYSTKIE diagnostyki LSP z calego projektu:

- Bledy (errors)
- Ostrzezenia (warnings)
- Informacje (info)
- Hinty (hints)

**Kiedy uzywac:** Szybki przeglad problemow w projekcie — zamiast
przegladac plik po pliku.

### Fuzzy in Buffer (`<leader>/`)

Fuzzy search **wylacznie w biezacym pliku**. Otwiera sie jako dropdown
(bez preview), wiec nie zasłania kodu. Odpowiednik `Ctrl+F` z IDE,
ale z fuzzy matching.

### Nawigacja wewnatrz Telescope

| Skrot w Telescope | Dzialanie                               |
|-------------------|-----------------------------------------|
| `Ctrl+n` / `Down` | Nastepny wynik                         |
| `Ctrl+p` / `Up`   | Poprzedni wynik                        |
| `Enter`            | Otworz wybrany element                 |
| `Ctrl+v`           | Otworz w split pionowym               |
| `Ctrl+x`           | Otworz w split poziomym               |
| `Ctrl+t`           | Otworz w nowym tabie                   |
| `Esc`              | Zamknij Telescope (w normal mode)      |
| `Ctrl+c`           | Zamknij Telescope (w insert mode)      |
| `Ctrl+u`           | Wyczysc prompt                         |
| `Ctrl+/`           | Pokaz pomoc (keybindings w Telescope)  |

### Fuzzy matching — jak to dziala

Telescope uzywa algorytmu fuzzy, co oznacza, ze nie musisz wpisywac
dokladnej nazwy:

| Wpisujesz   | Znajdzie                                    |
|-------------|---------------------------------------------|
| `calcpy`    | `calculator.py`                             |
| `apiser`    | `api-service.ts`                            |
| `userca`    | `UserCard.vue`                              |
| `modpy`     | `models.py`                                 |
| `intts`     | `interfaces.ts`                             |

Kolejnosc liter sie liczy, ale nie musza byc obok siebie.

---

## Cwiczenia

### Cwiczenie 1: Find Files

1. Nacisnij `<leader>ff`
2. Wpisz `calc` — zauwaz, ze `calculator.py` pojawia sie na liscie
3. Bez otwierania, zmien query na `utils` — powinny pojawic sie `utils.py` i `utils.ts`
4. Wpisz `vue` — zobaczysz pliki `.vue`
5. Otworz jeden plik naciskajac `Enter`

### Cwiczenie 2: Live Grep

1. Nacisnij `<leader>fg`
2. Wpisz `def ` (ze spacja) — zobaczysz wszystkie definicje funkcji Python
3. Wyczysc i wpisz `interface` — znajdziesz definicje TypeScript
4. Wyczysc i wpisz `export` — zobaczysz wszystkie exporty
5. Wybierz wynik i nacisnij `Enter` — przejdziesz do dokladnej linii

### Cwiczenie 3: Search Word

1. Otworz `exercises/python/calculator.py`
2. Ustaw kursor na nazwie jakiejkolwiek funkcji
3. Nacisnij `<leader>sw` — Telescope otworzy Live Grep z ta nazwa
4. Zobaczysz wszystkie miejsca w projekcie, gdzie ta nazwa jest uzywana
5. To odpowiednik "Find All References"

### Cwiczenie 4: Keymaps — Twoja sciagawka

1. Nacisnij `<leader>fk`
2. Wpisz `buffer` — zobaczysz wszystkie skroty zwiazane z bufferami
3. Wyczysc i wpisz `leader` — zobaczysz swoje customowe skroty
4. Wpisz `telescope` — zobaczysz skroty Telescope
5. Wpisz `fold` — znajdziesz skroty do foldingu
6. Zapamietaj: `<leader>fk` to Twoj najlepszy przyjaciel, gdy zapomnisz skrotu!

### Cwiczenie 5: Symbols (Aerial)

1. Otworz `exercises/python/calculator.py`
2. Nacisnij `<leader>fs` — zobaczysz liste funkcji/klas w pliku
3. Wpisz nazwe funkcji — szybki skok do niej
4. Otworz `exercises/typescript/interfaces.ts` i powtorz
5. Porownaj — rozne jezyki, ta sama funkcjonalnosc

### Cwiczenie 6: Fuzzy in Buffer

1. Otworz duzy plik (np. `exercises/python/data_processing.py`)
2. Nacisnij `<leader>/`
3. Wpisz fragment kodu, ktory pamietasz (nazwa zmiennej, string)
4. Zauwaz, ze otwiera sie jako maly dropdown — nie zaslania calego ekranu
5. `Enter` przenosi kursor do znalezionej linii

### Cwiczenie 7: Search Resume

1. Uzyj `<leader>fg` i wpisz jakies query (np. `import`)
2. Przejrzyj wyniki, potem zamknij Telescope (`Esc`)
3. Nacisnij `<leader>sr` — Telescope otworzy sie ponownie z tym samym query!
4. Mozesz kontynuowac przeglad wynikow

### Cwiczenie 8: Otwieranie w splitach

1. Nacisnij `<leader>ff` i znajdz plik
2. Zamiast `Enter`, nacisnij `Ctrl+v` — plik otworzy sie w split pionowym
3. Ponownie `<leader>ff`, znajdz inny plik
4. Nacisnij `Ctrl+x` — plik otworzy sie w split poziomym
5. Masz teraz 3 okna — kazde z innym plikiem, otwarte bezposrednio z Telescope

### Cwiczenie 9: Diagnostics

1. Otworz plik z bledami (np. `exercises/python/broken.py` lub `exercises/typescript/broken.ts`)
2. Poczekaj chwile az LSP przeanalizuje plik
3. Nacisnij `<leader>sd` — zobaczysz liste WSZYSTKICH bledow/ostrzezen
4. Nawiguj po liscie i naciskaj `Enter` zeby przechodzic do problematycznych linii

### Cwiczenie 10: Help Tags

1. Nacisnij `<leader>fh`
2. Wpisz `telescope.nvim` — znajdziesz dokumentacje Telescope
3. Wyczysc i wpisz `vim.keymap` — znajdziesz dokumentacje Vim
4. Wpisz `treesitter` — dokumentacja treesitter
5. To szybszy sposob na czytanie help niz `:help`

---

## Cwiczenie bonusowe

**Scenariusz: debugowanie projektu**

Wyobraz sobie, ze dostajesz bug report: "Funkcja `calculate_total` zwraca
bledne wyniki". Uzyj Telescope, zeby szybko znalezc problem:

1. `<leader>fg` → wpisz `calculate_total` — znajdz definicje funkcji
2. `Enter` — przejdz do pliku
3. `<leader>fs` — uzyj Symbols, zeby zobaczyc strukture pliku
4. `<leader>sw` na nazwie zmiennej — znajdz gdzie jest uzywana
5. `<leader>sd` — sprawdz, czy LSP znalazl jakies diagnostyki
6. `<leader>sr` — wznow ostatnie wyszukiwanie, zeby kontynuowac
7. `<leader>/` — szukaj w biezacym pliku konkretnego wzorca

Caly workflow zajmuje kilka sekund — bez uzywania myszy, bez opuszczania edytora.

---

## Podsumowanie

| Skrot          | Picker            | Kiedy uzywac                        |
|----------------|-------------------|-------------------------------------|
| `<leader>ff`   | Find Files        | Szukasz pliku po nazwie             |
| `<leader>fg`   | Live Grep         | Szukasz tekstu w plikach            |
| `<leader>fb`   | Buffers           | Przelaczanie otwartych plikow       |
| `<leader>fh`   | Help Tags         | Czytanie dokumentacji               |
| `<leader>fr`   | Recent Files      | Ostatnio otwierane pliki            |
| `<leader>fk`   | Keymaps           | Szukasz skrotu klawiszowego         |
| `<leader>fs`   | Symbols           | Struktura biezacego pliku           |
| `<leader>sr`   | Search Resume     | Wznowienie ostatniego wyszukiwania  |
| `<leader>sw`   | Search Word       | Grep slowa pod kursorem             |
| `<leader>sd`   | Diagnostics       | Bledy i warningi LSP                |
| `<leader>/`    | Fuzzy Buffer      | Szukanie w biezacym pliku           |

**Nastepna lekcja:** Neo-tree — drzewo plikow i zarzadzanie struktura projektu
bezposrednio z edytora.
