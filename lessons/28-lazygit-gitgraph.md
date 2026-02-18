# Lekcja 28: LazyGit i Git Graph -- zaawansowane operacje git

> Czas: ~40-45 min | Poziom: Intermediate/Advanced

---

## Cel lekcji

Nauczysz sie:

- Uruchamiac i nawigowac w LazyGit z poziomu Neovim
- Wykonywac operacje git (stage, commit, push, rebase) w LazyGit
- Wizualizowac historie branchow w Git Graph
- Przegladac detale commitow w floating window
- Dobierac odpowiednie narzedzie do sytuacji

---

## Teoria

### Dwa narzedzia, dwa cele

W lekcjach 26-27 poznales narzedzia do **przegladania** zmian (gitsigns, Diffview).
Teraz przechodzisz do **wykonywania operacji** na repozytorium i **wizualizacji historii**.

| Narzedzie | Glowny cel | Tryb pracy |
|-----------|-----------|------------|
| **LazyGit** | Operacje git (commit, push, rebase, merge) | Pelnoekranowy TUI |
| **Git Graph** | Wizualizacja historii branchow | ASCII art w buforze Neovim |

### LazyGit -- pelny klient git w TUI

LazyGit to samodzielna aplikacja TUI (Terminal User Interface), ktora integruje
sie z Neovim przez plugin. Dziala jak GUI klient git, ale w terminalu -- ze wszystkimi
zaletami klawiatury.

#### Uruchamianie LazyGit

| Skrot | Dzialanie | Kontekst |
|-------|-----------|----------|
| `<leader>gg` | LazyGit (fullscreen) | Cale repozytorium |
| `<leader>gf` | LazyGit current file | Fokus na biezacym pliku |
| `Cmd+Shift+D` | LazyGit w tmux popup (90x90%) | Z dowolnego miejsca w tmux |

> **Twoja konfiguracja**: `<leader>gf` otwiera LazyGit z fokusem na biezacym pliku --
> od razu widzisz jego historie commitow i zmiany. `Cmd+Shift+D` otwiera LazyGit
> w tmux popup (90x90% ekranu) -- uzyteczne gdy chcesz miec LazyGit "obok"
> bez opuszczania biezacego layoutu.

#### Panele LazyGit

LazyGit ma 5 glownych paneli, miedzy ktorymi nawigujesz klawiszami `1-5` lub `Tab`:

```
+-------------------+-------------------------------+
│ 1: Status         │                               │
│                   │  Diff / Preview                │
│ 2: Files          │  (prawy panel pokazuje        │
│   M config.yaml   │   zawartosc wybranego         │
│   M src/api.py    │   elementu z lewego panelu)   │
│   A src/new.py    │                               │
│                   │  - timeout = 60               │
│ 3: Branches       │  + timeout = 30               │
│   * main          │  + retries = 3                │
│     feature/auth  │                               │
│                   │                               │
│ 4: Commits        │                               │
│   abc1234 Fix..   │                               │
│   def5678 Add..   │                               │
│                   │                               │
│ 5: Stash          │                               │
+-------------------+-------------------------------+
```

| Panel | Zawartosc | Klawisz |
|-------|-----------|---------|
| **Status** | Nazwa repo, branch, upstream | `1` |
| **Files** | Zmienione pliki (staged/unstaged) | `2` |
| **Branches** | Lista branchow (local + remote) | `3` |
| **Commits** | Historia commitow biezacego brancha | `4` |
| **Stash** | Lista stashow | `5` |

#### Najwazniejsze operacje w LazyGit

**Files panel (2)**:

| Klawisz | Dzialanie |
|---------|-----------|
| `Space` | Stage/unstage plik |
| `a` | Stage/unstage **wszystkie** pliki |
| `c` | **Commit** (otworzy edytor commit message) |
| `d` | Discard changes (odrzuc zmiany) |
| `e` | Edit plik (otworzy w edytorze) |
| `Enter` | Podglad zmian w pliku (staged diff) |
| `o` | Otworz plik w systemowym edytorze |

**Branches panel (3)**:

