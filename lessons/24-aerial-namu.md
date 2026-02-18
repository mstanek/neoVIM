# Lekcja 24: Aerial i Namu -- symbol navigation

> Czas: ~30-45 min | Poziom: Intermediate

## Cel lekcji

Nauczysz sie uzywac Aerial jako persystentny panel outline (drzewo klas, funkcji, metod)
oraz Namu jako fuzzy picker do szybkiego skakania po symbolach. Te dwa narzedzia uzupelniaja
nawigacje LSP z lekcji 21 -- zamiast "skocz do definicji konkretnego symbolu", daja Ci
ptasia perspektywe na cala strukture pliku.

## Teoria

### Aerial -- outline panel

**Aerial** otwiera panel boczny z drzewem symboli pliku. Widac klasy, funkcje, metody,
stale -- wszystko zhierarchizowane. To odpowiednik panelu "Outline" z VSCode lub
"Structure" z PyCharm/WebStorm.

```
┌─ editor ──────────────────────┬─ Aerial ──────────┐
│                               │ 󰠱 FileFormat       │
│ class DataLoader:             │ 󰠱 ColumnSchema     │
│     def __init__(self):       │   󰊕 validate       │
│         ...                   │ 󰠱 DataSchema       │
│     def load(self, ...):      │   󰊕 get_column     │
│         ...                   │   󰜢 column_names   │
│     def _parse_csv(self, ..): │   󰜢 required_cols  │
│         ...                   │ 󰠱 DataLoader       │
│                               │   󰊕 __init__       │
│                               │   󰊕 load           │
│                               │   󰊕 load_string    │
│                               │   󰊕 _parse_csv     │
│                               │   󰊕 _parse_tsv     │
│                               │   󰊕 _parse_json    │
└───────────────────────────────┴────────────────────┘
```

#### Klawisze globalne (w edytorze)

| Klawisz | Opis |
|---------|------|
| `<leader>o` | Toggle Aerial outline panel (prawy panel) |
| `<leader>O` | Aerial Navigation -- floating mini-map |
| `{` | Skocz do poprzedniego symbolu |
| `}` | Skocz do nastepnego symbolu |
| `<leader>or` | Refresh symboli (przydatne dla Vue) |

> **Twoja konfiguracja**: `{` i `}` sa zmapowane z `pcall` -- jesli Aerial nie jest
> aktywny lub nie ma symboli, klawisze po prostu nic nie zrobia (zamiast wyrzucac blad).
> Domyslne zachowanie Vima (`{`/`}` = nawigacja po paragrafach) jest nadpisane.

#### Klawisze wewnatrz panelu Aerial

Kiedy kursor jest w panelu Aerial (po `<leader>o` i przeskoczeniu do panelu):

| Klawisz | Opis |
|---------|------|
| `{` / `}` | Poprzedni / nastepny symbol |
| `CR` (Enter) | Skocz do symbolu w edytorze |
| `p` | Scroll -- podglad symbolu bez skakania |
| `o` | Toggle -- zwin/rozwin drzewo |
| `h` | Zwin galaz drzewa |
| `l` | Rozwin galaz drzewa |
| `L` | Rozwin wszystko |
| `H` | Zwin wszystko |
| `q` | Zamknij panel Aerial |

#### Backends per filetype

Aerial pobiera symbole z roznych zrodel w zaleznosci od jezyka:

| Filetype | Backend | Dlaczego |
|----------|---------|----------|
| Python | treesitter -> LSP | Treesitter jest szybszy, LSP jako fallback |
| Vue | LSP only | Treesitter nie radzi sobie z SFC (template + script + style) |
| TypeScript/JS | LSP -> treesitter | LSP daje lepsze typy, treesitter jako fallback |

> **Twoja konfiguracja**: Aerial filtruje typy symboli per filetype. Dla Vue
> odfiltrowuje tagi HTML (zeby nie zasmiecac outline tagami `<div>`, `<span>` itd.).
> Widoczne typy to glownie: Class, Function, Method, Property, Interface, Enum.

