# Cwiczenie 27: Diffview -- przegladanie zmian

> Powiazana lekcja: `lessons/27-diffview.md`

## Instrukcje
- `<leader>gd` -- DiffviewOpen (wszystkie zmiany: staged + unstaged)
- `<leader>gc` -- DiffviewClose (zamknij z dowolnego miejsca)
- `<leader>gh` -- DiffviewFileHistory % (historia biezacego pliku)
- Panel plikow: `j`/`k` nawigacja, `s` stage/unstage, `S` stage all, `U` unstage all
- Panel plikow: `X` restore (odrzuc zmiany!), `L` commit log, `q` zamknij
- Diff view: `<Tab>`/`<S-Tab>` nastepny/poprzedni plik, `gf` otworz plik
- `<leader>e` -- toggle panel plikow (pokaz/ukryj)
- Fold controls: `zo`/`zc`/`za`/`zR`/`zM`

## Przygotowanie

```bash
cd ~/GIT/vim-tutor/exercises/git-exercise
bash setup-git-exercise.sh --force
cd repo
nvim .
```

Repozytorium zawiera juz staged changes (`src/utils/validation.ts`)
i unstaged changes (`src/services/user-service.ts`).
Dokonaj dodatkowych zmian w 2-3 plikach zeby miec wiecej materialu do review.

## Cwiczenie 1: Analiza sekcji Staged vs Changes

1. Otworz Diffview (`<leader>gd`)
2. W panelu plikow zidentyfikuj dwie sekcje:
   - "Staged Changes" -- powinien byc `src/utils/validation.ts`
   - "Changes" -- powinien byc `src/services/user-service.ts`
3. Wybierz plik z "Staged Changes" (Enter) -- przejrzyj diff po prawej
4. Wroc do panelu i wybierz plik z "Changes" -- porownaj oba diffy
5. Zauwaz roznice miedzy staged i unstaged w kolorach/ikonach panelu
6. Zamknij: `<leader>gc`

## Cwiczenie 2: Selektywny staging

1. Otworz `src/models/user.ts` i zmien `max(30)` na `max(50)` w walidacji username
2. Otworz `src/index.ts` i dodaj komentarz `// Main entry point` na gorze pliku
3. Otworz `src/models/product.ts` i zmien `default("other")` na `default("electronics")`
4. Otworz Diffview (`<leader>gd`)
5. Uzyj `s` na `user.ts` i `index.ts` -- stage tylko te 2 pliki
6. Sprawdz, ze "Staged Changes" ma teraz 3 pliki (2 nowe + validation.ts)
7. Sprawdz, ze "Changes" ma `product.ts` i `user-service.ts`
8. Uzyj `U` -- wszystko wroci do "Changes" (unstage all)
9. Zamknij: `<leader>gc`

## Cwiczenie 3: Review z nawigacja Tab

1. Upewnij sie, ze masz zmiany w 3+ plikach
2. Otworz Diffview (`<leader>gd`)
3. Wybierz pierwszy plik w panelu (Enter)
4. W diff view nacisnij `<Tab>` -- przeskoczy na diff nastepnego pliku
5. `<Tab>` ponownie -- kolejny plik
6. `<S-Tab>` -- wroc do poprzedniego
7. Przejrzyj diff kazdego pliku -- to najszybszy sposob na review
8. Zamknij: `<leader>gc`

## Cwiczenie 4: Praca z foldami

1. Otworz Diffview z wieloma zmienionymi plikami (`<leader>gd`)
2. W panelu plikow nacisnij `zM` -- zwin wszystkie foldy (widac tylko katalogi)
3. Nacisnij `zo` na katalogu `src/` -- rozwin go
4. Nacisnij `za` na podkatalogu -- toggle fold
5. Nacisnij `zR` -- rozwin wszystko
6. Foldy pomagaja skupic sie na konkretnym fragmencie projektu
7. Zamknij: `<leader>gc`

## Cwiczenie 5: Otwarcie pliku z Diffview i powrot

1. Dokonaj zmiany w `src/controllers/user-controller.ts` (np. dodaj komentarz)
2. Otworz Diffview (`<leader>gd`)
3. Wybierz `user-controller.ts` w panelu (Enter) -- przejrzyj diff
4. Nacisnij `gf` -- Diffview zamknie sie, otworzy sie bufor pliku
5. Dokonaj dodatkowej zmiany w pliku i zapisz (`:w`)
6. Wroc do Diffview (`<leader>gd`) -- nowa zmiana jest widoczna
7. Zamknij: `<leader>gc`

## Cwiczenie 6: File history -- ewolucja pliku

1. Otworz `src/services/user-service.ts` (bogata historia: commity 3 i 8)
2. Nacisnij `<leader>gh` -- otworzy sie DiffviewFileHistory
3. Nawiguj `j`/`k` miedzy commitami
4. Na commicie "Add user service" (starszy) nacisnij Enter -- przejrzyj diff
5. Przejdz do "Refactor user service" (nowszy) -- porownaj diffy
6. Zaobserwuj co sie zmienilo: dodanie `PaginatedResult`, zmiana na `async`
7. Zamknij: `<leader>gc`

## Cwiczenie 7: Commit log z Diffview

1. Otworz Diffview (`<leader>gd`)
2. W panelu plikow nacisnij `L` -- otworzy sie pelny commit log
3. Nawiguj po commitach -- przejrzyj ich messages i daty
4. Wybierz commit "Add validation and sanitization utilities" (Enter)
5. Przejrzyj diff -- co dokladnie zostalo dodane w tym commicie
6. Zamknij commit log i Diffview

## Cwiczenie 8: Toggle file panel i pelnoekranowy diff

1. Otworz Diffview (`<leader>gd`)
2. Wybierz plik z dlugimi liniami (np. `user-controller.ts`) -- Enter
3. Nacisnij `<leader>e` -- panel plikow zniknie, diff zajmie pelna szerokosc
4. Przewin diff -- teraz widac wiecej kodu jednoczesnie
5. Nacisnij `<leader>e` ponownie -- panel wroci
6. Przydatne przy review plikow z dlugimi liniami
7. Zamknij: `<leader>gc`

## Cwiczenie bonusowe

**Scenariusz: przygotowanie dwoch osobnych commitow**

1. Cofnij wczesniejsze zmiany: w terminalu `:!git checkout -- .`
2. Dokonaj zmian zwiazanych z dwoma niezaleznymi taskami:
   - Task A (model): w `src/models/user.ts` dodaj pole `lastLoginAt?: Date`
     w interfejsie `User`, w `src/models/product.ts` dodaj pole `sku: string`
   - Task B (utils): w `src/utils/validation.ts` dodaj funkcje `isValidSKU`,
     w `src/index.ts` dodaj `console.log("Environment:", process.env.NODE_ENV)`
3. Otworz Diffview (`<leader>gd`)
4. Uzyj `<Tab>` do review kazdego pliku -- upewnij sie, ze kazda zmiana jest celowa
5. Stage TYLKO pliki z Task A (modele): `s` na `user.ts` i `product.ts`
6. Zamknij Diffview (`<leader>gc`)
7. W LazyGit (`<leader>gg`) commitnij staged: `Add lastLoginAt and SKU fields to models`
8. Wroc, stage pliki z Task B, commitnij: `Add SKU validation and env logging`

**Wyzwanie**: Uzyj `<leader>gh` na `src/services/user-service.ts` i znajdz
ktora metoda zmienila sygnature z synchronicznej na asynchroniczna w refaktorze.
