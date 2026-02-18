# Lekcja 23: LSP akcje -- refactoring i formatowanie

> Czas: ~30-45 min | Poziom: Intermediate

## Cel lekcji

Nauczysz sie uzywac code actions do automatycznego naprawiania bledow, rename do zmiany
nazw symboli w calym projekcie, formatowania kodu przez conform.nvim, inlay hints
do wyswietlania typow inline oraz systemu autocompletion (nvim-cmp z LuaSnip).

## Teoria

### Code Actions: `<leader>ca` / `gra`

Code actions to "inteligentne poprawki" proponowane przez LSP server. Kiedy kursor
jest na linii z bledem (lub na symbolu, ktory mozna zrefaktoryzowac), nacisnij
`<leader>ca` (lub `gra`) -- pojawi sie lista dostepnych akcji:

| Typ code action | Przyklad |
|----------------|---------|
| Quick Fix | Dodaj brakujacy import |
| Refactor | Wyodrebnij funkcje (extract function) |
| Source Action | Organizuj importy, usun nieuzywane |
| Import | Automatyczny import z sugestia modulu |

```
┌──────────────────────────────────────────┐
│  1. Add import: import math              │
│  2. Create function "math"               │
│  3. Ignore error (reportMissingModuleSo  │
└──────────────────────────────────────────┘
```

Wybierasz akcje klawiszami `j`/`k` i potwierdzasz Enter. Neovim automatycznie
wprowadzi zmiane -- doda import, zmieni kod, usunie nieuzywana zmienna itd.

> **Twoja konfiguracja**: `<leader>ca` dziala w trybie Normal. `gra` dziala zarowno
> w trybie Normal jak i Visual -- w Visual mode mozesz zaznaczyc blok kodu i wykonac
> na nim code action (np. extract function).

**Kiedy uzywac code actions?**
- Widzisz blad "missing import" -- `<leader>ca` -> "Add import"
- Widzisz nieuzywany import -- `<leader>ca` -> "Remove unused imports"
- Chcesz wyodrebnic fragment kodu do osobnej funkcji
- LSP sugeruje poprawke (np. async function bez await)

### Rename: `<leader>rn` / `grn`

Rename to zmiana nazwy symbolu **we wszystkich plikach projektu**. Nie jest to zwykly
find-and-replace -- LSP rozumie kontekst i zmienia tylko wlasciwe wystapienia:

```python
# Przed rename (kursor na "calculate"):
def calculate(a, b):    # ta nazwa
    return a + b

result = calculate(1, 2)  # i ta tez
print("calculate")         # ale ten string NIE -- to tekst, nie symbol!
```

| Klawisz | Opis |
|---------|------|
| `<leader>rn` | Rename -- zmien nazwe symbolu |
| `grn` | Rename (kickstart-style) |

Po nacisnieciu `<leader>rn` pojawia sie input field z aktualna nazwa. Wpisz nowa
nazwe i potwierdz Enter -- LSP zmieni nazwe we wszystkich plikach, gdzie symbol
jest uzywany.

**Typowe uzycia**:
- Zmiana nazwy zmiennej/funkcji/klasy
- Zmiana nazwy metody interfejsu (zmienia tez implementacje)
- Zmiana nazwy pola w TypeScript interface (zmienia uzycia w komponentach Vue)

### Format Buffer: `<leader>cf`

Formatuje caly bufor aktualnego pliku. Uzywa **conform.nvim** jako posrednika
miedzy Neovimem a formatterami:

| Jezyk | Formattery | Co robia |
|-------|-----------|---------|
| Python | isort + black | Sortowanie importow + formatowanie kodu |
| JS/TS/Vue | prettier | Formatowanie kodu, cudzyslow, sredniki |
| CSS/HTML | prettier | Formatowanie znacznikow i styli |
| JSON/YAML | prettier | Formatowanie danych strukturalnych |
| Markdown | prettier | Formatowanie tabel, list |
| Lua | stylua | Formatowanie kodu Lua (konfiguracja Neovim) |

> **Twoja konfiguracja**: **Format-on-save** jest wlaczony domyslnie. Kiedy zapisujesz
> plik (`:w`), conform automatycznie formatuje kod przed zapisem. Nie musisz pamietac
> o `<leader>cf` -- ale przydaje sie kiedy chcesz sformatowac bez zapisywania lub
> kiedy format-on-save jest wylaczony dla danego pliku.

