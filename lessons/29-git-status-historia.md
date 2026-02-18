# Lekcja 29: Git Status Panel i historia plikow

> Czas: ~30-45 min | Poziom: Intermediate/Advanced

---

## Cel lekcji

Nauczysz sie:

- Korzystac z Git Status Panel (Neo-tree) do stalego podgladu statusu repo
- Rozumiec sekcje "Staged Changes" i "Changes" z diff stats
- Przegladac pelna historie plikow w Diffview
- Laczyc wszystkie narzedzia git w jeden workflow
- Wybierac odpowiednie narzedzie do kazdej sytuacji

---

## Teoria

### Git Status Panel -- staly podglad statusu

Git Status Panel to specjalny widok Neo-tree, ktory pokazuje zmienione pliki
w repozytorium -- analogicznie do panelu "Source Control" w VS Code.

| Skrot | Dzialanie |
|-------|-----------|
| `<leader>gs` | Toggle Git Status Panel (prawa strona, width=50) |

> **Twoja konfiguracja**: Git Status Panel otwiera sie po **prawej stronie** ekranu
> z szerokoscia 50 znakow. Dziala na zasadzie **wzajemnego wykluczania** z Aerial
> (outline panel) -- otwarcie git status zamyka outline i odwrotnie.

### Layout Git Status Panel

```
+--------------------------------------------+-------------------------+
│                                            │  Git Status (width=50)  │
│                                            │                         │
│  Twoj kod                                  │  Staged Changes (2)     │
│  (normalny bufor)                          │  ├── src/               │
│                                            │  │   └── api.py  +12 -3 │
│                                            │  └── config.yaml +1 -1  │
│                                            │                         │
│                                            │  Changes (3)            │
│                                            │  ├── src/               │
│                                            │  │   ├── models.py +5 -2│
│                                            │  │   └── utils.py  +8 -0│
│                                            │  └── tests/             │
│                                            │      └── test_api.py +20│
│                                            │                         │
+--------------------------------------------+-------------------------+
```

### Sekcje i ikonki

Panel grupuje pliki w dwie sekcje, identycznie jak VS Code:

| Sekcja | Ikona | Kolor | Znaczenie |
|--------|-------|-------|-----------|
| **Staged Changes (N)** | `✚` | Zielony | Pliki w staging area (gotowe do commita) |
| **Changes (N)** | `●` | Zolty/pomaranczowy | Pliki zmodyfikowane, ale nie staged |

`N` w nawiasie to liczba plikow w danej sekcji. Wewnatrz kazdej sekcji pliki sa
wyswietlane w **drzewie katalogow** -- zachowujac strukture projektu.

### Diff stats per file

Obok kazdej nazwy pliku wyswietlane sa **diff stats**:

```
  api.py  +12 -3
```

| Element | Kolor | Znaczenie |
|---------|-------|-----------|
| `+12` | Zielony | 12 linii dodanych |
| `-3` | Czerwony | 3 linie usuniete |

To pozwala na szybka ocene **zakresu zmian** w kazdym pliku bez otwierania diffa.

### Auto-refresh

> **Twoja konfiguracja**: Git Status Panel odswierza sie automatycznie **co 30 sekund**.
> To przydatne gdy zewnetrzne narzedzia (np. Claude Code agent) modyfikuja pliki --
> panel zaktualizuje sie bez Twojej interwencji.

### Keybindings w Git Status Panel

Panel uzywa standardowych keybindow Neo-tree:

| Klawisz | Dzialanie |
|---------|-----------|
| `j` / `k` | Nawigacja miedzy plikami |
| `<CR>` (Enter) | Otworz plik |
| `a` | Dodaj nowy plik (create) |
| `d` | Usun plik |
| `r` | Zmien nazwe pliku (rename) |
| `zo` / `zc` / `za` | Fold controls |
| `q` | Zamknij panel |

### Mutual exclusion z Aerial

Git Status Panel i Aerial (outline/symbols panel) dzielą to samo miejsce
na ekranie (prawa strona). Otwarcie jednego automatycznie zamyka drugi:

| Akcja | Efekt |
|-------|-------|
| `<leader>gs` gdy Aerial otwarty | Zamyka Aerial, otwiera Git Status |
| `<leader>cs` (Aerial) gdy Git Status otwarty | Zamyka Git Status, otwiera Aerial |
| `<leader>gs` gdy Git Status otwarty | Zamyka Git Status |

Dzieki temu nie masz dwoch paneli nachodzacych na siebie -- zawsze jest czytelnie.