| Klawisz | Dzialanie |
|---------|-----------|
| `Space` | Checkout branch |
| `n` | New branch |
| `d` | Delete branch |
| `M` | Merge branch into current |
| `r` | Rebase current onto selected |
| `f` | Fetch |

**Commits panel (4)**:

| Klawisz | Dzialanie |
|---------|-----------|
| `Enter` | Pokaz szczegoly commita |
| `c` | Cherry-pick commit |
| `r` | Reword commit message |
| `s` | Squash commit (polacz z poprzednim) |
| `f` | Fixup commit |
| `d` | Drop commit (usun z historii) |
| `e` | Edit commit (interactive rebase) |

**Globalne skroty w LazyGit**:

| Klawisz | Dzialanie |
|---------|-----------|
| `P` | **Push** do remote |
| `p` | **Pull** z remote |
| `z` | Undo (cofnij ostatnia operacje git) |
| `?` | Pomoc (lista skrotow dla biezacego panelu) |
| `q` | Quit (zamknij LazyGit) |
| `/` | Filtruj/szukaj w biezacym panelu |
| `+`/`-` | Zmien rozmiar panelu |

> **Tip**: LazyGit uzywa **delta** jako pager do diffs -- dlatego podglad zmian
> jest kolorowy i czytelny, z podswietlaniem na poziomie slow.

#### Commit workflow w LazyGit

Typowy proces commitowania:

1. Otworz LazyGit (`<leader>gg`)
2. W panelu Files: `Space` na plikach, ktore chcesz staged
3. `c` -- otworzy sie edytor commit message
4. Wpisz message, zapisz i zamknij (`:wq` w Neovim)
5. `P` -- push do remote (opcjonalnie)
6. `q` -- wroc do Neovim

### Git Graph -- wizualizacja historii

Git Graph (gitgraph.nvim) rysuje **ASCII art** przedstawiajacy historie branchow
bezposrednio w buforze Neovim.

#### Uruchamianie Git Graph

| Skrot | Dzialanie |
|-------|-----------|
| `<leader>gl` | Otworz Git Graph (wszystkie branche, max 5000 commitow) |

#### Widok Git Graph

```
  * a1b2c3d (HEAD -> main) Merge feature/auth
  M─╮
  │ * e4f5g6h Add JWT validation
  │ * i7j8k9l Add login endpoint
  │ * m1n2o3p Create auth middleware
  ╭─╯
  * q4r5s6t Update README
  * u7v8w9x Initial commit
```

> **Twoja konfiguracja**: Symbole sa dostosowane:
>
> | Symbol | Znaczenie |
> |--------|-----------|
> | `*` | Commit |
> | `M` | Merge commit |
> | `│` | Linia brancha (pionowa) |
> | `─` | Linia brancha (pozioma) |
> | `╮` | Branch odchodzi w prawo |
> | `╭` | Branch dolacza z lewej |
> | `╯` | Branch konczy sie w prawo |
> | `╰` | Branch konczy sie w lewo |

#### Nawigacja w Git Graph

| Klawisz | Dzialanie |
|---------|-----------|
| `j` / `k` | Nawigacja miedzy commitami |
| `i` | **Info** -- floating window z detalami commita |
| `q` / `Esc` | Zamknij floating window lub Git Graph |

Floating window (`i`) pokazuje:

- Pelny hash commita
- Autora i email
- Date commita
- Pelny commit message
- Branch/tag referencje

```
┌─────────────────────────────────────────────┐
│  Commit: a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6  │
│  Author: Marek Stanek <marek@example.com>   │
│  Date:   2026-02-15 14:30:00                │
│                                             │
│  Add JWT validation for API endpoints       │
│                                             │
│  - Validate token expiration                │
│  - Check user permissions                   │
│  - Return 401 for invalid tokens            │
│                                             │
│  Refs: feature/auth                         │
└─────────────────────────────────────────────┘
```

### Kiedy uzywac ktorego narzedzia?

