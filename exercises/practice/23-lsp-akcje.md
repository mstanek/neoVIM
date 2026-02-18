# Cwiczenie 23: LSP akcje

> Powiazana lekcja: `lessons/23-lsp-akcje.md`

## Instrukcje
- `<leader>ca` / `gra` -- Code Action (quick fix, refactor, import)
- `<leader>rn` / `grn` -- Rename (zmiana nazwy w calym projekcie)
- `<leader>cf` -- Format Buffer (formatowanie przez conform)
- `<leader>th` -- Toggle Inlay Hints (typy inline on/off)
- `Tab` / `S-Tab` -- nawigacja po sugestiach completion
- `CR` (Enter) -- potwierdz sugestie
- `C-Space` -- wywolaj completion recznie
- `C-e` -- zamknij menu completion
- `C-b` / `C-f` -- scroll documentation popup

## Cwiczenie 1: Code actions w TypeScript

Otworz `exercises/typescript/broken.ts`:

1. Nawiguj do bledu "Property 'email' is missing" (~linia 23)
2. Nacisnij `<leader>ca` -- sprawdz dostepne akcje
3. Jesli jest opcja dodania brakujacego pola -- uzyj jej
4. Jesli nie -- napraw recznie: dodaj `email: "admin@example.com"`
5. Nawiguj `]d` do nastepnego bledu i powtorz: `<leader>ca`
6. Dla kazdego bledu sprawdz czy LSP proponuje quick fix

## Cwiczenie 2: Rename interfejsu i propagacja zmian

Otworz `exercises/typescript/interfaces.ts`:

1. Ustaw kursor na nazwie `FilterOptions` (~linia 113)
2. Nacisnij `<leader>rn`
3. Zmien na `FilterCriteria` i potwierdz Enter
4. Sprawdz:
   - Definicja interfejsu zmienila nazwe
   - Czy `QueryParams` tez sie zaktualizowalo (pole `filters?: FilterOptions<T>[]`)?
   - Sprawdz w `api-service.ts` czy uzycia tez sie zmienily
5. Cofnij zmiany: `u` wielokrotnie

## Cwiczenie 3: Rename metody w klasie Python

Otworz `exercises/python/calculator.py`:

1. Ustaw kursor na nazwie metody `memory_store` (~linia 172)
2. Nacisnij `<leader>rn`
3. Zmien na `save_to_memory`
4. Sprawdz czy zmienilo sie rowniez:
   - Definicja metody
   - Wszelkie uzycia `self.memory_store` w pliku
5. Cofnij (`u`) -- zachowaj oryginalny plik

## Cwiczenie 4: Rename property w Vue

Otworz `exercises/vue/LoginForm.vue`:

1. Ustaw kursor na nazwie `isEmailValid` (~linia 42)
2. Nacisnij `<leader>rn`
3. Zmien na `emailIsValid`
4. Sprawdz czy zmienilo sie w:
   - Definicji `computed`
   - Template (jesli uzywane w `<template>`)
5. Cofnij (`u`)

## Cwiczenie 5: Formatowanie Python i TypeScript

Otworz `exercises/python/utils.py`:

1. Znajdz funkcje `format_currency` (~linia 21)
2. Dodaj celowo zle sformatowane linie na koncu pliku:
   ```python
   def    ugly(   a,b ,  c   ):
       x=a+b+    c
       return     x
   ```
3. Nacisnij `<leader>cf` -- black sformatuje plik
4. Sprawdz wynik: spacje znormalizowane, styl PEP 8
5. Cofnij (`u`)

Teraz otworz `exercises/typescript/utils.ts`:
1. Dodaj na koncu zle sformatowana funkcje
2. Nacisnij `<leader>cf` -- prettier sformatuje plik
3. Porownaj styl: Python (black) vs TypeScript (prettier)
4. Cofnij (`u`)

## Cwiczenie 6: Completion w kontekscie klas

Otworz `exercises/python/models.py`:

1. Idz na koniec klasy `Order` (przed nastepna definicja)
2. Wejdz w Insert (`o`) i wpisz `    def cancel(self):` + Enter
3. Wpisz `        self.status = OrderStatus.` -- completion uruchomi sie
4. Zobaczysz sugestie: `PENDING`, `CONFIRMED`, `SHIPPED`, `DELIVERED`, `CANCELLED`
5. Wybierz `CANCELLED` (Tab + Enter)
6. Nacisnij `Esc` i cofnij (`u`)

## Cwiczenie 7: Completion z importami

Otworz `exercises/typescript/store.ts`:

1. Idz na koniec pliku, wejdz w Insert (`o`)
2. Wpisz `const id: UUID = ` -- completion moze zaproponowac import `UUID`
3. Jesli nie -- wpisz `uuid` i sprawdz sugestie
4. Nacisnij `C-Space` jesli completion sie nie uruchomilo
5. Sprawdz ikony przy sugestiach -- rozne zrodla (LSP, buffer, snippety)
6. `Esc` + `u`

## Cwiczenie 8: Inlay Hints -- porownanie z/bez

Otworz `exercises/typescript/api-service.ts`:

1. Nacisnij `<leader>th` -- wlacz inlay hints
2. Przewin plik i sprawdz:
   - Czy widac typy zwracane metod?
   - Czy parametry maja annotacje typow inline?
   - Znajdz metode `buildQuery` -- jakie typy pokazuja inlay hints?
3. Nacisnij `<leader>th` -- wylacz inlay hints
4. Porownaj czytelnosc: z inlay hints masz wiecej informacji,
   ale kod moze byc trudniejszy do czytania

Otworz `exercises/python/utils.py`:
1. `<leader>th` -- wlacz inlay hints dla Python
2. Sprawdz czy Pyright pokazuje typy zmiennych bez jawnej annotacji
3. `<leader>th` -- wylacz

## Cwiczenie bonusowe

Napraw 3 bledy w `exercises/typescript/broken.ts` uzywajac ROZNYCH technik:

1. **Blad 1** -- missing property (`]d` do bledu):
   - `<leader>ca` -- szukaj quick fix
   - Jesli nie ma -- napraw recznie, potem `<leader>cf` zeby sformatowac

2. **Blad 2** -- type mismatch:
   - `K` na blednym symbolu -- sprawdz oczekiwany typ
   - Napraw wartosc, `<leader>cf`

3. **Blad 3** -- dowolny inny blad:
   - `<leader>ld` -- pelna diagnostyka
   - `<leader>ca` -- sprawdz code action
   - Napraw, zapisz (`:w` -- format-on-save)
   - `<leader>xX` -- Trouble buffer: sprawdz czy blad zniknal

Workflow: `]d` -> `<leader>ld` -> `<leader>ca` -> napraw -> `:w` -> `]d`