### File History -- peglad z Diffview

W lekcji 27 poznales `<leader>gh` (DiffviewFileHistory %). Wracamy do tego narzedzia,
bo jest kluczowe w codziennej pracy z git.

| Skrot | Dzialanie |
|-------|-----------|
| `<leader>gh` | Historia commitow dla biezacego pliku |

#### Co widac w File History

```
+------------------------------------------+-------------------------------------------+
│  Commit list                             │  Diff for selected commit                 │
│                                          │                                           │
│  a1b2c3d  Marek   Add validation  2d     │  @@ -15,4 +15,8 @@                       │
│  e4f5g6h  Marek   Fix timeout     5d     │   def process(data):                      │
│  i7j8k9l  Jan     Initial impl    1w     │  -    return data                         │
│                                          │  +    if not data:                         │
│                                          │  +        raise ValueError("empty")        │
│                                          │  +    return data                          │
│                                          │                                           │
+------------------------------------------+-------------------------------------------+
```

#### Keybindings w File History

| Klawisz | Dzialanie |
|---------|-----------|
| `j` / `k` | Nawigacja miedzy commitami |
| `<CR>` (Enter) | Pokaz diff dla wybranego commita |
| `y` | **Yank** -- skopiuj hash commita do clipboard |
| `L` | Otworz pelny commit log |
| `<Tab>` / `<S-Tab>` | Nastepny/poprzedni plik (jesli commit zmienil wiele plikow) |
| `gf` | Otworz plik |
| `q` | Zamknij |

#### Typowe zastosowania File History

- **"Kto zmienil ta funkcje?"** -- otworz plik, `<leader>gh`, przejrzyj commity
- **"Kiedy pojawil sie ten bug?"** -- nawiguj po commitach, szukaj zmiany ktora go wprowadzila
- **"Chce wrocic do starej wersji"** -- znajdz commit, skopiuj hash (`y`), uzyj `git checkout <hash> -- plik`
- **"Potrzebuje hash commita"** -- `y` kopiuje hash do clipboard

### Pelny workflow git w Neovim

Oto jak wszystkie narzedzia git lacza sie w jeden workflow:

```
 1. Edycja pliku
    │
    ├─ Gitsigns: znaki w gutter │_‾~ (lekcja 26)
    ├─ Inline blame: kto zmienil linie
    └─ ]c / [c: nawigacja miedzy hunkami
    │
 2. Podglad zmian
    │
    ├─ <leader>gp: preview hunk (floating diff)
    ├─ <leader>gD: side-by-side diff biezacego pliku
    └─ <leader>gs: Git Status Panel (przegląd wszystkich plikow)
    │
 3. Review przed commitem
    │
    ├─ <leader>gd: Diffview (wszystkie zmiany, staging)
    ├─ <leader>gh: File History (jak plik ewoluowal)
    └─ <leader>gl: Git Graph (historia branchow)
    │
 4. Operacje git
    │
    ├─ <leader>gg: LazyGit (commit, push, rebase, merge)
    ├─ <leader>gf: LazyGit current file
    └─ Cmd+Shift+D: LazyGit w tmux popup
    │
 5. Zamykanie
    │
    ├─ <leader>gc: Zamknij Diffview
    └─ q: Zamknij LazyGit / Git Graph / Git Status
```

### Mapa skrotow git -- kompletna

| Skrot | Narzedzie | Dzialanie |
|-------|-----------|-----------|
| `<leader>gb` | Gitsigns | Blame line (floating) |
| `<leader>gp` | Gitsigns | Preview hunk |
| `<leader>gD` | Gitsigns | Toggle diff file vs HEAD |
| `<leader>gd` | Diffview | Open (all changes) |
| `<leader>gc` | Diffview | Close |
| `<leader>gh` | Diffview | File history |
| `<leader>gg` | LazyGit | Open (fullscreen) |
| `<leader>gf` | LazyGit | Open (current file) |
| `<leader>gl` | Git Graph | Open (branch visualization) |
| `<leader>gs` | Neo-tree | Git Status Panel |
| `]c` / `[c` | Gitsigns | Next/prev hunk |
| `Cmd+Shift+D` | tmux | LazyGit popup |

Zauwaz, ze wszystkie skroty zaczynaja sie od `<leader>g` (g jak git) --
which-key pokaze je po nacisnieciu `<Space>g`.

---

## Cwiczenia

### Przygotowanie