Kolejnosc formatterow ma znaczenie:
1. Python: najpierw **isort** (sortuje importy), potem **black** (formatuje reszte)
2. Inne jezyki: pojedynczy formatter (prettier/stylua)

### Toggle Inlay Hints: `<leader>th`

Inlay hints to dodatkowe informacje o typach wyswietlane inline w kodzie:

```typescript
// Bez inlay hints:
const result = calculateTotal(prices);

// Z inlay hints:
const result: number = calculateTotal(prices: number[]);
//          ^^^^^^^^                         ^^^^^^^^^
//          inlay hint                       inlay hint
```

| Klawisz | Opis |
|---------|------|
| `<leader>th` | Toggle inlay hints on/off |

Inlay hints sa przydatne kiedy chcesz zobaczyc typy bez uzywania hover (`K`),
ale moga byc tez rozpraszajace. Dlatego mozesz je wlaczac i wylaczac.

> **Uwaga**: Nie kazdy LSP server wspiera inlay hints. Pyright i ts_ls wspieraja,
> ale np. html czy cssls -- nie.

### Autocompletion: nvim-cmp

System autocompletion w Twoim setupie to **nvim-cmp** z kilkoma zrodlami:

#### Klawisze completion

| Klawisz | Opis |
|---------|------|
| (auto) | Completion uruchamia sie automatycznie podczas pisania |
| `Tab` | Nastepna sugestia w liscie |
| `S-Tab` (Shift+Tab) | Poprzednia sugestia |
| `CR` (Enter) | Potwierdz wybrana sugestie |
| `C-Space` | Wywolaj completion recznie |
| `C-e` | Zamknij menu completion |
| `C-b` | Przewin dokumentacje w popupie (back) |
| `C-f` | Przewin dokumentacje w popupie (forward) |

#### Zrodla completion (w kolejnosci priorytetu)

| Zrodlo | Ikona | Opis |
|--------|-------|------|
| `nvim_lsp` | (zalezy od typu) | Sugestie z language servera (najwyzszy priorytet) |
| `luasnip` | (snippet icon) | Snippety z friendly-snippets |
| `buffer` | (buffer icon) | Slowa z aktualnego bufora |
| `path` | (path icon) | Sciezki plikow/katalogow |

**Kolejnosc ma znaczenie**: sugestie LSP pojawiaja sie na gorze listy, snippety nizej,
slowa z bufora jeszcze nizej, sciezki na koncu.

#### Jak wyglada popup completion

```
┌────────────────────────────────────────┐
│ 󰊕 calculate_hypotenuse   Function    │  ◄ LSP
│ 󰊕 calculate_total        Function    │  ◄ LSP
│  calculator              Variable    │  ◄ LSP
│  calc                    Snippet     │  ◄ LuaSnip
│  calculate               Buffer      │  ◄ buffer
└────────────────────────────────────────┘
```

Po prawej stronie kazdej sugestii widac typ (Function, Variable, Snippet itd.)
i zrodlo. Kiedy sugestia jest podswietlona, po prawej moze pojawic sie
documentation popup z opisem.

### LuaSnip + friendly-snippets

**LuaSnip** to silnik snippetow. **friendly-snippets** dostarcza gotowe snippety
dla wielu jezykow:

| Jezyk | Przykladowe snippety |
|-------|---------------------|
| Python | `def`, `class`, `if__main__`, `try`, `for`, `with` |
| TypeScript | `func`, `class`, `interface`, `imp` (import), `log` |
| Vue | `vue` (SFC template), `ref`, `computed`, `onMounted` |
| Ogolne | `todo`, `fixme`, `date` |

Snippety dzialaja przez Tab:
1. Zacznij pisac prefix snippeta (np. `def`)
2. Snippet pojawi sie w completion menu
3. Potwierdz Enter -- snippet sie rozwinie
4. Tab przenosi do nastepnego placeholdera w snippecie
5. Wpisz wartosc i Tab ponownie

```python
# Po wpisaniu "def" + Enter:
def function_name(params):
    """docstring"""
    pass
#   ^^^^^^^^^^^^^ -- kursor tutaj, Tab przechodzi do nastepnego pola
```

### Laczenie technik -- workflow

Typowy workflow naprawiania kodu:

