# Cwiczenie 21: LSP nawigacja

> Powiazana lekcja: `lessons/21-lsp-nawigacja.md`

## Instrukcje
- `gd` -- Go to Definition (skocz do definicji symbolu)
- `gr` / `grr` -- References (znajdz wszystkie uzycia)
- `gp` -- Peek Definition (podglad w floating window)
- `gri` -- Go to Implementation (interfejs -> implementacja)
- `grt` -- Type Definition (zmienna -> definicja jej typu)
- `grD` -- Declaration (skocz do deklaracji)
- `Ctrl+O` -- Jumplist back (wroc do poprzedniej pozycji)
- `Ctrl+I` -- Jumplist forward (przejdz do nastepnej pozycji)
- Document Highlight -- automatyczne podswietlenie symbolu (CursorHold)

## Cwiczenie 1: Nawigacja po importach w Python

Otworz `exercises/python/utils.py`:

1. Ustaw kursor na `wraps` w imporcie z `functools` (~linia 15)
2. Nacisnij `gd` -- przejdziesz do definicji `wraps` w standardowej bibliotece
3. Wroc `Ctrl+O`
4. Ustaw kursor na `TypeVar` w imporcie z `typing` (~linia 16)
5. Nacisnij `gd` -- przejdziesz do definicji `TypeVar`
6. Wroc `Ctrl+O`
7. Powtorz z `hashlib` (~linia 9) -- zobaczysz zrodlo modulu `hashlib`

## Cwiczenie 2: References na typach w models.py

Otworz `exercises/python/models.py`:

1. Ustaw kursor na klasie `Product` (~linia 63)
2. Nacisnij `gr` -- zobaczysz liste wszystkich miejsc, gdzie `Product` jest uzywany
3. Powinienes zobaczyc uzycie w `OrderItem.product` (~linia 101) i inne referencje
4. Przejdz do jednej referencji (Enter), przeczytaj kontekst
5. Wroc `Ctrl+O`
6. Teraz ustaw kursor na `OrderItem` (~linia 98)
7. Nacisnij `gr` -- sprawdz gdzie `OrderItem` jest uzywany (m.in. w `Order.items`)

## Cwiczenie 3: Peek na interfejsach TypeScript

Otworz `exercises/typescript/interfaces.ts`:

1. Ustaw kursor na `OrderItem` w interfejsie `Order` (~linia 59, pole `items`)
2. Nacisnij `gp` -- floating window z definicja `OrderItem`
3. Przeczytaj pola: `productId`, `productName`, `quantity`, `unitPrice`, `totalPrice`
4. Zamknij `q`
5. Ustaw kursor na `Address` (pole `shippingAddress` w `Order`)
6. Nacisnij `gp` -- podglad interfejsu `Address`
7. Zamknij `q` -- nie zmieniles pozycji kursora

## Cwiczenie 4: Lancuch definicji w api-service.ts

Otworz `exercises/typescript/api-service.ts`:

1. Znajdz metode `getUsers()` -- ustaw kursor na typie `User` w tym kontekscie
2. `gd` -- skaczesz do definicji `User` (moze byc w `interfaces.ts`)
3. W interfejsie `User` ustaw kursor na `Role`
4. `gd` -- skaczesz do definicji typu `Role` (union type)
5. Wroc dwukrotnie: `Ctrl+O` -> `Ctrl+O`
6. Powinienes byc z powrotem w `getUsers()`
7. `Ctrl+I` -> przeskakujesz do `User`, `Ctrl+I` -> do `Role`

## Cwiczenie 5: Type Definition vs Definition

Otworz `exercises/typescript/store.ts`:

1. Znajdz zmienna `state` w `useUserStore()` (~linia 47)
2. Ustaw kursor na `state` i nacisnij `gd` -- skoczysz do przypisania `reactive<UserState>`
3. Wroc `Ctrl+O`
4. Teraz nacisnij `grt` -- skoczysz do definicji typu `UserState` (interfejs)
5. Porownaj: `gd` prowadzi do przypisania, `grt` prowadzi do typu
6. Wroc `Ctrl+O`

## Cwiczenie 6: References cross-file

Otworz `exercises/typescript/interfaces.ts`:

1. Ustaw kursor na nazwie `ApiResponse` (~linia 87)
2. Nacisnij `gr` -- zobaczysz gdzie `ApiResponse` jest uzywany
3. Powinienes znalezc uzycia w `api-service.ts` (return type metody `request`)
4. Przejdz do referencji w `api-service.ts` (Enter)
5. W `api-service.ts` ustaw kursor na `PaginatedResponse`
6. Nacisnij `gr` -- sprawdz gdzie ten typ jest uzywany
7. Wroc do `interfaces.ts`: `Ctrl+O` wielokrotnie

## Cwiczenie 7: Document Highlight w utils.py

Otworz `exercises/python/utils.py`:

1. Ustaw kursor na parametrze `amount` w `format_currency()` (~linia 21)
2. Poczekaj chwile -- CursorHold podswietli `amount` wszedzie w tej funkcji
3. Policz podswietlone wystapienia (powinno byc w sygnaturze i w ciele funkcji)
4. Rusz kursor -- podswietlenie znika
5. Teraz ustaw kursor na `currency` i poczekaj -- zlokalizuj wszystkie uzycia
6. Porownaj z `gr` -- Document Highlight dziala w obrebie pliku, `gr` cross-file

## Cwiczenie bonusowe

Wykonaj pelna eksploracje `exercises/python/models.py` bez uzywania Ctrl+F ani /:

1. Ustaw kursor na `User` w klasie `Order` (~linia 119, pole `user: User`)
2. `gp` -- podejrzyj definicje `User` bez opuszczania `Order` (zamknij `q`)
3. `gd` -- skocz do definicji `User`
4. W `User` nacisnij `gr` na `full_name` -- kto uzywa tej property?
5. Wroc `Ctrl+O` do `User`
6. Ustaw kursor na `OrderStatus` w imporcie lub uzyciu
7. `gd` -- skocz do enum `OrderStatus`
8. `gr` -- sprawdz ile razy `OrderStatus` jest uzywany w projekcie
9. Wroc na poczatek: `Ctrl+O` wielokrotnie az bedziesz w `Order`

Cel: nawigacja wylacznie przez `gd`, `gr`, `gp` i jumplist -- zero wyszukiwania.
