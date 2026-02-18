# Cwiczenie 22: LSP diagnostyka

> Powiazana lekcja: `lessons/22-lsp-diagnostyka.md`

## Instrukcje
- `K` -- Hover (dokumentacja, typ, sygnatura symbolu)
- `gK` -- Signature Help (parametry biezacego wywolania)
- `<leader>ld` -- Line Diagnostics (pelny opis bledow na linii)
- `]d` -- Nastepny diagnostik
- `[d` -- Poprzedni diagnostik
- Sign column: ikony 󰅚 (error), 󰀪 (warn), 󰋽 (info), 󰌶 (hint)
- Virtual text: skrocony opis bledu na koncu linii
- Undercurl: podkreslenie tylko dla ERROR

## Cwiczenie 1: Hover na roznych typach symboli

Otworz `exercises/python/models.py`:

1. Ustaw kursor na `@dataclass` dekorator (~linia 25) i nacisnij `K`
   - Hover pokaze dokumentacje dekoratora `dataclass`
2. Ustaw kursor na `Decimal` (import, ~linia 11) i nacisnij `K`
   - Hover pokaze opis klasy `Decimal` z modulu `decimal`
3. Ustaw kursor na `uuid4` (import, ~linia 14) i nacisnij `K`
   - Hover pokaze sygnature `uuid4()`
4. Ustaw kursor na metode `reduce_stock` (~linia 88) i nacisnij `K`
   - Hover pokaze sygnature + docstring z opisem wyjatku
5. Ustaw kursor na property `is_in_stock` (~linia 84) i nacisnij `K`
   - Hover pokaze typ zwracany `bool`

## Cwiczenie 2: Hover w TypeScript -- generyki i typy

Otworz `exercises/typescript/utils.ts`:

1. Ustaw kursor na nazwie `debounce` (~linia 12) i nacisnij `K`
   - Hover pokaze pelna sygnature z generykiem `T extends (...args) => unknown`
2. Ustaw kursor na `deepClone` (~linia 39) i nacisnij `K`
   - Hover pokaze sygnature `deepClone<T>(obj: T): T`
3. Ustaw kursor na `Parameters` w `Parameters<T>` (~linia 15) i nacisnij `K`
   - Hover pokaze wbudowany utility type TypeScript
4. Ustaw kursor na `ReturnType` (~linia 16) i nacisnij `K`
   - Porownaj z `Parameters` -- oba sa utility types

## Cwiczenie 3: Nawigacja po diagnostykach w broken.ts

Otworz `exercises/typescript/broken.ts`:

1. Idz na poczatek pliku (`gg`)
2. Nacisnij `]d` -- pierwszy blad (missing `email`, ~linia 23)
3. Nacisnij `<leader>ld` -- przeczytaj pelna wiadomosc
4. Nacisnij `]d` -- nastepny blad (type mismatch, ~linia 34)
5. Nacisnij `K` na blednym symbolu -- hover pokaze oczekiwany typ
6. Kontynuuj `]d` az do konca pliku
7. Wroc na poczatek: `[d` wielokrotnie
8. Policz ile bledow przeskoczyles -- powinienes miec okolo 9

## Cwiczenie 4: Diagnostyka w kodzie Vue

Otworz `exercises/vue/broken.vue`:

1. Sprawdz sign column -- szukaj ikon 󰅚 i 󰀪
2. Nawiguj `]d` przez bledy
3. Dla kazdego bledu:
   a. Sprawdz virtual text na koncu linii
   b. Nacisnij `<leader>ld` -- przeczytaj pelny opis
   c. Zwroc uwage na zrodlo -- vue_ls lub ts_ls?
4. Porownaj styl diagnostyk Vue z Python/TypeScript

## Cwiczenie 5: Rozroznianie typow bledow

Otworz `exercises/python/broken.py`:

1. Nawiguj po bledach uzywajac `]d` i dla kazdego okresl kategorie:
   - **Brakujacy import**: `math` (~linia 20), `config` (~linia 26)
   - **Bledne argumenty**: `greet("Alice")` (~linia 36)
   - **Bledne typy**: `add_numbers("hello", "world")` (~linia 44)
   - **Nieistniejacy atrybut**: `user.phone` (~linia 54)
   - **Bledny return type**: `return None` (~linia 62)
   - **Nieosiagalny kod**: `print(...)` (~linia 70)
   - **Unbound variable**: `total` (~linia 79)
   - **Bledny key type**: `scores[42]` (~linia 84)
2. Ktore z nich to bledy logiczne, a ktore to literowki?

## Cwiczenie 6: Hover na zdrowym kodzie -- eksploracja typow

Otworz `exercises/typescript/store.ts`:

1. Ustaw kursor na `computed` (~linia 10, import) i nacisnij `K`
2. Ustaw kursor na `reactive` w tym samym imporcie i nacisnij `K`
3. Porownaj -- `computed` vs `reactive` -- rozne sygnatury
4. Znajdz `ComputedRef` w imporcie i nacisnij `K` -- to typ generyczny
5. Ustaw kursor na `Ref` i nacisnij `K` -- porownaj z `ComputedRef`
6. Te informacje pomagaja zrozumiec Vue reactivity bez czytania dokumentacji

## Cwiczenie 7: Signature Help w praktyce

Otworz `exercises/python/models.py`:

1. Idz na koniec pliku, wejdz w Insert (`o`)
2. Wpisz `user = User(` -- powinien pojawic sie signature help
3. Jesli nie -- nacisnij `gK` w trybie Normal
4. Sprawdz parametry: `username`, `email`, `first_name` itd.
5. Nacisnij `Esc` i cofnij (`u`)
6. Powtorz z `Product(` -- inne parametry, inna sygnatura
7. `Esc` + `u`

## Cwiczenie bonusowe

Otworz `exercises/typescript/broken.ts` i wykonaj pelny audit:

1. `gg` -- idz na poczatek
2. Dla kazdego bledu (`]d`):
   a. Nacisnij `<leader>ld` -- zapisz w pamieci kod bledu (np. `ts(2322)`)
   b. Nacisnij `K` na blednym symbolu -- jaki typ jest oczekiwany vs dostarczony?
   c. Okresl czy blad jest naprawialny przez code action (lekcja 23)
      czy wymaga recznej zmiany
3. Pogrupuj bledy tematycznie:
   - Brakujace pola w obiektach
   - Type mismatch (przypisanie zlego typu)
   - Dostepu do nieistniejacych wlasciwosci
   - Problemy z async/await
   - Modyfikacja readonly
4. Ktory typ bledu jest najczestszy?