1. `]d` -- skocz do bledu
2. `<leader>ld` -- przeczytaj co jest nie tak
3. `<leader>ca` -- sprawdz czy LSP ma gotowa poprawke
4. Jesli tak -- wybierz akcje i potwierdz
5. Jesli nie -- napraw recznie
6. `:w` -- zapisz (format-on-save sformatuje kod)
7. `]d` -- nastepny blad

## Cwiczenia

### Cwiczenie 1: Code actions -- naprawianie importow

Otworz `exercises/python/broken.py`:

1. Idz do linii `return math.sqrt(...)` (~linia 20)
2. Ustaw kursor na `math` i nacisnij `<leader>ca`
3. Powinno pojawic sie "Add `import math`" (lub podobna opcja)
4. Wybierz te akcje (Enter) -- import zostanie dodany na gorze pliku
5. Sprawdz czy blad zniknal (brak ikony 󰅚 na tej linii)

### Cwiczenie 2: Code actions -- rozne typy

Kontynuuj w `exercises/python/broken.py`:

1. Idz do `message = greet("Alice")` (~linia 36)
2. Nacisnij `<leader>ca` -- sprawdz dostepne akcje
3. Prawdopodobnie nie ma quick fix -- ten blad wymaga recznej zmiany
4. Napraw recznie: zmien na `greet("Alice", "Hello", "!")`
5. Idz do `result: int = add_numbers("hello", "world")` (~linia 44)
6. Nacisnij `<leader>ca` -- moze byc sugestia zmiany argumentow
7. Napraw recznie jesli nie ma code action: zmien na `add_numbers(1, 2)`

### Cwiczenie 3: Rename symbolu

Otworz `exercises/typescript/store.ts`:

1. Ustaw kursor na nazwie interfejsu `UserPreferences` (~linia 29)
2. Nacisnij `<leader>rn`
3. Pojawi sie input z aktualna nazwa `UserPreferences`
4. Zmien na `UserSettings` i potwierdz Enter
5. Sprawdz:
   - Definicja interfejsu zmienila nazwe (~linia 29)
   - Pole `preferences: UserPreferences` w `User` zmieniło sie na `preferences: UserSettings`
   - Uzycie w `updatePreferences(prefs: Partial<UserPreferences>)` tez sie zmienilo
6. Cofnij zmiany: `u` wielokrotnie az wrocisz do oryginalu

### Cwiczenie 4: Rename metody

Kontynuuj w `exercises/typescript/store.ts`:

1. Ustaw kursor na nazwie funkcji `fetchCurrentUser` (~linia 66)
2. Nacisnij `<leader>rn`
3. Zmien na `loadCurrentUser`
4. Sprawdz czy nazwa zmienila sie w:
   - Definicji funkcji
   - Return statement na koncu `useUserStore()`
5. Cofnij (`u`)

### Cwiczenie 5: Format Buffer

Otworz `exercises/python/calculator.py`:

1. Dodaj celowo zly formatting -- np. nadmiarowe spacje:
   ```python
   def    test(  a,b,  c  ):
       return    a+b+c
   ```
2. Nacisnij `<leader>cf` -- conform sformatuje plik (black)
3. Sprawdz wynik -- spacje powinny byc znormalizowane
4. Cofnij (`u`)

Alternatywnie: po prostu zapisz plik (`:w`) -- format-on-save zrobi to samo.

### Cwiczenie 6: Completion w Python

Otworz `exercises/python/calculator.py`:

1. Idz na koniec pliku
2. Wejdz w tryb Insert (`o`)
3. Wpisz `calc = Calculator()` i Enter
4. Wpisz `calc.` -- completion powinno sie uruchomic automatycznie
5. Zobaczysz sugestie: `add`, `subtract`, `multiply`, `divide`, `power`, `sqrt`,
   `memory_store`, `memory_recall`, `memory_clear`, `history`, `clear_history`, `chain`
6. Uzyj `Tab`/`S-Tab` do nawigacji po liscie
7. Wybierz `divide` (Enter)
8. Wpisz `(10, ` -- moze pojawic sie signature help z parametrami
9. Nacisnij `Esc` i cofnij (`u`)

### Cwiczenie 7: Completion ze snippetami

Otworz `exercises/python/calculator.py`:

1. Idz na koniec pliku, wejdz w Insert (`o`)
2. Wpisz `def` -- w completion powinien pojawic sie snippet `def`
3. Wybierz snippet (moze byc oznaczony ikona snippeta)
4. Po wybraniu snippet sie rozwinie -- zobaczysz placeholdery
5. Wpisz nazwe funkcji, Tab do parametrow, Tab do body
6. Nacisnij `Esc` i cofnij (`u`)