#### Opcje wyswietlania

| Opcja | Wartosc | Efekt |
|-------|---------|-------|
| `default_unfold_level` | `1` | Klasy widoczne z metodami (1 poziom rozwiniety) |
| `post_jump_cmd` | `"normal! zz"` | Po skoku kursor jest wycentrowany na ekranie |
| Ikony | Class 󰠱, Function 󰊕, Method 󰆧 itd. | Nerd Font icons per symbol kind |

### Aerial Navigation: `<leader>O`

Floating mini-map -- otwiera male okienko z lista symboli, w ktorym mozesz
szybko nawigowac bez panelu bocznego. Przydatne kiedy nie chcesz trzymac Aerial
otwartego na stale.

```
┌─────────────────────────────────────┐
│ 󰠱 ColumnSchema                      │
│ 󰠱 DataSchema                        │
│ 󰠱 DataLoader           ◄── kursor  │
│ 󰠱 BaseTransformer                   │
│ 󰠱 ColumnRenamer                     │
│ 󰠱 TypeCaster                        │
│ 󰠱 Pipeline                          │
│ 󰊕 normalize_whitespace              │
│ 󰊕 extract_emails                    │
└─────────────────────────────────────┘
```

### Namu -- fuzzy symbol picker

**Namu** to zupelnie inne podejscie niz Aerial. Zamiast panelu bocznego, dostaje
fuzzy picker -- wpisujesz pare liter nazwy symbolu i natychmiast skaczysz do niego.
To jak Zed's symbol picker lub VSCode Ctrl+Shift+O.

#### Klawisze Namu

| Klawisz | Opis |
|---------|------|
| `<leader>ss` | Namu Symbols -- fuzzy search z podgladem |
| `<leader>sw` | Workspace Symbols -- szukaj we wszystkich otwartych plikach |
| `<leader>st` | Treesitter Symbols -- alternatywa oparta o treesitter |

#### Jak wyglada Namu

Po nacisnieciu `<leader>ss`:

```
┌─ Namu ────────────────────────────────────────┐
│ > val_                                        │  ◄ wpisujesz "val"
├───────────────────────────────────────────────┤
│ 󰠱 DataValidator                               │  ◄ pasujace symbole
│   󰊕 validate                                  │
│   󰊕 _validate_row                             │
│   󰊕 is_valid                                  │
│ 󰠱 ValidationError                             │
├───────────────────── preview ──────────────────┤
│ class DataValidator:                           │  ◄ podglad na zywo
│     """Validates data rows against a schema."" │
│     def __init__(self, schema, strict=False):  │
│         self.schema = schema                   │
└────────────────────────────────────────────────┘
```

> **Twoja konfiguracja**: Namu wyswietla symbole w trybie **tree** -- widac hierarchie
> (klasa -> metoda). `row_position = top10` -- wyniki pojawiaja sie u gory ekranu.

#### Nawigacja w Namu

| Klawisz | Opis |
|---------|------|
| Wpisywanie tekstu | Filtruje symbole fuzzy |
| `Ctrl+n` / strzalka dol | Nastepny wynik |
| `Ctrl+p` / strzalka gora | Poprzedni wynik |
| `CR` (Enter) | Skocz do wybranego symbolu |
| `Esc` | Zamknij Namu |

### Aerial vs Namu -- kiedy co uzywac?

