# Cwiczenie 17: Telescope

> Powiazana lekcja: `lessons/17-telescope.md`

## Instrukcje
- `<leader>ff` -- Find Files (szukaj plikow po nazwie)
- `<leader>fg` -- Live Grep (szukaj tresci w plikach, ripgrep)
- `<leader>fb` -- Buffers (lista otwartych bufferow z preview)
- `<leader>fh` -- Help Tags (dokumentacja Vim/pluginow)
- `<leader>fr` -- Recent Files (ostatnio otwierane)
- `<leader>fk` -- Keymaps (wszystkie skroty klawiszowe)
- `<leader>fs` -- Symbols/Aerial (funkcje, klasy w biezacym pliku)
- `<leader>sr` -- Search Resume (wznow ostatnie wyszukiwanie)
- `<leader>sw` -- Search Word (grep slowa pod kursorem)
- `<leader>sd` -- Search Diagnostics (bledy/warningi LSP)
- `<leader>/` -- Fuzzy search w biezacym pliku
- W Telescope: `Ctrl+v` split pionowy, `Ctrl+x` split poziomy, `Ctrl+u` czysc prompt

## Cwiczenie 1: Fuzzy matching -- znajdz pliki

Przetestuj inteligencje fuzzy matchera Telescope. Uzyj `<leader>ff` i sprobuj
tych query -- kazde powinno znalezc odpowiedni plik:

1. Wpisz `datapy` -- powinien pojawic sie `data_processing.py`
2. Wpisz `logvue` -- powinien pojawic sie `LoginForm.vue`
3. Wpisz `storets` -- powinien pojawic sie `store.ts`
4. Wpisz `brokts` -- powinien pojawic sie `broken.ts`
5. Wpisz `datavue` -- powinien pojawic sie `DataTable.vue`

Zauwaz: kolejnosc liter sie liczy, ale nie musza byc obok siebie.

## Cwiczenie 2: Live Grep -- szukaj wzorcow w kodzie

Uzyj `<leader>fg` (Live Grep) do znalezienia konkretnych wzorcow:

1. Wpisz `class ` (ze spacja) -- znajdz wszystkie definicje klas
2. Wpisz `import` -- pokaz wszystkie importy w projekcie
3. Wpisz `TODO` -- znajdz wszystkie komentarze TODO
4. Wpisz `async` -- znajdz asynchroniczne funkcje
5. Wpisz `return` -- pokaz wszystkie instrukcje return

Przy kazdym wyniku zauwaz: plik + numer linii + podglad w panelu po prawej.

## Cwiczenie 3: Polowanie na funkcje

Wyobraz sobie, ze szukasz konkretnej logiki w projekcie. Uzyj Telescope:

1. `<leader>fg` -- wpisz `def calculate` -- znajdz funkcje kalkulacyjne
2. Otworz wynik w `Ctrl+v` (vsplit) -- kod obok wynikow
3. `Esc` z Telescope, przejdz do otwartego pliku
4. Teraz `<leader>fs` (Symbols) -- zobacz liste WSZYSTKICH funkcji w tym pliku
5. Wybierz inna funkcje z listy -- Telescope przeniesie Cie bezposrednio do niej

## Cwiczenie 4: Wyszukiwanie i nawigacja w jednym pliku

1. Otworz `exercises/python/data_processing.py`
2. `<leader>/` -- fuzzy search w biezacym buforze
3. Wpisz `for` -- zauwaz wszystkie petle w pliku
4. Wybierz jedna -- kursor przeniesie sie do tej linii
5. Teraz `<leader>/` ponownie, wpisz `return` -- znajdz instrukcje return
6. Porownaj z `/return` (native Vim search) -- Telescope pokazuje wszystkie wyniki naraz

## Cwiczenie 5: Keymaps -- odkrywanie konfiguracji

Uzyj `<leader>fk` do eksploracji WSZYSTKICH dostepnych skrotow:

1. Wpisz `fold` -- znajdz skroty do foldingu (z lekcji 20)
2. Wpisz `neo-tree` -- znajdz skroty Neo-tree
3. Wpisz `yazi` -- znajdz skroty Yazi
4. Wpisz `split` -- znajdz skroty do splitow
5. Wpisz `diagnostic` -- znajdz skroty diagnostyk LSP

Zapamietaj: `<leader>fk` zastepuje kazdą sciagawke. Nie musisz pamietac
wszystkich skrotow -- wystarczy wiedziec, ze istnieja.

## Cwiczenie 6: Workflow z Search Resume

1. `<leader>fg` -- wpisz `export` -- przejrzyj wyniki
2. Otworz jeden plik (`Enter`)
3. Przeanalizuj kod, zrob notatke (mentalnie)
4. `<leader>sr` -- Telescope wznowi dokladnie to samo wyszukiwanie!
5. Wybierz nastepny wynik, otworz, przeanalizuj
6. `<leader>sr` -- kontynuuj od miejsca, w ktorym skonczyles

Ten workflow jest idealny, gdy przegladasz wiele wynikow jednego wyszukiwania.

## Cwiczenie 7: Search Word -- find usages

1. Otworz `exercises/typescript/interfaces.ts`
2. Znajdz nazwe jednego z interfejsow lub typow
3. Ustaw kursor na tej nazwie
4. `<leader>sw` -- Telescope otworzy Live Grep z ta nazwa
5. Zobaczysz WSZYSTKIE pliki, ktore uzywaja tego typu
6. Otworz wynik -- to odpowiednik "Go to References" z IDE

## Cwiczenie 8: Multi-file opening z Telescope

Otworz 4 pliki, kazdy w inny sposob, bez uzywania `:e`:

1. `<leader>ff` -- wpisz `calculator`, `Enter` (normalnie)
2. `<leader>ff` -- wpisz `api-service`, `Ctrl+v` (vsplit)
3. `<leader>ff` -- wpisz `UserCard`, `Ctrl+x` (hsplit)
4. `<leader>fr` -- wybierz plik z recent files, `Enter`

Sprawdz layout -- masz kilka okien, kazde z innym plikiem.
`Ctrl+w o` -- zamknij splity, `<leader>fb` -- przegladaj buffery.

## Cwiczenie bonusowe

**Scenariusz: szukasz buga w rozproszonym kodzie**

Dostales raport: "Funkcja `process` przetwarza dane niepoprawnie".
Uzyj TYLKO Telescope do znalezienia i zrozumienia problemu:

1. `<leader>fg` -- wpisz `def process` lub `function process` -- znajdz definicje
2. Otworz plik z definicja
3. `<leader>fs` -- przejrzyj strukture pliku (jakie inne funkcje sa w poblizu?)
4. Znajdz nazwe zmiennej, ktora Cie interesuje, ustaw kursor na niej
5. `<leader>sw` -- gdzie ta zmienna jest uzywana?
6. `<leader>/` -- szukaj wzorca w biezacym pliku
7. `<leader>sd` -- czy LSP znalazl jakies diagnostyki?
8. `<leader>sr` -- wroc do poprzedniego wyszukiwania
9. Caly debugging bez uzywania myszy i bez `grep` w terminalu
