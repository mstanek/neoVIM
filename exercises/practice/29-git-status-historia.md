# Cwiczenie 29: Git Status Panel i historia plikow

> Powiazana lekcja: `lessons/29-git-status-historia.md`

## Instrukcje
- `<leader>gs` -- toggle Git Status Panel (Neo-tree, prawa strona, width=50)
- `<leader>gh` -- DiffviewFileHistory % (historia commitow biezacego pliku)
- File History: `j`/`k` nawigacja, `Enter` pokaz diff, `y` kopiuj hash, `L` commit log
- File History: `<Tab>`/`<S-Tab>` nastepny/poprzedni plik, `gf` otworz plik
- Git Status Panel: `j`/`k` nawigacja, `Enter` otworz plik, `q` zamknij
- Mutual exclusion: `<leader>gs` zamyka Aerial i odwrotnie
- Auto-refresh co 30 sekund

## Przygotowanie

```bash
cd ~/GIT/vim-tutor/exercises/git-exercise
bash setup-git-exercise.sh --force
cd repo
nvim .
```

## Cwiczenie 1: Git Status Panel -- podstawy

1. Nacisnij `<leader>gs` -- panel pojawi sie po prawej stronie
2. Zaobserwuj sekcje "Changes" z lista zmienionych plikow
3. Obok kazdego pliku widac diff stats: `+N -N` (dodane/usuniete linie)
4. Nawiguj `j`/`k` po liscie plikow
5. Nacisnij `Enter` na `src/services/user-service.ts` -- otworzy sie w lewym panelu
6. Zamknij panel: `<leader>gs` (toggle off)

## Cwiczenie 2: Staged vs Changes w panelu

1. W terminalu stage plik: `:!git add src/utils/validation.ts`
2. Otworz Git Status Panel (`<leader>gs`)
3. Zaobserwuj dwie sekcje:
   - "Staged Changes" -- `validation.ts` z ikona `+` (zielona)
   - "Changes" -- `user-service.ts` z ikona (zolta/pomaranczowa)
4. Sprawdz diff stats obu plikow -- ile linii dodanych w kazdym?
5. Zamknij panel: `<leader>gs`

## Cwiczenie 3: Mutual exclusion z Aerial

1. Otworz plik z kodem, np. `src/services/user-service.ts`
2. Otworz Aerial/outline (`<leader>cs`) -- panel symbols po prawej
3. Zaobserwuj liste funkcji i klas w Aerial
4. Nacisnij `<leader>gs` -- Aerial zniknie, pojawi sie Git Status
5. Nacisnij `<leader>gs` ponownie -- Git Status zniknie
6. Otworz Aerial ponownie (`<leader>cs`) -- wraca na swoje miejsce
7. Klucz: tylko jeden panel po prawej stronie na raz

## Cwiczenie 4: Obserwacja zmian w czasie rzeczywistym

1. Otworz Git Status Panel (`<leader>gs`)
2. Zanotuj ile plikow jest w sekcji "Changes"
3. W lewym panelu otworz nowy plik i dokonaj zmiany:
   - Otworz `src/index.ts` i zmien port z `3000` na `8080`
   - Zapisz: `:w`
4. Poczekaj do 30 sekund -- panel powinien sie odswiezyc
5. `src/index.ts` powinien pojawic sie w "Changes" z diff stats
6. Cofnij zmiane w pliku (`:!git checkout -- src/index.ts`)
7. Poczekaj na refresh -- plik zniknie z panelu

## Cwiczenie 5: File History -- przegladanie ewolucji

1. Otworz `src/models/user.ts` (plik z commitami 2 i 6)
2. Nacisnij `<leader>gh` -- otworzy sie DiffviewFileHistory
3. Zobaczysz liste commitow, ktore zmienily ten plik
4. Na commicie "Fix typo in email validation" (commit 6) nacisnij `Enter`
5. Przeczytaj diff -- zobaczysz zmiane `adress` -> `address`
6. Przejdz do starszego commita "Add user model" (commit 2)
7. Przeczytaj diff -- to cala oryginalna tresc pliku (wszystko dodane)
8. Zamknij: `<leader>gc`

## Cwiczenie 6: Kopiowanie hash commita z historii

1. Otworz `src/controllers/user-controller.ts`
2. Nacisnij `<leader>gh` -- historia pliku
3. Powinien byc widoczny commit "Add user controller with REST endpoints"
4. Ustaw kursor na tym commicie
5. Nacisnij `y` -- hash commita zostanie skopiowany do clipboard
6. Zamknij historie (`<leader>gc`)
7. W terminalu (`:!git show <Ctrl+V>`) wklej hash -- zobaczysz pelny diff commita

## Cwiczenie 7: File History z nawigacja miedzy plikami

1. Otworz `src/services/user-service.ts`
2. Nacisnij `<leader>gh` -- historia pliku
3. Znajdz commit "Refactor user service" (commit 8) i nacisnij Enter
4. Ten commit mogl zmienic wiecej plikow -- uzyj `<Tab>` zeby sprawdzic
5. Jesli sa inne pliki zmienione w tym commicie, przejrzyj ich diffy
6. `<S-Tab>` -- wroc do poprzedniego pliku
7. Zamknij: `<leader>gc`

## Cwiczenie 8: Pelny workflow -- od edycji do weryfikacji

Polacz narzedzia ze wszystkich lekcji (26-29) w jeden cykl pracy:

1. **Edycja**: Otworz `src/models/product.ts`, dodaj pole `brand: string` w interface
2. **Gitsigns**: Zaobserwuj zielona `|` w gutter, sprawdz inline blame sasiedniej linii
3. **Preview**: `<leader>gp` -- podgladnij hunk
4. **Status Panel**: `<leader>gs` -- sprawdz ze `product.ts` jest w "Changes"
5. **Diffview**: `<leader>gd` -- review zmiany, stage plik (`s`)
6. **Close Diffview**: `<leader>gc`
7. **LazyGit**: `<leader>gg` -- commit (`c`), message: `Add brand field to Product`
8. **Git Graph**: `<leader>gl` -- potwierdz, ze nowy commit jest na gorze
9. **File History**: otworz `product.ts`, `<leader>gh` -- Twoj commit jest w historii

## Cwiczenie bonusowe

**Scenariusz: debugowanie -- kto wprowadzil zmiane?**

1. Otworz `src/services/user-service.ts`
2. Uzyj inline blame -- znajdz linie, ktore pochodza z roznych commitow
3. `<leader>gb` na linii z `PaginatedResult` -- zanotuj hash i date
4. `<leader>gh` -- otworz historie pliku
5. Nawiguj do commita, ktory wprowadzil `PaginatedResult`
6. Przeczytaj pelny diff -- jakie inne zmiany zawiera ten commit?
7. Skopiuj hash (`y`) -- zamknij historie
8. Sprawdz Git Graph (`<leader>gl`) -- na jakim branchu byl ten commit?
9. Otworz Git Status Panel (`<leader>gs`) -- sprawdz biezacy stan repo

**Wyzwanie**: Uzywajac narzedzi Neovim (bez terminala), zidentyfikuj:
- Ktory commit wprowadzil interfejs `FindUsersOptions`
- Ile linii zostalo dodanych w tym commicie (diff stats z `<leader>gh`)
- Czy ten sam commit zmienil tez inne pliki (nawigacja `<Tab>` w file history)