| Scenariusz | Narzedzie | Dlaczego |
|-----------|-----------|---------|
| Chce zobaczyc cala strukture pliku | **Aerial** (`<leader>o`) | Persystentny panel, widac wszystko |
| Znam nazwe symbolu, chce szybko skoczyc | **Namu** (`<leader>ss`) | Fuzzy search jest szybszy |
| Eksploruje nieznany plik | **Aerial** | Widze hierarchie klas/metod |
| Szukam symbolu ale nie pamietam nazwy | **Namu** | Fuzzy match na czesci nazwy |
| Nawiguję po Vue SFC (template/script) | **Aerial** | LSP backend radzi sobie z SFC |
| Chce znalezc symbol w innym pliku | **Namu** (`<leader>sw`) | Workspace symbols |
| Chce szybko skakac miedzy metodami | `{` / `}` | Jednym klawiszem, bez otwierania czegokolwiek |

### Symbol navigation w szerszym kontekscie

Porownanie ze wszystkimi narzedziani nawigacji, ktore poznales:

```
                   gd (definition)
                   gr (references)
  Konkretny        gp (peek)
  symbol ────►     gri (implementation)
                   grt (type)

  Cala             <leader>o  (Aerial panel)
  struktura ───►   <leader>O  (Aerial nav)
  pliku            <leader>ss (Namu fuzzy)

  Szybki           { / } (prev/next symbol)
  skok ────►       <leader>sw (workspace symbols)
```

## Cwiczenia

### Cwiczenie 1: Aerial -- pierwsze otwarcie

Otworz `exercises/python/data_processing.py`:

1. Nacisnij `<leader>o` -- otwiera sie panel Aerial po prawej stronie
2. Przejrzyj strukture:
   - Enum `FileFormat`
   - Dataclass `ColumnSchema` z metoda `validate`
   - Dataclass `DataSchema` z `get_column`, `column_names`, `required_columns`
   - Class `DataLoader` z `load`, `load_string`, `_parse_csv` itd.
   - Abstractclass `BaseTransformer` z `transform`
   - Klasy: `ColumnRenamer`, `TypeCaster`, `ColumnFilter`, `RowFilter`, `ValueMapper`
   - `DataValidator` z `validate`, `_validate_row`, `is_valid`
   - `Pipeline` z `process`, `process_stream`
   - Funkcje: `normalize_whitespace`, `extract_emails`, `flatten_dict` itd.
3. Zamknij panel: `<leader>o` (toggle)

### Cwiczenie 2: Nawigacja w panelu Aerial

Otworz `exercises/python/data_processing.py` i wlacz Aerial (`<leader>o`):

1. Przejdz kursorem do panelu Aerial (Ctrl+w + l, lub kliknij)
2. Nawiguj `j`/`k` po liscie symboli
3. Nacisnij `p` na `Pipeline` -- kursor w edytorze przewinie sie do `Pipeline`,
   ale Ty zostaniesz w panelu Aerial (scroll/preview)
4. Nacisnij Enter na `process` -- skaczesz do metody `process()` w edytorze
5. Zwroc uwage ze kursor jest wycentrowany (`zz`)
6. Wroc do Aerial i uzyj `H` -- zwin cale drzewo (widac tylko top-level symbole)
7. Uzyj `L` -- rozwin wszystko
8. Uzyj `o` na klasie `DataLoader` -- toggle zwinięcia/rozwiniecia
9. Zamknij: `q`

### Cwiczenie 3: Skakanie miedzy symbolami { / }

Kontynuuj w `exercises/python/data_processing.py`:

1. Idz na poczatek pliku (`gg`)
2. Nacisnij `}` -- skaczesz do nastepnego symbolu (pierwsza klasa/funkcja)
3. Powtarzaj `}` -- przeskakujesz przez kolejne klasy i funkcje
4. Uzywaj `{` zeby wrocic do poprzedniego symbolu
5. Zwroc uwage ze `{`/`}` przeskakuja po top-level symbolach (klasy, funkcje),
   nie po pojedynczych metodach wewnatrz klas
6. Policz ile nacisniec `}` potrzebujesz zeby przejsc od `FileFormat` do `Pipeline`

### Cwiczenie 4: Aerial Navigation (floating)

Otworz `exercises/python/data_processing.py`:

1. Nacisnij `<leader>O` (duze O) -- otworzy sie floating mini-map
2. Nawiguj po liscie symboli
3. Wybierz `flatten_dict` (Enter) -- skaczesz do tej funkcji
4. Nacisnij `<leader>O` ponownie -- floating mini-map z aktualnym podswietleniem
5. Porownaj z `<leader>o` -- Aerial Navigation jest szybsze (otwierasz, wybierasz, zamykasz),
   panel Aerial jest lepszy do ciaglego podgladu struktury

### Cwiczenie 5: Namu -- fuzzy search

Otworz `exercises/python/data_processing.py`:

1. Nacisnij `<leader>ss` -- otwiera sie Namu
2. Wpisz `val` -- powinny pojawic sie:
   - `DataValidator`
   - `validate`
   - `_validate_row`
   - `is_valid`
   - `ValidationError`
3. Wybierz `DataValidator` (Enter) -- skaczesz do definicji klasy
4. Nacisnij `<leader>ss` ponownie
5. Wpisz `proc` -- powinny pojawic sie `process`, `process_stream`
6. Wybierz `process_stream` -- skaczesz do metody
7. Zwroc uwage na podglad (preview) w dolnej czesci Namu -- widzisz kod
   zanim jeszcze do niego skoczysz

### Cwiczenie 6: Namu -- hierarchia (tree mode)

Otworz `exercises/python/data_processing.py`:

1. Nacisnij `<leader>ss`
2. Wpisz `load` -- zobaczysz:
   - `DataLoader` -> `load` (metoda wewnatrz klasy)
   - `DataLoader` -> `load_string`
3. Zwroc uwage na tree display -- nazwy sa wciete, widac ze `load` nalezy do `DataLoader`
4. Wybierz `load_string` i skocz do niego

### Cwiczenie 7: Aerial w TypeScript

Otworz `exercises/typescript/api-service.ts`:

1. Nacisnij `<leader>o` -- Aerial uzywa LSP backend dla TypeScript
2. Sprawdz strukture:
   - `RequestConfig` (interface)
   - `HttpMethod` (type)
   - `Interceptor` (type)
   - `ApiError` (class) z `constructor`
   - `ApiService` (class) z polami i metodami:
     - `baseUrl`, `defaultHeaders`, `interceptors`, `timeout`
     - `addInterceptor`, `request`, `getUsers`, `getUser`, `createUser` itd.
3. Zwroc uwage ze prywatna metoda `request` i `buildQuery` tez sa widoczne
4. Uzyj `{`/`}` do nawigacji po metodach `ApiService`
5. Zamknij Aerial (`<leader>o`)

### Cwiczenie 8: Namu w TypeScript

Kontynuuj w `exercises/typescript/api-service.ts`:

1. Nacisnij `<leader>ss`
2. Wpisz `get` -- zobaczysz:
   - `getUsers`, `getUser`, `getOrders`
   - Moze tez `getProducts`
3. Wybierz `getOrders` -- skaczesz do metody
4. Nacisnij `<leader>ss` ponownie
5. Wpisz `upload` -- zobaczysz `uploadFile`
6. Wpisz `build` -- zobaczysz `buildQuery` (prywatna metoda)

### Cwiczenie 9: Workspace Symbols

Jesli masz otwartych kilka plikow:

1. Otworz co najmniej 2 pliki:
   - `exercises/python/data_processing.py`
   - `exercises/python/models.py`
2. Nacisnij `<leader>sw` -- Namu workspace symbols
3. Wpisz `User` -- zobaczysz `User` z `models.py` i moze inne typy z roznych plikow
4. Wybierz `User` z `models.py` -- Neovim przeniesie Cie do tego pliku i symbolu
5. To jest odpowiednik "Go to Symbol in Workspace" z VSCode

### Cwiczenie 10: Aerial refresh (Vue)