### Cwiczenie 8: Completion z path source

1. W dowolnym pliku Python wejdz w Insert
2. Wpisz `# Path: ./` -- completion powinno zaproponowac sciezki plikow
3. Albo w stringu: `path = "./` -- path source zaproponuje pliki z biezacego katalogu
4. Nacisnij `C-e` zeby zamknac menu i `Esc` + `u` zeby cofnac

### Cwiczenie 9: Manual completion trigger

Otworz `exercises/typescript/api-service.ts`:

1. Idz na koniec pliku, wejdz w Insert (`o`)
2. Wpisz `const api = new Api` -- completion powinno sie pojawic automatycznie
3. Nacisnij `C-e` zeby zamknac menu
4. Nacisnij `C-Space` -- menu pojawi sie ponownie (manual trigger)
5. Scroll documentation z `C-b`/`C-f` jesli jest popup z opisem
6. `Esc` + `u`

### Cwiczenie 10: Inlay Hints

Otworz `exercises/typescript/store.ts`:

1. Nacisnij `<leader>th` -- wlacz inlay hints
2. Sprawdz czy pojawiaja sie dodatkowe informacje o typach:
   - Typ zwracany computed properties
   - Typy parametrow
   - Typy zmiennych bez jawnej adnotacji
3. Nacisnij `<leader>th` ponownie -- wylacz inlay hints
4. Porownaj czytelnosc kodu z i bez inlay hints

## Cwiczenie bonusowe

Napraw WSZYSTKIE bledy w `exercises/python/broken.py` uzywajac code actions i recznych
poprawek. Workflow dla kazdego bledu:

1. `]d` -- nastepny blad
2. `<leader>ld` -- przeczytaj wiadomosc
3. `<leader>ca` -- sprawdz czy jest quick fix
4. Jesli jest -- uzyj go
5. Jesli nie -- napraw recznie
6. `:w` -- zapisz (format-on-save)
7. Sprawdz czy blad zniknal

Lista bledow do naprawy:
- `math` not defined -> code action: add import
- `config` not defined -> dodaj `config = {}` lub import
- `greet("Alice")` -> dodaj brakujace argumenty
- `add_numbers("hello", "world")` -> zmien na int
- `user.phone` -> usun linie lub dodaj pole `phone` do `User`
- `return None` -> zmien na `return users`
- Unreachable `print(...)` -> usun linie
- `total` possibly unbound -> dodaj `else: total = 0`
- `scores[42]` -> zmien na `scores["alice"]`

Po naprawieniu wszystkich bledow, `]d` nie powinno juz skakac -- brak diagnostyk!

## Podsumowanie

### Nauczone komendy

| Komenda | Opis |
|---------|------|
| `<leader>ca` / `gra` | Code Action -- quick fix, refactor, import |
| `<leader>rn` / `grn` | Rename -- zmiana nazwy w calym projekcie |
| `<leader>cf` | Format Buffer -- formatowanie przez conform |
| `<leader>th` | Toggle Inlay Hints -- typy inline |
| `Tab` | Nastepna sugestia completion |
| `S-Tab` | Poprzednia sugestia completion |
| `CR` (Enter) | Potwierdz sugestie |
| `C-Space` | Wywolaj completion recznie |
| `C-e` | Zamknij menu completion |
| `C-b` / `C-f` | Scroll documentation popup |

### Konfiguracja uzyta w tej lekcji

| Element | Wartosc / Opis |
|---------|---------------|
| conform.nvim | Format-on-save, formattery per filetype |
| black + isort | Python formatting (isort sortuje importy) |
| prettier | JS/TS/Vue/CSS/HTML/JSON/YAML/Markdown |
| stylua | Lua formatting |
| nvim-cmp | Autocompletion engine |
| LuaSnip | Snippet engine + friendly-snippets |
| Sources | nvim_lsp > luasnip > buffer > path |

### Co dalej?

W **lekcji 24** poznasz **Aerial i Namu** -- narzedzia do nawigacji po symbolach.
Aerial daje Ci persystentny panel z outline kodu (jak "Outline" w VSCode),
a Namu pozwala na fuzzy search po symbolach z podgladem na zywo.
