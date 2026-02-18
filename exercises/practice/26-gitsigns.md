# Cwiczenie 26: Gitsigns -- zmiany w kodzie

> Powiazana lekcja: `lessons/26-gitsigns.md`

## Instrukcje
- `]c` / `[c` -- nawigacja miedzy hunkami (zmienionymi fragmentami)
- `<leader>gb` -- blame line (floating window z pelna informacja o commicie)
- `<leader>gp` -- preview hunk (floating diff biezacej zmiany)
- `<leader>gD` -- toggle side-by-side diff biezacego pliku z HEAD
- Znaki w gutter: `|` zielony (add), `|` niebieski (change), `_` czerwony (delete)

## Przygotowanie

Uruchom skrypt tworzacy repozytorium cwiczeniowe:

```bash
cd ~/GIT/vim-tutor/exercises/git-exercise
bash setup-git-exercise.sh --force
cd repo
nvim .
```

Otworz plik `src/services/user-service.ts` -- ma on juz unstaged changes (klasa `UserCache`).

## Cwiczenie 1: Rozpoznawanie typow zmian

1. Otworz `src/services/user-service.ts` (`Ctrl+P`, wpisz `user-serv`)
2. Przewin do konca pliku -- zobaczysz zielone `|` przy klasie `UserCache` (nowe linie)
3. Teraz zmien wartosc `SALT_ROUNDS` z `12` na `10` -- pojawi sie niebieska `|` (change)
4. Usun linie `const users: Map<string, User> = new Map();` klawiszem `dd` -- pojawi sie `_` (delete)
5. Zidentyfikuj trzy typy znakow w gutter: add, change, delete
6. Cofnij zmiany: nacisnij `u` wielokrotnie az znikna znaki change i delete

## Cwiczenie 2: Preview hunk na roznych typach zmian

1. W pliku `src/models/user.ts` zmien `min(3, ...)` na `min(4, ...)` w walidacji username
2. Dodaj nowa linie nad `export type UserRole`: `// Supported roles in the system`
3. Ustaw kursor na zmienionej linii (niebieska `|`) i nacisnij `<leader>gp`
4. Przeczytaj diff w floating window -- linia `-` (stara wartosc) vs `+` (nowa)
5. Zamknij floating window (`q` lub `Esc`)
6. Przejdz do dodanej linii komentarza i ponownie `<leader>gp` -- zobaczysz tylko `+`
7. Porownaj oba podglady -- zmiana vs dodanie wygladaja inaczej w diff

## Cwiczenie 3: Nawigacja hunkami w duzym pliku

1. Otworz `src/controllers/user-controller.ts`
2. Dokonaj zmian w trzech odleglych miejscach:
   - Linia ~5: dodaj komentarz `// User REST API routes`
   - Linia ~20: zmien `500` na `503` w pierwszym `catch`
   - Linia ~40: dodaj pusta linie przed `router.patch`
3. Wroc na poczatek pliku (`gg`)
4. Nacisnij `]c` -- kursor przeskoczy do pierwszego hunku (komentarz)
5. `]c` ponownie -- drugi hunk (zmieniony status code)
6. `]c` -- trzeci hunk (pusta linia)
7. `[c` -- wroc do drugiego hunku
8. Na kazdym hunku uzyj `<leader>gp` zeby potwierdzic co zmieniles

## Cwiczenie 4: Blame -- sledzenie autorow

1. Otworz `src/models/product.ts`
2. Przesun kursor na dowolna linie -- zaobserwuj inline blame (szary tekst na koncu)
3. Sprawdz date i commit message w inline blame
4. Teraz otworz `src/services/user-service.ts` -- tu sa commity z roznych dat
5. Nawiguj po liniach -- znajdz linie z roznych commitow (np. "Add user service" vs "Refactor user service")
6. Nacisnij `<leader>gb` na linii z interfejsem `PaginatedResult` -- floating window pokaze pelny blame
7. Przeczytaj: pelny hash, autor, data, commit message
8. Powtorz `<leader>gb` na linii z `async createUser` -- porownaj, czy to ten sam commit

## Cwiczenie 5: Side-by-side diff z edycja na zywo

1. Otworz `src/utils/validation.ts` -- ten plik ma staged changes
2. Dokonaj dodatkowej unstaged zmiany: zmien `minLength = 8` na `minLength = 10`
3. Nacisnij `<leader>gD` -- otworzy sie split: HEAD (lewo) vs current (prawo)
4. Sprawdz: lewe okno to wersja z ostatniego commita, prawe to Twoja biezaca wersja
5. W prawym oknie zmien `minLength = 10` na `minLength = 12`
6. Zaobserwuj, ze diff zaktualizowal sie natychmiast
7. Cofnij ostatnia zmiane (`u`) -- diff tez sie zaktualizuje
8. Zamknij diff: `<leader>gD`

## Cwiczenie 6: Porownanie blame miedzy plikami

1. Otworz `src/index.ts` i sprawdz inline blame kilku linii
2. Zanotuj mentalnie date commitow (np. "Initial project setup" vs "Add user controller")
3. Otworz `src/models/user.ts` -- sprawdz blame
4. Uzyj `<leader>gb` na linii z `"Invalid email address"` -- to powinna byc poprawka literowki (commit 6)
5. Uzyj `<leader>gb` na linii `export interface User` -- to powinien byc oryginalny commit (commit 2)
6. Porownaj daty i messages obu commitow -- potwierdz, ze rozne czesci pliku maja roznych "autorow"

## Cwiczenie 7: Workflow -- review wlasnych zmian przed commitem

1. Otworz `src/controllers/user-controller.ts`
2. Dodaj obsluge nowego query param -- w `router.get("/")` dodaj:
   ```typescript
   const search = _req.query.search as string | undefined;
   ```
3. Zmien response status w `router.delete` z `204` na `200`
4. Dodaj komentarz na koncu pliku: `// TODO: Add rate limiting`
5. Uzyj `]c`/`[c` do przegladu kazdego hunku
6. Na kazdym: `<leader>gp` -- sprawdz diff
7. Otworz side-by-side: `<leader>gD` -- przejrzyj pelny obraz zmian
8. Zamknij diff i cofnij wszystkie zmiany (`u` wielokrotnie)

## Cwiczenie bonusowe

**Analiza historii pliku przez blame**

1. Otworz `src/services/user-service.ts`
2. Plik byl modyfikowany w commitach 3 i 8 -- potwierdz to uzywajac blame
3. Uzyj `<leader>gb` na 5 roznych liniach -- zapisz mentalnie hash commita kazdej
4. Zidentyfikuj ktore linie pochodza z commita 3 ("Add user service"), a ktore z 8 ("Refactor")
5. Wskaz metode, ktora **nie zmienila sie** miedzy commitami 3 i 8 (ta sama data blame)
6. Wskaz metode, ktora **pojawila sie** dopiero w commicie 8 (np. `countByRole`)

**Wyzwanie**: Bez otwierania terminala, korzystajac wylacznie z inline blame i `<leader>gb`,
odpowiedz: ile dni minelo miedzy commitem 3 a commitem 8?
