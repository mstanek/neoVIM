# Cwiczenie 24: Aerial i Namu

> Powiazana lekcja: `lessons/24-aerial-namu.md`

## Instrukcje
- `<leader>o` -- Toggle Aerial outline panel (prawy panel)
- `<leader>O` -- Aerial Navigation (floating mini-map)
- `{` / `}` -- Poprzedni / nastepny symbol
- `<leader>or` -- Refresh symboli Aerial
- `<leader>ss` -- Namu Symbols (fuzzy search z podgladem)
- `<leader>sw` -- Workspace Symbols (szukaj we wszystkich otwartych plikach)
- `<leader>st` -- Treesitter Symbols (alternatywa)
- W panelu Aerial: `j`/`k` nawigacja, `Enter` skocz, `p` preview, `o` toggle,
  `h`/`l` zwin/rozwin, `H`/`L` zwin/rozwin wszystko, `q` zamknij

## Cwiczenie 1: Aerial -- struktura models.py

Otworz `exercises/python/models.py`:

1. Nacisnij `<leader>o` -- otwiera sie panel Aerial
2. Przejrzyj strukture. Powinienes zobaczyc:
   - Enum `OrderStatus` z wartosciami
   - Dataclass `User` z `Meta`, `__str__`, `full_name`, `create_superuser`, `deactivate`
   - Dataclass `Product` z `Meta`, `__str__`, `is_in_stock`, `reduce_stock`
   - Dataclass `OrderItem` z `__str__`, `total_price`
   - Dataclass `Order` z metodami
3. Przejdz do panelu Aerial (Ctrl+w l)
4. Nacisnij `H` -- zwin wszystko (widac tylko top-level klasy)
5. Nacisnij `l` na `User` -- rozwin tylko `User`
6. Nacisnij `L` -- rozwin wszystko z powrotem
7. Zamknij: `q`

## Cwiczenie 2: Aerial -- nawigacja z preview

Otworz `exercises/typescript/store.ts`:

1. Nacisnij `<leader>o` -- Aerial z symbolami TypeScript
2. Przejdz do panelu Aerial
3. Nawiguj do `useUserStore` i nacisnij `p` -- preview bez skakania
4. Nawiguj do `useCartStore` i nacisnij `p` -- preview drugiego store
5. Nawiguj do `fetchCurrentUser` i nacisnij Enter -- skaczesz do kodu
6. Sprawdz ze kursor jest wycentrowany na ekranie (efekt `post_jump_cmd`)
7. Zamknij Aerial: `<leader>o`

## Cwiczenie 3: Szybka nawigacja { / }

Otworz `exercises/python/utils.py`:

1. Idz na poczatek pliku (`gg`)
2. Nacisnij `}` -- skaczesz do pierwszego symbolu (funkcja `format_currency`)
3. Powtarzaj `}` -- przeskakujesz przez kolejne funkcje:
   `validate_email`, `generate_token`, `retry` itd.
4. Policz ile nacisniec `}` potrzebujesz do konca pliku
5. Wroc `{` wielokrotnie do `format_currency`
6. Porownaj z `Ctrl+d`/`Ctrl+u` -- `{`/`}` skacze po symbolach, nie po ekranach

## Cwiczenie 4: Aerial Navigation (floating)

Otworz `exercises/python/calculator.py`:

1. Nacisnij `<leader>O` (duze O) -- floating mini-map
2. Powinienes zobaczyc: `Operation`, `HistoryEntry`, `CalculatorError`,
   `DivisionByZeroError`, `Calculator` z metodami
3. Wybierz `Calculator` (Enter) -- skaczesz do klasy
4. Nacisnij `<leader>O` ponownie -- floating mini-map z nowym kontekstem
5. Wybierz metode `chain` -- skaczesz do niej
6. Porownaj z `<leader>o`: Navigation jest szybsze do jednorazowych skokow,
   panel Aerial lepszy do ciaglego podgladu

## Cwiczenie 5: Namu -- szukanie po czesci nazwy

Otworz `exercises/python/calculator.py`:

1. Nacisnij `<leader>ss`
2. Wpisz `mem` -- powinienes zobaczyc:
   - `memory_store`, `memory_recall`, `memory_clear`
3. Wybierz `memory_recall` (Enter) -- skaczesz do metody
4. Nacisnij `<leader>ss` ponownie
5. Wpisz `hist` -- powinienes zobaczyc: `HistoryEntry`, `history`, `clear_history`
6. Wybierz `clear_history` -- skaczesz do metody
7. Zwroc uwage na preview -- widzisz kod zanim skoczysz

## Cwiczenie 6: Namu -- hierarchia w TypeScript

Otworz `exercises/typescript/api-service.ts`:

1. Nacisnij `<leader>ss`
2. Wpisz `request` -- zobaczysz:
   - `ApiService` -> `request` (metoda prywatna)
   - `RequestConfig` (interfejs)
3. Zwroc uwage na tree display -- `request` jest wcieta pod `ApiService`
4. Wybierz metode `request` -- skaczesz do niej
5. Nacisnij `<leader>ss` i wpisz `build` -- `buildQuery` tez pod `ApiService`
6. Nacisnij `<leader>ss` i wpisz `error` -- `ApiError` na top-level

## Cwiczenie 7: Aerial w Vue SFC

Otworz `exercises/vue/DataTable.vue`:

1. Nacisnij `<leader>o` -- Aerial z symbolami Vue
2. Sprawdz co widac w panelu:
   - Interfejsy: `Column`, `SortState`
   - Props, emits, zmienne reaktywne
   - Computed properties i metody
   - Tagi HTML powinny byc odfiltrowane
3. Jesli Aerial jest pusty -- nacisnij `<leader>or` (refresh)
4. Nawiguj do computed property (np. `sortedData` lub `filteredData`) i skocz Enter
5. Zamknij Aerial

## Cwiczenie 8: Workspace Symbols -- szukanie miedzy plikami

Otworz co najmniej 3 pliki w osobnych buforach:
- `exercises/python/models.py` (`:e`)
- `exercises/python/calculator.py` (`:e`)
- `exercises/python/utils.py` (`:e`)

Teraz:
1. Nacisnij `<leader>sw` -- workspace symbols
2. Wpisz `Order` -- powinienes zobaczyc:
   - `OrderStatus` z `models.py`
   - `Order` z `models.py`
   - `OrderItem` z `models.py`
3. Wybierz `Order` -- Neovim przeniesie Cie do tego pliku i symbolu
4. Nacisnij `<leader>sw` ponownie
5. Wpisz `calc` -- `Calculator` z `calculator.py`
6. Przeskocz do niego

## Cwiczenie bonusowe

Nawigacja "slepa" po `exercises/typescript/store.ts` -- NIE uzywaj scrollowania
ani wyszukiwania (`/`). Uzyj TYLKO narzedzi symbol navigation:

1. `<leader>o` -- otworz Aerial i przejrzyj cala strukture pliku
2. `<leader>o` -- zamknij Aerial
3. `<leader>ss` + wpisz `cart` -- skocz do czegos zwiazanego z cart store
4. `}` -- przejdz do nastepnego symbolu
5. `{` -- wroc
6. `<leader>O` -- Aerial Navigation -- skocz do `useUserStore`
7. `<leader>ss` + `fetch` -- skocz do `fetchCurrentUser`
8. `gd` na `state` w ciele funkcji -- sprawdz definicje
9. `Ctrl+O` -- wroc

Cel: plynne przelaczanie miedzy Aerial, Namu i `{`/`}` bez uzywania
scrollowania czy wyszukiwania tekstowego.
