# Cwiczenie 25: Trouble i Dropbar

> Powiazana lekcja: `lessons/25-trouble-dropbar.md`

## Instrukcje
- `<leader>xx` -- Trouble: diagnostyki calego projektu
- `<leader>xX` -- Trouble: diagnostyki biezacego bufora
- `<leader>xs` -- Trouble: symbole pliku
- `<leader>xl` -- Trouble: LSP definicje/referencje
- `<leader>xL` -- Trouble: location list
- `<leader>xq` -- Trouble: quickfix list
- `<leader>dp` -- Dropbar Pick (nawigacja breadcrumbs)
- W Trouble: `j`/`k` nawigacja, `Enter` skocz, `o` skocz+zamknij,
  `q` zamknij, `Tab`/`S-Tab` nawigacja z preview

## Cwiczenie 1: Trouble -- porownanie project vs buffer

Otworz dwa pliki z bledami:
- `exercises/python/broken.py`
- `exercises/typescript/broken.ts`

Teraz:
1. Nacisnij `<leader>xx` -- Trouble: diagnostyki calego projektu
2. Sprawdz grupowanie -- bledy z kazdego pliku sa w osobnej sekcji
3. Policz ile bledow jest lacznie
4. Zamknij: `q`
5. Przejdz do bufora `broken.py`
6. Nacisnij `<leader>xX` -- Trouble: tylko biezacy bufor
7. Sprawdz ze widac TYLKO bledy z `broken.py`
8. Zamknij: `q`

## Cwiczenie 2: Trouble -- nawigacja z preview

Otworz `exercises/python/broken.py`:

1. Nacisnij `<leader>xX` -- Buffer Diagnostics
2. Nacisnij `Tab` na pierwszym bledzie -- preview (podglad w edytorze)
3. Nacisnij `Tab` ponownie -- nastepny blad z preview
4. Nacisnij `S-Tab` -- poprzedni blad z preview
5. Wybierz blad `add_numbers("hello", "world")` i nacisnij `o` -- skaczesz
   do bledu i Trouble sie zamknie
6. Porownaj z `Enter` -- `Enter` skacze ale NIE zamyka Trouble

## Cwiczenie 3: Trouble Symbols vs Aerial

Otworz `exercises/python/data_processing.py`:

1. Nacisnij `<leader>xs` -- Trouble Symbols
2. Przejrzyj liste symboli -- klasy, funkcje, metody
3. Zamknij: `q`
4. Nacisnij `<leader>o` -- Aerial panel
5. Porownaj:
   - Trouble: flat list, mozna szukac
   - Aerial: drzewo hierarchiczne, persystentny panel
6. Zamknij Aerial: `<leader>o`

## Cwiczenie 4: Trouble LSP References

Otworz `exercises/typescript/interfaces.ts`:

1. Ustaw kursor na `User` (interface, ~linia 21)
2. Nacisnij `<leader>xl` -- LSP Definitions/References
3. Trouble pokaze wszystkie miejsca gdzie `User` jest uzywany:
   - Definicja w `interfaces.ts`
   - Import i uzycie w `api-service.ts`
   - Import i uzycie w `store.ts`
   - Moze uzycia w komponentach Vue
4. Nawiguj po wynikach -- Enter na referencji w `api-service.ts`
5. Sprawdz kontekst uzycia
6. Wroc `Ctrl+O`

## Cwiczenie 5: Trouble Quickfix

Otworz `exercises/python/data_processing.py`:

1. Ustaw kursor na `DataSchema` (~linia 53)
2. Nacisnij `gr` -- referencje trafia do quickfix
3. Teraz nacisnij `<leader>xq` -- Trouble pokaze quickfix list
4. Nawiguj po wynikach -- te same referencje ale w ladniejszym panelu
5. Enter na jednym z wynikow -- skaczesz do niego
6. Zamknij Trouble: `q`

## Cwiczenie 6: Dropbar -- obserwacja breadcrumbs

Otworz `exercises/python/models.py`:

1. Spojrz na gore okna -- breadcrumb pokazuje nazwe pliku
2. Nawiguj do metody `full_name` w klasie `User` (~linia 47)
3. Breadcrumb: `models.py > User > full_name`
4. Nawiguj do metody `reduce_stock` w klasie `Product` (~linia 88)
5. Breadcrumb: `models.py > Product > reduce_stock`
6. Nawiguj do klasy `Order` (~linia 116)
7. Breadcrumb: `models.py > Order`
8. Nawiguj do `Order.Meta` -- breadcrumb powinien sie zmienic

## Cwiczenie 7: Dropbar Pick -- interaktywna nawigacja

Otworz `exercises/python/calculator.py`:

1. Nawiguj gdziekolwiek wewnatrz klasy `Calculator`
2. Nacisnij `<leader>dp` -- Dropbar Pick
3. Kliknij (lub nawiguj) na segment z nazwa klasy (`Calculator`)
4. Powinien pojawic sie dropdown z metodami:
   `add`, `subtract`, `multiply`, `divide`, `power`, `sqrt`, `chain` itd.
5. Wybierz `sqrt` -- skaczesz do metody `sqrt`
6. Nacisnij `<leader>dp` ponownie
7. Wybierz segment plikowy -- dropdown z top-level symbolami

## Cwiczenie 8: Dropbar w Vue SFC

Otworz `exercises/vue/LoginForm.vue`:

1. Nawiguj do `<script setup>` -- breadcrumb zmieni sie
2. Nawiguj do computed `isEmailValid` (~linia 42)
3. Breadcrumb powinien pokazywac kontekst: plik > symbol
4. Nawiguj do `<template>` sekcji
5. Breadcrumb zmieni sie -- inne segmenty, kontekst HTML/Vue
6. Porownaj breadcrumbs w `<script>` vs `<template>`

## Cwiczenie bonusowe

Pelny workflow review uzywajac WSZYSTKICH narzedzi z modulu 4:

1. Otworz `exercises/python/broken.py` i `exercises/typescript/broken.ts`
2. `<leader>xx` -- Trouble: przejrzyj wszystkie bledy w projekcie
3. Enter na bledzie w `broken.ts` -- skaczesz do pliku
4. Dropbar: sprawdz breadcrumb -- w jakiej funkcji/klasie jest blad?
5. `K` -- hover na blednym symbolu
6. `<leader>ca` -- sprawdz code action
7. `<leader>xx` -- wroc do Trouble
8. Enter na bledzie w `broken.py` -- skaczesz do Python
9. `<leader>o` -- Aerial: przejrzyj strukture pliku
10. `<leader>ss` + wpisz nazwe funkcji z bledem -- skocz do niej przez Namu
11. `]d` -- nawiguj do konkretnego bledu w tej funkcji
12. `<leader>ld` -- pelna diagnostyka
13. Zamknij Aerial (`<leader>o`), zamknij Trouble (`q`)

Cel: polaczenie Trouble (co jest zle?), Dropbar (gdzie jestem?),
Aerial/Namu (jak sie poruszac?) i LSP (jak naprawic?) w jeden workflow.
