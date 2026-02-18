# Lekcja 21: LSP nawigacja -- skaczemy po kodzie

> Czas: ~30-45 min | Poziom: Intermediate

## Cel lekcji

Nauczysz sie uzywac Language Server Protocol do nawigacji po kodzie -- skakania do definicji
funkcji, znajdowania wszystkich uzyc symboli, podgladania definicji w floating window i
poruszania sie po jumplist. LSP to fundament "IDE experience" w Neovimie -- inteligencja
edytora bez ciezkiego IDE.

## Teoria

### Czym jest LSP?

**Language Server Protocol** to standard komunikacji miedzy edytorem (klientem) a serwerem
jezykowym. Zamiast budowac obsluge kazdego jezyka w edytorze, Neovim rozmawia z oddzielnymi
serwerami -- kazdemu jezykowi odpowiada inny server:

| Jezyk | LSP server | Manager |
|-------|-----------|---------|
| Python | pyright | Mason |
| TypeScript | ts_ls (z Vue plugin) | Mason |
| Vue | vue_ls (hybrid mode) | Mason |
| Lua | lua_ls | Mason |
| JSON | jsonls | Mason |
| YAML | yamlls | Mason |
| HTML | html | Mason |
| CSS | cssls | Mason |

> **Twoja konfiguracja**: Wszystkie servery sa zarzadzane przez **Mason** (`mason.nvim`).
> Mozesz sprawdzic status serverow komenda `:Mason`. Jesli brakuje servera, Mason pobierze
> go automatycznie lub mozesz zainstalowac recznie z poziomu interfejsu Mason.

### Jak LSP dziala w praktyce?

Kiedy otwierasz plik, Neovim uruchamia odpowiedni language server w tle. Server analizuje
kod -- buduje drzewo symboli, rozumie typy, zna zaleznosci miedzy plikami. Kiedy uzywasz
`gd`, Neovim pyta server "gdzie jest definicja tego symbolu?" i serwer odpowiada sciezka
i numerem linii. Cala operacja trwa milisekundy.

```
              request: textDocument/definition
  Neovim ───────────────────────────────────► pyright
    │                                           │
    │      response: file.py, line 42, col 4    │
    ◄───────────────────────────────────────────┘
```

### Go to Definition: `gd`

Najczesciej uzywany skrot LSP. Umieszczasz kursor na nazwie funkcji, klasy, zmiennej lub
importu i naciskasz `gd` -- Neovim przenosi Cie do miejsca, gdzie symbol jest zdefiniowany.

| Kontekst | Co robi `gd` |
|----------|-------------|
| Na nazwie funkcji | Skacze do `def function_name(...)` |
| Na nazwie klasy | Skacze do `class ClassName:` |
| Na imporcie | Skacze do pliku zrodlowego |
| Na zmiennej | Skacze do miejsca pierwszego przypisania |
| Na typie TS | Skacze do `interface` / `type` |

> **Twoja konfiguracja**: `gd` ma wbudowana ochrone `focus_editor_win()`. Jesli masz otwarty
> panel boczny (neo-tree, Aerial), definicja otworzy sie w oknie edytora, a NIE w panelu
> bocznym. Bez tego zabezpieczenia Neovim moze otworzyc plik w waskim panelu drzewa plikow.

**Przyklad**: w pliku `exercises/python/data_processing.py` ustaw kursor na `BaseTransformer`
w linii klasy `ColumnRenamer(BaseTransformer[...])` i nacisnij `gd` -- przeskoczy Cie do
definicji `class BaseTransformer(ABC, Generic[T, R])`.

### Alternatywne Go to Definition: `grd`

Kickstart-style binding. Robi dokladnie to samo co `gd` -- istnieje dla spojnosci z reszta
`gr*` keybindow.

### References: `gr`

Odwrotnosc definicji -- zamiast "gdzie jest zdefiniowany ten symbol?", pytasz "gdzie jest
uzywany?". Nacisnij `gr` na nazwie klasy i zobaczysz liste wszystkich miejsc, gdzie ta klasa
jest importowana, instancjonowana lub uzywana jako typ.

