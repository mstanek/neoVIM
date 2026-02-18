# Vim Tutor — Personalizowany kurs Neovim

Spersonalizowany kurs Neovim oparty na Twoim `init.lua`, pluginach i keybindingach.
Zamiast generycznych cwiczen — uczysz sie dokladnie tego setupu, ktorego uzywasz na co dzien.

## Srodowisko

| Element       | Wartosc                          |
|---------------|----------------------------------|
| Edytor        | Neovim (treesitter, LSP, Mason)  |
| Terminal      | Kitty                            |
| Multiplexer   | tmux (prefix: `Ctrl+Space`)      |
| Theme         | OneDark                          |
| Leader        | `Space`                          |
| Font          | Nerd Font (FontAwesome PUA)      |
| Clipboard     | `unnamedplus` (systemowy)        |
| Scrolloff     | 8                                |
| Numer linii   | absolute (bez relative)          |

## Jak korzystac

1. Otworz lekcje w jednym ukladzie split:
   ```bash
   nvim -O lessons/01-tryby-pracy.md exercises/01-tryby-pracy.md
   ```
   Lekcja po lewej, cwiczenie po prawej. Nawigacja miedzy oknami: `Ctrl+h/l`.

2. Alternatywnie — otwieraj pliki przez Telescope:
   - `<leader>ff` → wpisz nazwe lekcji
   - `<leader>fb` → przelaczaj miedzy otwartymi buforami

3. Po ukonczeniu lekcji zaznacz checkbox w `PROGRESS.md`.

4. `CHEATSHEET.md` — szybka sciaga ze wszystkimi keybindingami.

## Spis tresci

### Modul 1: Fundamenty (lekcje 1-8)

Bazowe umiejetnosci edycji tekstu w Neovim — tryby, ruchy, operatory, text objects.

| #  | Temat                  | Lekcja                                                | Cwiczenie                                                  |
|----|------------------------|-------------------------------------------------------|------------------------------------------------------------|
| 01 | Tryby pracy            | [lessons/01-tryby-pracy.md](lessons/01-tryby-pracy.md) | [exercises/practice/01-tryby-pracy.md](exercises/practice/01-tryby-pracy.md) |
| 02 | Ruchy (motions)        | [lessons/02-ruchy.md](lessons/02-ruchy.md)             | [exercises/practice/02-ruchy.md](exercises/practice/02-ruchy.md)             |
| 03 | Operatory              | [lessons/03-operatory.md](lessons/03-operatory.md)     | [exercises/practice/03-operatory.md](exercises/practice/03-operatory.md)     |
| 04 | Text objects           | [lessons/04-text-objects.md](lessons/04-text-objects.md) | [exercises/practice/04-text-objects.md](exercises/practice/04-text-objects.md) |
| 05 | Visual mode            | [lessons/05-visual-mode.md](lessons/05-visual-mode.md) | [exercises/practice/05-visual-mode.md](exercises/practice/05-visual-mode.md) |
| 06 | Szukanie               | [lessons/06-szukanie.md](lessons/06-szukanie.md)       | [exercises/practice/06-szukanie.md](exercises/practice/06-szukanie.md)       |
| 07 | Rejestry               | [lessons/07-rejestry.md](lessons/07-rejestry.md)       | [exercises/practice/07-rejestry.md](exercises/practice/07-rejestry.md)       |
| 08 | Undo / Redo            | [lessons/08-undo-redo.md](lessons/08-undo-redo.md)     | [exercises/practice/08-undo-redo.md](exercises/practice/08-undo-redo.md)     |

### Modul 2: Edycja zaawansowana (lekcje 9-14)

Pluginy i techniki przyspieszajace edycje: surround, komentarze, flash, makra.

| #  | Temat                  | Lekcja                                                          | Cwiczenie                                                              |
|----|------------------------|-----------------------------------------------------------------|------------------------------------------------------------------------|
| 09 | nvim-surround          | [lessons/09-nvim-surround.md](lessons/09-nvim-surround.md)     | [exercises/practice/09-nvim-surround.md](exercises/practice/09-nvim-surround.md) |
| 10 | Komentarze i indent    | [lessons/10-komentarze-indent.md](lessons/10-komentarze-indent.md) | [exercises/practice/10-komentarze-indent.md](exercises/practice/10-komentarze-indent.md) |
| 11 | Flash.nvim             | [lessons/11-flash-nvim.md](lessons/11-flash-nvim.md)           | [exercises/practice/11-flash-nvim.md](exercises/practice/11-flash-nvim.md) |
| 12 | Makra                  | [lessons/12-makra.md](lessons/12-makra.md)                     | [exercises/practice/12-makra.md](exercises/practice/12-makra.md)       |
| 13 | Substitution           | [lessons/13-substitution.md](lessons/13-substitution.md)       | [exercises/practice/13-substitution.md](exercises/practice/13-substitution.md) |
| 14 | Przesuwanie i repeat   | [lessons/14-przesuwanie-repeat.md](lessons/14-przesuwanie-repeat.md) | [exercises/practice/14-przesuwanie-repeat.md](exercises/practice/14-przesuwanie-repeat.md) |

### Modul 3: Nawigacja (lekcje 15-20)

Sprawne poruszanie sie miedzy plikami, buforami, oknami i foldami.

