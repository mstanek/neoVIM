# Cwiczenie 15: Buffers

> Powiazana lekcja: `lessons/15-buffers.md`

## Instrukcje
- `Shift+H` / `Shift+L` -- poprzedni / nastepny buffer
- `Ctrl+T` / `Ctrl+Y` -- cycle bufferow (Kitty remapping)
- `Ctrl+P` -- smart picker (Snacks.picker.smart)
- `<leader>bd` -- smart delete buffer
- `<leader>fb` -- Telescope buffer picker z preview
- `Ctrl+^` -- alternate buffer (przelaczanie miedzy dwoma plikami)
- `:ls` -- lista bufferow, `:b nazwa` -- przelacz po nazwie

## Cwiczenie 1: Budowanie workspace'u

Otworz kolejno 5 plikow uzywajac `Ctrl+P` (smart picker). Po kazdym otwarciu
sprawdz bufferline -- ile zakladek widzisz:

1. `exercises/python/calculator.py`
2. `exercises/typescript/api-service.ts`
3. `exercises/vue/UserCard.vue`
4. `exercises/python/models.py`
5. `exercises/typescript/interfaces.ts`

Gdy masz 5 bufferow, uzyj `:ls` i porownaj liste z bufferline u gory ekranu.
Zauwaz numery bufferow -- przyda Ci sie w nastepnych cwiczeniach.

## Cwiczenie 2: Nawigacja sekwencyjna

Majac 5 otwartych bufferow z cwiczenia 1:

1. Zacznij od pierwszego buffera (`calculator.py`)
2. Uzyj `Shift+L` czterokrotnie -- przejdz do ostatniego buffera
3. Uzyj `Shift+H` czterokrotnie -- wroc do pierwszego
4. Teraz zrob to samo uzywajac `Ctrl+T` / `Ctrl+Y`
5. Porownaj ergonomie -- ktory sposob bardziej Ci pasuje?

## Cwiczenie 3: Przelaczanie po nazwie

Majac otwarte buffery:

1. Wpisz `:b api` i nacisnij `Enter` -- przejdziesz do `api-service.ts`
2. Wpisz `:b calc` i `Enter` -- przejdziesz do `calculator.py`
3. Wpisz `:b Card` i `Enter` -- przejdziesz do `UserCard.vue`
4. Wpisz `:b 3` (lub numer z `:ls`) -- przejdziesz do buffera nr 3

Zauwaz, ze `:b` robi partial match -- nie musisz wpisywac pelnej nazwy.

## Cwiczenie 4: Alternate buffer w praktyce

Symuluj typowy workflow: edytujesz komponent i jego interfejsy jednoczesnie.

1. Otworz `exercises/typescript/api-service.ts`
2. Przejdz do `exercises/typescript/interfaces.ts` (uzyj `Shift+L` lub `Ctrl+P`)
3. Nacisnij `Ctrl+^` -- wroci do `api-service.ts`
4. Nacisnij `Ctrl+^` -- wroci do `interfaces.ts`
5. Dodaj komentarz w jednym pliku, `Ctrl+^`, dodaj w drugim, `Ctrl+^`
6. Ten ping-pong miedzy dwoma plikami to jedna z najczestszych operacji

## Cwiczenie 5: Telescope buffer picker z filtrowaniem

1. Otworz co najmniej 6 bufferow (dodaj `exercises/python/utils.py` i `exercises/vue/DataTable.vue`)
2. Nacisnij `<leader>fb` -- otworzy sie Telescope z lista bufferow
3. Wpisz `.py` -- zostana tylko buffery Pythonowe
4. Wyczysc i wpisz `.ts` -- buffery TypeScript
5. Wyczysc i wpisz `User` -- buffery z "User" w nazwie
6. Wybierz jeden i otworz w split pionowym: `Ctrl+v` zamiast `Enter`

## Cwiczenie 6: Selektywne zamykanie bufferow

Majac 6+ otwartych bufferow:

1. Przejdz do buffera `models.py` (uzywajac dowolnej metody)
2. `<leader>bd` -- zamknij go. Zauwaz, ze przelaczyles sie na sasiedni buffer
3. Przejdz do `utils.py` i tez go zamknij: `<leader>bd`
4. Sprawdz `:ls` -- powinny zostac 4 buffery
5. Przejdz do `DataTable.vue`, nacisnij `<leader>bd`
6. Koncowy stan: 3 buffery. Zweryfikuj bufferline

## Cwiczenie 7: Stany bufferow -- modyfikacja

1. Otworz `exercises/python/calculator.py`
2. Dodaj pusty komentarz na gorze: `# TODO: refactor`
3. Spójrz na bufferline -- powinien byc widoczny indicator `[+]` (modified)
4. Uzyj `:ls` -- zauwaz `+` przy tym buforze
5. Zapisz: `:w` -- indicator zniknie
6. Otworz inny plik, zrob zmiane (bez zapisu), wroc `Ctrl+^`
7. Sprawdz `:ls` -- ktore buffery maja `+`?

## Cwiczenie bonusowe

**Scenariusz: przeglad kodu w trzech jezykach**

Pracujesz nad featurem, ktory wymaga zmian w Python, TypeScript i Vue:

1. Otworz te 3 pliki (kazdy z innego jezyka):
   - `exercises/python/data_processing.py`
   - `exercises/typescript/store.ts`
   - `exercises/vue/LoginForm.vue`
2. Dodaj w kazdym komentarz `// TODO: feature-123` (lub `#` dla Python)
3. Uzywajac TYLKO `Ctrl+^` i `Shift+H/L`, przejdz miedzy wszystkimi trzema
4. Zapisz wszystkie naraz: `:wa` (write all)
5. Teraz otworz `<leader>fb` i z poziomu Telescope otworz kazdy plik w nowym split (`Ctrl+v`)
6. Zamknij wszystkie splity oprocz jednego: `Ctrl+w o`
7. Zamknij 2 z 3 bufferow uzywajac `<leader>bd`
8. Sprawdz `:ls` -- powinien zostac 1 buffer