| Klawisz | Opis |
|---------|------|
| `gr` | Znajdz wszystkie referencje (otwiera quickfix/Telescope) |
| `grr` | Alternatywne References (kickstart-style) |

Wynik pojawia sie w liscie (quickfix lub Telescope picker) -- nawigujesz `j`/`k`, Enter
zeby przejsc do wybranej referencji.

> **Twoja konfiguracja**: `gr` rowniez ma ochrone `focus_editor_win()` -- wyniki nie otwieraja
> sie w panelu bocznym.

### Peek Definition: `gp`

Czasem nie chcesz OPUSZCZAC biezacego miejsca, a tylko ZERKNAC na definicje. `gp` otwiera
floating window z podgladem definicji -- widzisz kod z syntax highlighting, ale Twoj kursor
i pozycja w pliku nie zmieniaja sie.

| Klawisz | W floating window |
|---------|-------------------|
| `gp` | Otwiera peek definition |
| `q` | Zamyka floating window |
| `Esc` | Zamyka floating window |

Jest to odpowiednik "Peek Definition" z VSCode (Alt+F12). Idealne kiedy chcesz szybko
sprawdzic sygnature funkcji bez tracenia kontekstu.

### Go to Implementation: `gri`

Kiedy pracujesz z interfejsami (TypeScript) lub klasami abstrakcyjnymi (Python), `gri`
przeskakuje z interfejsu/klasy abstrakcyjnej do konkretnej implementacji.

```
interface Serializable {   ◄── jestes tutaj
  serialize(): string;
}

class User implements Serializable {   ◄── gri przenosi tutaj
  serialize(): string { ... }
}
```

### Type Definition: `grt`

Kiedy kursor jest na zmiennej, `grt` przenosi Cie do definicji **typu** tej zmiennej,
a nie do miejsca jej przypisania.

```typescript
const user: User = getUser();
//    ^--- kursor tutaj
//    gd  -> skacze do getUser() (definicja zmiennej)
//    grt -> skacze do interface User (typ zmiennej)
```

### Declaration: `grD`

Skacze do deklaracji symbolu. W wiekszosci przypadkow zachowuje sie jak `gd`, ale w jezykach
z rozrozneniem miedzy deklaracja a definicja (np. C/C++ header vs implementation) moze
skoczye do innego miejsca.

### Jumplist: Ctrl+O / Ctrl+I

Po kazdym skoku (`gd`, `gr`, `gri` itd.) Neovim zapamietuje Twoja poprzednia pozycje
w **jumplist**. To stos pozycji -- mozesz sie po nim cofac i przesuwac do przodu:

| Klawisz | Opis |
|---------|------|
| `Ctrl+O` | Skocz do poprzedniej pozycji (back) |
| `Ctrl+I` | Skocz do nastepnej pozycji (forward) |

**Typowy workflow**:
1. Edytujesz plik A, linia 42
2. `gd` -> skaczesz do pliku B, linia 15 (definicja)
3. Czytasz definicje, rozumiesz co robi
4. `Ctrl+O` -> wracasz do pliku A, linia 42

Mozesz zaglebiacz sie wielokrotnie (`gd` -> `gd` -> `gd`) i wracac krok po kroku
(`Ctrl+O` -> `Ctrl+O` -> `Ctrl+O`). Jumplist dziala jak historia przegladarki.

> **Tip**: Komenda `:jumps` pokazuje caly jumplist. Mozesz tez uzyc Telescope do
> przeszukiwania jumplist.

### Document Highlight

To subtelna, ale bardzo przydatna funkcja. Kiedy kursor zatrzyma sie na symbolu
(event `CursorHold`), LSP automatycznie podswietli **wszystkie wystapienia** tego symbolu
w biezacym pliku. Kiedy ruszysz kursor (`CursorMoved`), podswietlenie znika.

> **Twoja konfiguracja**: Document highlight jest wlaczony automatycznie. Nie musisz
> naciskac zadnego klawisza -- wystarczy zatrzymac kursor na nazwie zmiennej na chwile
> (~700ms domyslnie) i zobaczysz podswietlone wszystkie jej uzycia. Kolory podswietlenia
> sa dostosowane do Catppuccin Mocha.

