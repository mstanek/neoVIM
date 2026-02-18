# Cwiczenie 28: LazyGit i Git Graph

> Powiazana lekcja: `lessons/28-lazygit-gitgraph.md`

## Instrukcje
- `<leader>gg` -- LazyGit (fullscreen, cale repozytorium)
- `<leader>gf` -- LazyGit (fokus na biezacym pliku)
- `<leader>gl` -- Git Graph (ASCII art wizualizacja branchow)
- `Cmd+Shift+D` -- LazyGit w tmux popup (90x90%)
- LazyGit panele: `1` Status, `2` Files, `3` Branches, `4` Commits, `5` Stash
- Files: `Space` stage/unstage, `a` stage all, `c` commit, `d` discard
- Branches: `Space` checkout, `n` new, `M` merge, `r` rebase
- Commits: `Enter` detale, `r` reword, `s` squash, `c` cherry-pick
- Globalne: `P` push, `p` pull, `z` undo, `?` pomoc, `q` quit
- Git Graph: `j`/`k` nawigacja, `i` info floating window, `q` zamknij

## Przygotowanie

```bash
cd ~/GIT/vim-tutor/exercises/git-exercise
bash setup-git-exercise.sh --force
cd repo
nvim .
```

## Cwiczenie 1: Nawigacja po panelach LazyGit

1. Nacisnij `<leader>gg` -- LazyGit otworzy sie fullscreen
2. Nacisnij `2` (Files) -- zaobserwuj zmienione pliki i diff po prawej
3. Nacisnij `3` (Branches) -- lista branchow: `main` i `feature/add-auth`
4. Nacisnij `4` (Commits) -- 8 commitow na `main`
5. Nacisnij `5` (Stash) -- pusty panel
6. W kazdym panelu nacisnij `?` -- przeczytaj dostepne skroty
7. Zamknij: `q`

## Cwiczenie 2: Stage, commit, sprawdzenie

1. Otworz `src/models/product.ts` i dodaj nowe pole w `interface Product`:
   ```typescript
   tags: string[];
   ```
2. Zapisz (`:w`) i otworz LazyGit (`<leader>gg`)
3. Panel Files (`2`) -- `product.ts` powinien byc widoczny
4. Nacisnij `Enter` na pliku -- przejrzyj diff
5. `Esc` zeby wrocic do listy, potem `Space` -- stage plik
6. Nacisnij `c` -- wpisz message: `Add tags field to Product model`, zapisz (`:wq`)
7. Przejdz do Commits (`4`) -- Twoj commit jest na gorze
8. Zamknij: `q`

## Cwiczenie 3: Dwa osobne commity

1. Dokonaj zmian w dwoch plikach:
   - `src/index.ts` -- dodaj `app.use(express.urlencoded({ extended: true }));`
   - `src/models/user.ts` -- zmien `max(30)` na `max(50)` w walidacji username
2. Otworz LazyGit (`<leader>gg`), panel Files (`2`)
3. Stage TYLKO `index.ts` (`Space`), potem `c`: `Add URL-encoded body parser`
4. Teraz stage `user.ts` (`Space`), potem `c`: `Increase max username length`
5. Panel Commits (`4`) -- dwa nowe commity na gorze
6. Zamknij: `q`

## Cwiczenie 4: Branch i checkout

1. Otworz LazyGit (`<leader>gg`), panel Branches (`3`)
2. Nacisnij `n` -- wpisz nazwe: `feature/exercise-28`
3. Jestes teraz na nowym branchu (gwiazdka `*`)
4. Zamknij LazyGit, dokonaj zmiany w dowolnym pliku
5. Wroc do LazyGit, stage (`Space`) i commit (`c`)
6. Panel Branches (`3`) -- ustaw kursor na `main`, `Space` (checkout)
7. Sprawdz Files -- Twoja zmiana zniknela (jest na innym branchu)
8. Wroc na `feature/exercise-28` (`Space` na nim)
9. Zamknij: `q`

## Cwiczenie 5: Stash workflow

1. Dokonaj zmiany w pliku, ktorej nie chcesz jeszcze commitowac
2. LazyGit (`<leader>gg`), panel Files (`2`)
3. Nacisnij `s` -- wpisz opis: `WIP: eksperymentalna zmiana`
4. Plik zniknal z Files -- zmiana jest w stash
5. Panel Stash (`5`) -- Twoj stash jest na liscie
6. Nacisnij `Space` -- apply stash (zmiany wroca do working directory)
7. Sprawdz Files -- plik znow jest zmodyfikowany
8. Zamknij: `q`

## Cwiczenie 6: Git Graph -- odczytywanie historii

1. Nacisnij `<leader>gl` -- otworzy sie Git Graph
2. Zidentyfikuj linie brancha `main` -- commity od "Initial project setup"
3. Znajdz punkt, gdzie `feature/add-auth` odchodzi od `main` (po commicie 5)
4. Policz commity na `feature/add-auth` -- powinny byc 3
5. Nacisnij `i` na commicie "Add JWT token generation" -- przeczytaj detale
6. Uzyj `j`/`k` zeby przejsc do "Add authentication and authorization middleware"
7. Nacisnij `i` -- porownaj informacje (data, autor, message)
8. Zamknij: `q`

## Cwiczenie 7: LazyGit -- fokus na pliku

1. Otworz `src/services/user-service.ts` w Neovim
2. Nacisnij `<leader>gf` -- LazyGit z fokusem na tym pliku
3. Panel Commits (`4`) -- widac TYLKO commity dotyczace tego pliku
4. Nacisnij `Enter` na starszym commicie -- przejrzyj oryginalny diff
5. Przejdz do nowszego commita (refaktor) -- porownaj co sie zmienilo
6. Zamknij: `q`

## Cwiczenie 8: Reword i discard

1. Otworz LazyGit (`<leader>gg`)
2. Panel Commits (`4`) -- znajdz swoj ostatni commit
3. Nacisnij `r` -- edytuj message na bardziej opisowy, zapisz (`:wq`)
4. Sprawdz, ze message zmienil sie na liscie
5. Teraz dokonaj zmiany w pliku (dodaj przypadkowy tekst), wroc do LazyGit
6. Panel Files (`2`) -- ustaw kursor na zmodyfikowanym pliku
7. Nacisnij `d` -- discard changes (odrzuc zmiany w tym pliku)
8. Plik zniknal z listy -- zmiany zostaly odrzucone
9. Zamknij: `q`

## Cwiczenie bonusowe

**Scenariusz: feature branch z merge i wizualizacja**

1. Otworz LazyGit (`<leader>gg`), Branches (`3`)
2. Checkout na `main` (`Space`), potem `n` -- nowy branch `feature/bonus-28`
3. Zamknij LazyGit i dokonaj 3 roznych zmian w 3 plikach
4. Wroc do LazyGit -- stage i commituj kazda zmiane osobno (3 commity)
5. Checkout na `main` (`Space` w Branches)
6. Ustaw kursor na `feature/bonus-28` i nacisnij `M` -- merge into main
7. Zamknij LazyGit (`q`)
8. Otworz Git Graph (`<leader>gl`) -- zaobserwuj merge commit w ASCII art
9. Zidentyfikuj obie linie branchow i punkt polaczenia

**Wyzwanie**: W LazyGit polacz (squash) 2 z 3 commitow w jeden:
panel Commits, ustaw kursor na commicie, nacisnij `s` (squash into previous).
Sprawdz Git Graph po squash -- ile commitow ma teraz branch?