Otworz `exercises/vue/UserCard.vue`:

1. Nacisnij `<leader>o` -- Aerial otwiera sie z symbolami Vue
2. Sprawdz co widac:
   - Symbole z `<script setup>`: `UserProfile` (interface), `props`, `emit`,
     `isFollowing`, `isLoading`, `displayName`, `initials`, `onFollow`, `onMessage`
   - Tagi HTML powinny byc odfiltrowane
3. Jesli Aerial nie pokazuje symboli (Vue LSP moze potrzebowac chwili):
   - Nacisnij `<leader>or` -- refresh symboli
   - Poczekaj 1-2 sekundy
   - Symbole powinny sie pojawic

## Cwiczenie bonusowe

Wykonaj pelna nawigacje po `exercises/python/data_processing.py` uzywajac ROZNYCH narzedzi:

1. Otwoz Aerial (`<leader>o`) i przejrzyj cala strukture pliku
2. W Aerial nawiguj do `Pipeline` i skocz do niej (Enter)
3. Zamknij Aerial (`<leader>o`)
4. Uzyj `}` zeby przejsc do nastepnego symbolu po `Pipeline` (powinno byc
   `normalize_whitespace` lub inna helper function)
5. Uzyj Namu (`<leader>ss`) i wpisz `flat` -- skocz do `flatten_dict`
6. W `flatten_dict` uzyj `gd` na `items.extend` -- sprawdz definicje
7. Wroc `Ctrl+O`
8. Uzyj `<leader>O` (Aerial Navigation) -- skocz do `DataLoader`
9. W `DataLoader` uzyj `{` zeby przejsc do poprzedniej klasy

**Cel**: plynne przelaczanie miedzy Aerial, Namu, `{`/`}` i nawigacja LSP.
Kazde narzedzie ma swoje zastosowanie -- Aerial do przegladania, Namu do szukania,
`{`/`}` do szybkich skokow, `gd`/`gr` do sledzenia zaleznosci.

## Podsumowanie

### Nauczone komendy

| Komenda | Opis |
|---------|------|
| `<leader>o` | Toggle Aerial outline panel |
| `<leader>O` | Aerial Navigation (floating mini-map) |
| `{` | Poprzedni symbol |
| `}` | Nastepny symbol |
| `<leader>or` | Refresh symboli Aerial |
| `<leader>ss` | Namu Symbols (fuzzy search z preview) |
| `<leader>sw` | Workspace Symbols (szukaj we wszystkich plikach) |
| `<leader>st` | Treesitter Symbols (alternatywa) |

### Klawisze w panelu Aerial

| Klawisz | Opis |
|---------|------|
| `j` / `k` | Nawigacja po symbolach |
| `CR` (Enter) | Skocz do symbolu |
| `p` | Preview (scroll edytora bez skakania) |
| `o` | Toggle zwinięcie/rozwinięcie |
| `h` / `l` | Zwin / rozwin galaz |
| `H` / `L` | Zwin / rozwin wszystko |
| `q` | Zamknij panel |

### Konfiguracja uzyta w tej lekcji

| Element | Wartosc / Opis |
|---------|---------------|
| Aerial backends | Python: treesitter, Vue: LSP, TS: LSP |
| `default_unfold_level` | `1` -- klasy z metodami widoczne |
| `post_jump_cmd` | `"normal! zz"` -- centrowanie po skoku |
| Vue filter | Odfiltrowuje tagi HTML z outline |
| Namu display mode | `tree` -- hierarchiczna struktura |
| Namu `row_position` | `top10` -- wyniki u gory ekranu |

### Co dalej?

W **lekcji 25** poznasz **Trouble i Dropbar** -- Trouble daje Ci panel z diagnostyka
calego projektu (nie tylko biezacego pliku), a Dropbar wyswietla breadcrumbs --
sciezke kontekstu (plik > klasa > metoda) na gorze kazdego okna.