To pomaga szybko zobaczyc zakres uzycia zmiennej bez koniecznosci uzywania `gr`.

### Podsumowanie nawigacji LSP

```
                        gri (implementation)
                             │
                             v
  grt (type def) ───► Symbol ◄─── gd / grd (definition)
                         │
                         v
                    gr / grr (references)
                         │
                         v
                   Quickfix / Telescope
```

## Cwiczenia

### Cwiczenie 1: Go to Definition w Python

Otworz `exercises/python/data_processing.py`:

1. Idz do linii z `class ColumnRenamer(BaseTransformer[...])` (~linia 148)
2. Ustaw kursor na `BaseTransformer` i nacisnij `gd`
3. Powinno Cie przeniesc do `class BaseTransformer(ABC, Generic[T, R])` (~linia 136)
4. Wroc do `ColumnRenamer` klawiszem `Ctrl+O`
5. Teraz ustaw kursor na `ABC` (w definicji BaseTransformer) i nacisnij `gd`
6. Przenosisz sie do standardowej biblioteki Pythona -- do definicji klasy `ABC`!
7. Wroc `Ctrl+O`

### Cwiczenie 2: References w Python

Kontynuuj w `exercises/python/data_processing.py`:

1. Ustaw kursor na nazwie klasy `DataSchema` (~linia 53)
2. Nacisnij `gr` -- zobaczysz liste miejsc, gdzie `DataSchema` jest uzywana
3. Powinienes zobaczyc uzycie w `DataValidator.__init__()` i inne miejsca
4. Wybierz jedna referencje (Enter) i przejdz do niej
5. Wroc `Ctrl+O`

### Cwiczenie 3: Nawigacja po TypeScript

Otworz `exercises/typescript/api-service.ts`:

1. Ustaw kursor na `ApiResponse` w linii `): Promise<ApiResponse<T>>` (~linia 71)
2. Nacisnij `gd` -- powinno Cie przeniesc do `interfaces.ts`, do definicji `ApiResponse`
3. Przejrzyj interfejs, zwroc uwage na pola `data`, `message`, `statusCode`
4. Wroc `Ctrl+O`
5. Teraz ustaw kursor na `User` w `async getUsers(...)` (~linia 104)
6. Nacisnij `gd` -- skaczesz do definicji `User` w `interfaces.ts`
7. Wroc `Ctrl+O`

### Cwiczenie 4: Peek Definition

Otworz `exercises/typescript/store.ts`:

1. Ustaw kursor na `UserPreferences` w interfejsie `User` (~linia 26)
2. Nacisnij `gp` -- otworzy sie floating window z definicja `UserPreferences`
3. Przeczytaj definicje (theme, language, notifications, itemsPerPage)
4. Zamknij floating window klawiszem `q` lub `Esc`
5. Zauważ, ze Twoj kursor NIE zmienil pozycji -- nadal jestes na tej samej linii

### Cwiczenie 5: Lancuch skokow i jumplist

Otworz `exercises/typescript/api-service.ts`:

1. Ustaw kursor na `Interceptor` (~linia 48, `private interceptors: Interceptor[]`)
2. `gd` -> skaczesz do `type Interceptor = ...` (~linia 29)
3. Ustaw kursor na `RequestConfig` w definicji Interceptor
4. `gd` -> skaczesz do `interface RequestConfig` (~linia 21)
5. Teraz wroc krok po kroku:
   - `Ctrl+O` -> wraca do `type Interceptor`
   - `Ctrl+O` -> wraca do `private interceptors`
6. `Ctrl+I` -> przeskakujesz z powrotem do `type Interceptor`

### Cwiczenie 6: Implementation w TypeScript

Otworz `exercises/typescript/api-service.ts`:

1. Ustaw kursor na nazwie `ApiError` (~linia 31)
2. Nacisnij `gr` -- zobaczysz gdzie `ApiError` jest uzywany
3. Powinny pojawic sie throw-y w metodach `request()`, `uploadFile()`, `downloadFile()`
4. Przejdz do jednej z referencji i sprawdz kontekst
5. Wroc `Ctrl+O`

### Cwiczenie 7: Type Definition

Otworz `exercises/python/data_processing.py`:

1. Ustaw kursor na zmiennej `result` w metodzie `Pipeline.process()` (~linia 320)
2. Nacisnij `K` zeby zobaczyc typ zmiennej w hover (powinno pokazac `list[dict[str, Any]]`)
3. Powtorz z innymi zmiennymi -- np. `parser` w `DataLoader.load()` (~linia 101)

### Cwiczenie 8: Document Highlight

Otworz `exercises/python/calculator.py`:

1. Ustaw kursor na nazwie `self.memory` w metodzie `memory_store()` (~linia 172)
2. Poczekaj chwile (CursorHold) -- LSP podswietli wszystkie uzycia `self.memory` w pliku
3. Policz ile razy `memory` jest uzywane (powinno byc w `memory_store`, `memory_recall`,
   `memory_clear`)
4. Rusz kursor -- podswietlenie zniknie

### Cwiczenie 9: Cross-file navigation

1. Otworz `exercises/typescript/store.ts`
2. Ustaw kursor na `ref` w imporcie z `vue` (~linia 10)
3. Nacisnij `gd` -- przejdziesz do definicji `ref` w pakiecie Vue
4. `Ctrl+O` -- wroc
5. Ustaw kursor na `computed` i nacisnij `gd`
6. Obejrzyj definicje `computed()` w kodzie zrodlowym Vue
7. `Ctrl+O` -- wroc

### Cwiczenie 10: Kombinacja technik

Otworz `exercises/python/models.py`:

1. Ustaw kursor na `OrderStatus` w klasie `Order` (~linia 121)
2. `gp` -- peek definition (podglad enum bez opuszczania `Order`)
3. Zamknij peek (`q`)
4. `gd` -- skocz do definicji `OrderStatus`
5. `gr` -- sprawdz gdzie `OrderStatus` jest uzywane
6. Wroc do `Order` (`Ctrl+O` tyle razy ile potrzeba)

## Cwiczenie bonusowe

Wykonaj pelna "eksploracje kodu" w `exercises/typescript/api-service.ts`:

1. Zacznij od metody `getUsers()` (~linia 104)
2. Uzyj `gd` na `QueryParams` -> sprawdz jak wyglada ten typ w `interfaces.ts`
3. Uzyj `gd` na `PaginatedResponse` -> sprawdz interfejs paginacji
4. Wroc (`Ctrl+O` x2) do `getUsers()`
5. Uzyj `gd` na `this.buildQuery` -> przejdz do metody prywatnej
6. Uzyj `gd` na `this.request` -> przejdz do metody generycznej
7. W `request()` uzyj `gp` na `ApiError` -> podglad klasy bledu
8. Wroc na poczatek (`Ctrl+O` wielokrotnie)

To jest realny workflow -- tak eksploruje sie nieznany kod w codziennej pracy.

## Podsumowanie

### Nauczone komendy

| Komenda | Opis |
|---------|------|
| `gd` | Go to Definition -- skocz do definicji symbolu |
| `grd` | Go to Definition (kickstart-style) |
| `gr` | References -- znajdz wszystkie uzycia symbolu |
| `grr` | References (kickstart-style) |
| `gp` | Peek Definition -- podglad w floating window |
| `gri` | Go to Implementation -- interfejs -> implementacja |
| `grt` | Type Definition -- zmienna -> jej typ |
| `grD` | Declaration -- skocz do deklaracji |
| `Ctrl+O` | Jumplist back -- wroc do poprzedniej pozycji |
| `Ctrl+I` | Jumplist forward -- przejdz do nastepnej pozycji |

### Konfiguracja uzyta w tej lekcji

| Element | Wartosc / Opis |
|---------|---------------|
| `focus_editor_win()` | Ochrona `gd`/`gr` przed otwieraniem w panelach bocznych |
| Document Highlight | Auto-podswietlanie symbolu pod kursorem (CursorHold) |
| Mason | Manager instalacji LSP serverow |

### Co dalej?

W **lekcji 22** poznasz **diagnostyke LSP** -- jak czytac bledy i ostrzezenia bezposrednio
w edytorze, nawigowac miedzy nimi klawiszami `[d`/`]d` i rozumiec co mowia Ci znaki
diagnostyczne w sign column.