| Chce... | Narzedzie | Skrot |
|---------|-----------|-------|
| Zobaczyc zmiany w biezacym pliku | Gitsigns (`<leader>gp`, `<leader>gD`) | Lekcja 26 |
| Review'owac wszystkie zmiany przed commitem | Diffview (`<leader>gd`) | Lekcja 27 |
| Commitowac, pushowac, rebasowac | **LazyGit** (`<leader>gg`) | Ta lekcja |
| Zobaczyc historie branchow graficznie | **Git Graph** (`<leader>gl`) | Ta lekcja |
| Zobaczyc kto zmienil linie | Gitsigns blame (`<leader>gb`) | Lekcja 26 |
| Zobaczyc historie pliku | Diffview history (`<leader>gh`) | Lekcja 27 |

**Reguła kciuka**: Gitsigns/Diffview do **czytania** zmian, LazyGit do **operacji** git,
Git Graph do **rozumienia** historii.

---

## Cwiczenia

### Przygotowanie

Upewnij sie, ze repozytorium cwiczeniowe jest gotowe:

```bash
cd ~/GIT/vim-tutor/exercises/git-exercise
bash setup-git-exercise.sh
cd repo
nvim .
```

### Cwiczenie 1: Uruchamianie LazyGit

1. Nacisnij `<leader>gg` -- LazyGit otworzy sie fullscreen
2. Zaobserwuj 5 paneli po lewej stronie
3. Nacisnij `1`, `2`, `3`, `4`, `5` -- przelacz miedzy panelami
4. W kazdym panelu przejrzyj zawartosc (`j`/`k`)
5. Nacisnij `?` -- zobacz dostepne skroty dla biezacego panelu
6. Zamknij LazyGit: `q`

### Cwiczenie 2: Stage i commit

1. Dokonaj zmian w 2-3 plikach repozytorium (dodaj linie, zmien wartosci)
2. Otworz LazyGit (`<leader>gg`)
3. Przejdz do panelu Files (`2`)
4. Zaznacz pierwszy plik i nacisnij `Space` -- plik zostanie staged
5. Nacisnij `Enter` -- podejrzyj diff (delta rendering)
6. Stage kolejny plik (`Space`)
7. Nacisnij `c` -- wpisz commit message, zapisz (`:wq`)
8. Zaobserwuj, ze commit pojawil sie w panelu Commits (`4`)
9. Zamknij LazyGit: `q`

### Cwiczenie 3: LazyGit current file

1. Otworz konkretny plik w Neovim
2. Nacisnij `<leader>gf` -- LazyGit otworzy sie z fokusem na tym pliku
3. Przejdz do panelu Commits -- zobaczysz commity dotyczace TEGO pliku
4. Przejrzyj historie zmian
5. Zamknij: `q`

### Cwiczenie 4: Operacje na branchach

1. Otworz LazyGit (`<leader>gg`)
2. Przejdz do panelu Branches (`3`)
3. Nacisnij `n` -- utworz nowy branch (wpisz nazwe, np. `test/exercise-28`)
4. Dokonaj zmiany w pliku, stage (`Space`) i commit (`c`)
5. Wroc do panelu Branches
6. Ustaw kursor na `main` i nacisnij `Space` -- checkout na main
7. Zaobserwuj, ze Twoje zmiany zniknely (sa na innym branchu)
8. Wroc na swoj branch (`Space`)

### Cwiczenie 5: Cherry-pick

1. Otworz LazyGit (`<leader>gg`)
2. Przejdz do panelu Branches (`3`)
3. Checkout na `main` (`Space`)
4. Przejdz do panelu Commits (`4`)
5. Nawiguj do commita z innego brancha, ktory chcesz skopiowac
6. Nacisnij `c` -- cherry-pick commita
7. Sprawdz w panelu Commits, ze commit zostal dodany do main

### Cwiczenie 6: Git Graph -- wizualizacja

1. Zamknij LazyGit (`q`)
2. Nacisnij `<leader>gl` -- otworzy sie Git Graph
3. Przejrzyj ASCII art -- zauwaz linie branchow, merge'y, commity
4. Nawiguj `j`/`k` miedzy commitami
5. Na wybranym commicie nacisnij `i` -- floating window z detalami
6. Przeczytaj: hash, autor, date, message
7. Zamknij floating window (`Esc`) i przejdz do innego commita
8. Zamknij Git Graph: `q`

### Cwiczenie 7: Git Graph -- rozumienie historii