```bash
cd ~/GIT/vim-tutor/exercises/git-exercise
bash setup-git-exercise.sh
cd repo
nvim .
```

### Cwiczenie 1: Git Status Panel -- podstawy

1. Dokonaj zmian w 2-3 plikach repozytorium
2. Nacisnij `<leader>gs` -- panel pojawi sie po prawej
3. Zaobserwuj sekcje: "Changes (N)" z lista zmienionych plikow
4. Przejrzyj diff stats obok kazdego pliku (+N -N)
5. Nawiguj `j`/`k` po plikach
6. Nacisnij Enter na pliku -- otworzy sie w lewym panelu
7. Zamknij panel: `<leader>gs` (toggle)

### Cwiczenie 2: Staged vs Changes

1. Otworz Git Status Panel (`<leader>gs`)
2. Otworz Diffview (`<leader>gd`) i stage kilka plikow (`s`)
3. Zamknij Diffview (`<leader>gc`)
4. Sprawdz Git Status Panel -- pliki powinny sie przeniesc do "Staged Changes"
5. Zaobserwuj roznice: staged pliki maja ikone `✚` (zielona), unstaged maja `●`

### Cwiczenie 3: Mutual exclusion z Aerial

1. Otworz plik z kodem (np. plik Python z funkcjami)
2. Otworz Aerial (outline) jesli masz taki skrot (np. `<leader>cs`)
3. Zaobserwuj panel symbols po prawej stronie
4. Nacisnij `<leader>gs` -- Aerial zniknie, pojawi sie Git Status
5. Zamknij Git Status (`<leader>gs`)
6. Otworz Aerial ponownie -- potwierdz, ze panel wraca na swoje miejsce

### Cwiczenie 4: Auto-refresh

1. Otworz Git Status Panel (`<leader>gs`)
2. Otworz terminal w tmux (np. w innym panelu: `Ctrl+b %`)
3. W terminalu dokonaj zmian w pliku repozytorium (np. `echo "test" >> plik.txt`)
4. Poczekaj do 30 sekund
5. Zaobserwuj, ze Git Status Panel zaktualizowal sie automatycznie
6. Nowy plik lub zmiana pojawi sie na liscie

### Cwiczenie 5: File History -- przegladanie

1. Otworz plik z kilkoma commitami w historii
2. Nacisnij `<leader>gh` -- otworzy sie DiffviewFileHistory
3. Nawiguj `j`/`k` po commitach
4. Na kazdym commicie nacisnij Enter -- przejrzyj diff
5. Zidentyfikuj: kto napisal kazda czesc pliku i kiedy

### Cwiczenie 6: File History -- kopiowanie hash

1. Otworz historie pliku (`<leader>gh`)
2. Nawiguj do interesujacego commita
3. Nacisnij `y` -- hash commita zostanie skopiowany do clipboard
4. Zamknij historie (`<leader>gc`)
5. Otworz terminal i wklej hash -- uzyj go do `git show <hash>`

### Cwiczenie 7: File History -- commit log

1. Otworz historie pliku (`<leader>gh`)
2. Nacisnij `L` -- otworzy sie pelny commit log
3. Przejrzyj pelne commit messages
4. Porownaj z krotkim widokiem w liscie commitow
5. Zamknij

### Cwiczenie 8: Pelny workflow -- od edycji do commita

To cwiczenie laczy narzedzia ze wszystkich 4 lekcji (26-29):

1. **Edycja**: Otworz plik, dokonaj zmian w 3 miejscach
2. **Gitsigns**: Zaobserwuj znaki w gutter, sprawdz inline blame
3. **Nawigacja hunkami**: `]c` / `[c` -- przeskocz miedzy zmianami
4. **Preview**: `<leader>gp` -- podgladnij kazdy hunk
5. **Status Panel**: `<leader>gs` -- sprawdz ktore pliki sa zmienione
6. **Diffview**: `<leader>gd` -- review wszystkich zmian
7. **Stage**: `s` w Diffview -- stage wybrane pliki
8. **Close Diffview**: `<leader>gc`
9. **LazyGit**: `<leader>gg` -- commit (`c`), wpisz message
10. **Git Graph**: `<leader>gl` -- potwierdz, ze commit jest widoczny
11. **File History**: `<leader>gh` -- sprawdz, ze plik ma nowy commit

### Cwiczenie 9: which-key discovery