| #  | Temat                  | Lekcja                                                          | Cwiczenie                                                              |
|----|------------------------|-----------------------------------------------------------------|------------------------------------------------------------------------|
| 15 | Buffers                | [lessons/15-buffers.md](lessons/15-buffers.md)                 | [exercises/practice/15-buffers.md](exercises/practice/15-buffers.md)   |
| 16 | Windows i splits       | [lessons/16-windows-splits.md](lessons/16-windows-splits.md)   | [exercises/practice/16-windows-splits.md](exercises/practice/16-windows-splits.md) |
| 17 | Telescope              | [lessons/17-telescope.md](lessons/17-telescope.md)             | [exercises/practice/17-telescope.md](exercises/practice/17-telescope.md) |
| 18 | Neo-tree               | [lessons/18-neo-tree.md](lessons/18-neo-tree.md)               | [exercises/practice/18-neo-tree.md](exercises/practice/18-neo-tree.md) |
| 19 | Yazi                   | [lessons/19-yazi.md](lessons/19-yazi.md)                       | [exercises/practice/19-yazi.md](exercises/practice/19-yazi.md)         |
| 20 | Folding                | [lessons/20-folding.md](lessons/20-folding.md)                 | [exercises/practice/20-folding.md](exercises/practice/20-folding.md)   |

### Modul 4: LSP & Intelligence (lekcje 21-25)

Language Server Protocol — nawigacja po kodzie, diagnostyka, akcje, symbole.

| #  | Temat                  | Lekcja                                                          | Cwiczenie                                                              |
|----|------------------------|-----------------------------------------------------------------|------------------------------------------------------------------------|
| 21 | LSP nawigacja          | [lessons/21-lsp-nawigacja.md](lessons/21-lsp-nawigacja.md)     | [exercises/practice/21-lsp-nawigacja.md](exercises/practice/21-lsp-nawigacja.md) |
| 22 | LSP diagnostyka        | [lessons/22-lsp-diagnostyka.md](lessons/22-lsp-diagnostyka.md) | [exercises/practice/22-lsp-diagnostyka.md](exercises/practice/22-lsp-diagnostyka.md) |
| 23 | LSP akcje              | [lessons/23-lsp-akcje.md](lessons/23-lsp-akcje.md)             | [exercises/practice/23-lsp-akcje.md](exercises/practice/23-lsp-akcje.md) |
| 24 | Aerial i Namu          | [lessons/24-aerial-namu.md](lessons/24-aerial-namu.md)         | [exercises/practice/24-aerial-namu.md](exercises/practice/24-aerial-namu.md) |
| 25 | Trouble i Dropbar      | [lessons/25-trouble-dropbar.md](lessons/25-trouble-dropbar.md) | [exercises/practice/25-trouble-dropbar.md](exercises/practice/25-trouble-dropbar.md) |

### Modul 5: Git (lekcje 26-29)

Pelna integracja z Git — od hunkow po diffview i lazygit.

| #  | Temat                          | Lekcja                                                          | Cwiczenie                                                              |
|----|--------------------------------|-----------------------------------------------------------------|------------------------------------------------------------------------|
| 26 | Gitsigns                       | [lessons/26-gitsigns.md](lessons/26-gitsigns.md)               | [exercises/practice/26-gitsigns.md](exercises/practice/26-gitsigns.md) |
| 27 | Diffview                       | [lessons/27-diffview.md](lessons/27-diffview.md)               | [exercises/practice/27-diffview.md](exercises/practice/27-diffview.md) |
| 28 | LazyGit i Git Graph            | [lessons/28-lazygit-gitgraph.md](lessons/28-lazygit-gitgraph.md) | [exercises/practice/28-lazygit-gitgraph.md](exercises/practice/28-lazygit-gitgraph.md) |
| 29 | Git status i historia          | [lessons/29-git-status-historia.md](lessons/29-git-status-historia.md) | [exercises/practice/29-git-status-historia.md](exercises/practice/29-git-status-historia.md) |

### Modul 6: Produktywnosc (lekcje 30-33)

Zaawansowane workflow — panele, wyszukiwanie, terminal, command palette.

| #  | Temat                          | Lekcja                                                          | Cwiczenie                                                              |
|----|--------------------------------|-----------------------------------------------------------------|------------------------------------------------------------------------|
| 30 | IDE mode i panele              | [lessons/30-ide-mode-panele.md](lessons/30-ide-mode-panele.md) | [exercises/practice/30-ide-mode-panele.md](exercises/practice/30-ide-mode-panele.md) |
| 31 | Spectre i Todo                 | [lessons/31-spectre-todo.md](lessons/31-spectre-todo.md)       | [exercises/practice/31-spectre-todo.md](exercises/practice/31-spectre-todo.md) |
| 32 | Terminal i tmux                | [lessons/32-terminal-tmux.md](lessons/32-terminal-tmux.md)     | [exercises/practice/32-terminal-tmux.md](exercises/practice/32-terminal-tmux.md) |
| 33 | PPM, Command Palette i triki  | [lessons/33-tips-tricks.md](lessons/33-tips-tricks.md)         | [exercises/practice/33-tips-tricks.md](exercises/practice/33-tips-tricks.md) |

## Quick Start

```bash
# Sklonuj repo (jesli jeszcze nie masz)
cd ~/GIT && git clone <repo-url> vim-tutor

# Rozpocznij od lekcji 1
cd ~/GIT/vim-tutor
nvim -O lessons/01-tryby-pracy.md exercises/practice/01-tryby-pracy.md

# Sciaga pod reka
nvim CHEATSHEET.md
```

**Wskazowka:** Uzyj `<leader>e` (Neo-tree) zeby przegladac strukture projektu,
albo `<leader>ff` (Telescope) zeby szybko otworzyc dowolny plik.