1. Otworz Git Graph (`<leader>gl`)
2. Znajdz merge commit (oznaczony symbolem `M`)
3. Nacisnij `i` -- przeczytaj commit message merge'a
4. Zaobserwuj linie branchow: skad branch odchodzil i gdzie zostal zmergowany
5. Zlokalizuj poczatek feature brancha -- gdzie odgalezil sie od main?
6. Policz ile commitow ma feature branch
7. Zamknij: `q`

### Cwiczenie 8: tmux popup i stash

1. Upewnij sie, ze jestes w sesji tmux
2. Nacisnij `Cmd+Shift+D` -- LazyGit otworzy sie w tmux popup (90x90%)
3. Dokonaj zmiany w pliku, przejdz do panelu Files
4. Nacisnij `s` -- zmiany zostana stashed, wpisz opis (np. "WIP: exercise 28")
5. Przejdz do panelu Stash (`5`) -- `Space` zeby apply stash
6. Zamknij popup: `q`

---

## Cwiczenie bonusowe

**Scenariusz: feature branch workflow**

1. Otworz LazyGit (`<leader>gg`)
2. Utworz nowy branch `feature/exercise-bonus` (`n` w panelu Branches)
3. Zamknij LazyGit (`q`)
4. Dokonaj zmian w 3 plikach -- kazda zmiana to osobny "feature"
5. Wroc do LazyGit (`<leader>gg`)
6. Stage i commit kazda zmiane osobno (3 commity z sensownymi messages)
7. Przejrzyj Git Graph (`q` LazyGit, potem `<leader>gl`) -- zobaczysz swoj branch
8. Wroc do LazyGit (`q` Git Graph, potem `<leader>gg`)
9. Checkout na `main`, sprobuj merge swojego brancha (`M` w panelu Branches)
10. Sprawdz Git Graph ponownie -- zobaczysz merge commit

**Wyzwanie**: Wykonaj interactive rebase -- polacz (squash) 3 commity w jeden,
uzywajac panelu Commits w LazyGit.

---

## Podsumowanie

### Nauczone komendy -- Neovim

| Skrot | Dzialanie |
|-------|-----------|
| `<leader>gg` | LazyGit (fullscreen) |
| `<leader>gf` | LazyGit current file |
| `Cmd+Shift+D` | LazyGit w tmux popup (90x90%) |
| `<leader>gl` | Git Graph (ASCII art branch visualization) |

### Nauczone komendy -- LazyGit

| Klawisz | Panel | Dzialanie |
|---------|-------|-----------|
| `Space` | Files | Stage/unstage plik |
| `a` | Files | Stage/unstage wszystkie |
| `c` | Files | Commit |
| `d` | Files | Discard changes |
| `P` | Globalny | Push |
| `p` | Globalny | Pull |
| `Space` | Branches | Checkout branch |
| `n` | Branches | New branch |
| `M` | Branches | Merge into current |
| `r` | Branches | Rebase onto selected |
| `c` | Commits | Cherry-pick |
| `s` | Commits | Squash |
| `e` | Commits | Edit (interactive rebase) |
| `?` | Globalny | Pomoc (skroty) |
| `q` | Globalny | Quit |

### Nauczone komendy -- Git Graph

| Klawisz | Dzialanie |
|---------|-----------|
| `j` / `k` | Nawigacja miedzy commitami |
| `i` | Floating window z detalami commita |
| `q` / `Esc` | Zamknij |

### Konfiguracja uzyta w tej lekcji

| Ustawienie | Wartosc | Efekt |
|------------|---------|-------|
| LazyGit integration | Snacks.lazygit | Otwieranie z poziomu Neovim |
| tmux popup | `Cmd+Shift+D` | LazyGit w 90x90% popup |
| Git Graph max_count | `5000` | Maksymalna liczba commitow w grafie |
| Git Graph symbols | `* M │ ─ ╮ ╭ ╯ ╰` | Customowe znaki ASCII art |

### Co dalej?

W **lekcji 29** poznasz **Git Status Panel** (Neo-tree) do stalego podgladu
statusu repozytorium oraz powrocisz do **historii plikow** w Diffview.
Na koniec polaczysz wszystkie narzedzia git w jeden spojny workflow.