1. Nacisnij `<Space>` i poczekaj -- which-key pokaze grupy
2. Nacisnij `g` -- zobaczysz WSZYSTKIE skroty git
3. Przejrzyj liste -- czy rozpoznajesz wszystkie z lekcji 26-29?
4. Sprobuj otworzyc kazde narzedzie po kolei z pamieci (bez patrzenia na liste)

---

## Cwiczenie bonusowe

**Scenariusz: debugowanie -- kto zepsul feature?**

1. Otworz plik, w ktorym "cos nie dziala" (wybierz dowolny)
2. Uzyj inline blame -- znajdz linie, ktore zostaly ostatnio zmienione
3. `<leader>gb` -- sprawdz pelny blame podejrzanej linii
4. `<leader>gh` -- otworz historie pliku
5. Nawiguj po commitach -- znajdz commit, ktory wprowadzil podejrzana zmiane
6. Skopiuj hash (`y`)
7. Sprawdz Git Graph (`<leader>gl`) -- na jakim branchu byl ten commit?
8. Otworz LazyGit (`<leader>gg`), przejdz do panelu Commits
9. Znajdz ten commit -- przejrzyj pelny diff (Enter)

**Wyzwanie**: Uzywajac tylko narzedzi Neovim (bez terminala), zidentyfikuj:
- Kto dokomal zmiany
- Na jakim branchu
- Co dokladnie zmienil (pelny diff)
- Jaki byl commit message

---

## Podsumowanie modulu 5: Git w Neovim

### Nauczone komendy -- lekcja 29

| Skrot | Dzialanie |
|-------|-----------|
| `<leader>gs` | Toggle Git Status Panel (Neo-tree, prawa strona) |
| `<leader>gh` | File History (DiffviewFileHistory %) |
| `y` (w File History) | Kopiuj hash commita |
| `L` (w File History) | Pelny commit log |

### Kompletna mapa narzedzi git (lekcje 26-29)

| Faza pracy | Narzedzie | Skrot | Lekcja |
|------------|-----------|-------|--------|
| Znaki zmian w gutter | Gitsigns | (automatyczne) | 26 |
| Kto zmienil linie | Gitsigns blame | `<leader>gb` | 26 |
| Podglad hunk | Gitsigns preview | `<leader>gp` | 26 |
| Diff pliku z HEAD | Gitsigns diff | `<leader>gD` | 26 |
| Nawigacja miedzy hunkami | Gitsigns | `]c` / `[c` | 26 |
| Review wszystkich zmian | Diffview | `<leader>gd` | 27 |
| Stage/unstage w Diffview | Diffview | `s` / `S` / `U` | 27 |
| Historia pliku | Diffview | `<leader>gh` | 29 |
| Zamknij Diffview | Diffview | `<leader>gc` | 27 |
| Commit, push, rebase | LazyGit | `<leader>gg` | 28 |
| LazyGit dla pliku | LazyGit | `<leader>gf` | 28 |
| LazyGit w tmux | tmux popup | `Cmd+Shift+D` | 28 |
| Wizualizacja branchow | Git Graph | `<leader>gl` | 28 |
| Status repozytorium | Neo-tree git | `<leader>gs` | 29 |

### Konfiguracja uzyta w tej lekcji

| Ustawienie | Wartosc | Efekt |
|------------|---------|-------|
| Git Status position | Prawa strona | Panel obok kodu |
| Git Status width | `50` | Szerokosc panelu |
| Auto-refresh | Co 30s | Automatyczna aktualizacja |
| Mutual exclusion | Aerial | Jedno okno na raz |
| Staged Changes icon | `✚` (zielony) | Wizualne rozroznienie |
| Changes icon | `●` (zolty) | Wizualne rozroznienie |

### Co dalej?

Gratulacje -- ukonczyles **modul 5: Git w Neovim**! Znasz teraz pelny zestaw narzedzi
do pracy z gitem bez opuszczania edytora. Kluczem jest praktyka -- im czesciej
uzywasz tych narzedzi zamiast terminala, tym szybciej staną sie odruchowe.

Porownanie z poprzednim workflow:

| Dawniej (terminal) | Teraz (Neovim) |
|--------------------|-----------------|
| `git diff` | `<leader>gd` (Diffview) |
| `git status` | `<leader>gs` (Git Status Panel) |
| `git log --oneline --graph` | `<leader>gl` (Git Graph) |
| `git log -p -- plik` | `<leader>gh` (File History) |
| `git blame plik` | Inline blame (automatyczny) |
| `git add && git commit` | `<leader>gg` (LazyGit) |

W nastepnym module przejdziesz do bardziej zaawansowanych tematow Neovim.
