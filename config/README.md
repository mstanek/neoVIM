# Przywrocenie konfiguracji srodowiska

Kompletna instrukcja odtworzenia srodowiska deweloperskiego: Neovim + Kitty + tmux + Yazi + LazyGit.

> Snapshot z: 2026-02-18
> System: macOS (Apple Silicon / arm64)

---

## 1. Wymagania systemowe (Homebrew)

### Instalacja Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Narzedzia wymagane przez Neovim i pluginy

```bash
# Edytor i terminal
brew install neovim kitty tmux

# Wyszukiwanie i nawigacja (Telescope, Neo-tree, FZF)
brew install ripgrep fd fzf

# Git (LazyGit, Git Graph, Diffview)
brew install lazygit git-delta

# Manager plikow (Yazi)
brew install yazi ffmpegthumbnailer

# Jezyki i LSP (Mason wymaga node i python)
brew install node python@3.14

# Obsluga obrazkow w terminalu (image.nvim)
brew install imagemagick luarocks

# Dodatkowe narzedzia uzywane w tmux popups
brew install btop lazydocker

# Tree-sitter CLI (opcjonalnie, do kompilacji parserow)
brew install tree-sitter-cli
```

### Czcionki (Nerd Fonts — wymagane przez ikony)

```bash
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-meslo-lg-nerd-font
brew install --cask font-symbols-only-nerd-font
```

### Instalacja z pliku (zalecane)

```bash
xargs brew install < config/brew-formulae.txt
xargs brew install --cask < config/brew-casks.txt
```

---

## 2. Kopiowanie konfiguracji

```bash
# Zsh
cp config/zsh/zshrc ~/.zshrc
cp config/zsh/zprofile ~/.zprofile

# Git
cp config/git/gitconfig ~/.gitconfig
cp config/git/gitignore_global ~/.gitignore_global
mkdir -p ~/.config/delta
cp config/delta/unified.gitconfig ~/.config/delta/

# Neovim
mkdir -p ~/.config/nvim/lua/custom
cp config/nvim/init.lua ~/.config/nvim/
cp config/nvim/lazy-lock.json ~/.config/nvim/
cp config/nvim/lua/custom/diffview-render.lua ~/.config/nvim/lua/custom/

# Kitty
mkdir -p ~/.config/kitty
cp config/kitty/kitty.conf ~/.config/kitty/
cp config/kitty/startup.session ~/.config/kitty/

# tmux
cp config/tmux/tmux.conf ~/.tmux.conf

# Skrypty tmux (Cmd+Shift+* popups)
mkdir -p ~/.local/bin
cp config/scripts/tmux-* ~/.local/bin/
chmod +x ~/.local/bin/tmux-*

# Starship prompt
cp config/starship.toml ~/.config/starship.toml

# Yazi
mkdir -p ~/.config/yazi
cp config/yazi/*.toml config/yazi/init.lua ~/.config/yazi/

# LazyGit
mkdir -p ~/.config/lazygit
cp config/lazygit/config.yml ~/.config/lazygit/

# Atuin (shell history)
mkdir -p ~/.config/atuin
cp config/atuin/config.toml ~/.config/atuin/

# Pet (snippet manager)
mkdir -p ~/.config/pet
cp config/pet/*.toml ~/.config/pet/

# Btop
mkdir -p ~/.config/btop
cp config/btop/btop.conf ~/.config/btop/
```

Albo jednolinijkowo (z katalogu vim-tutor):

```bash
mkdir -p ~/.config/{nvim/lua/custom,kitty,yazi,lazygit,delta,atuin,pet,btop} ~/.local/bin && \
cp config/zsh/zshrc ~/.zshrc && cp config/zsh/zprofile ~/.zprofile && \
cp config/git/gitconfig ~/.gitconfig && cp config/git/gitignore_global ~/.gitignore_global && \
cp config/delta/unified.gitconfig ~/.config/delta/ && \
cp config/nvim/init.lua config/nvim/lazy-lock.json ~/.config/nvim/ && \
cp config/nvim/lua/custom/diffview-render.lua ~/.config/nvim/lua/custom/ && \
cp config/kitty/kitty.conf config/kitty/startup.session ~/.config/kitty/ && \
cp config/tmux/tmux.conf ~/.tmux.conf && \
cp config/scripts/tmux-* ~/.local/bin/ && chmod +x ~/.local/bin/tmux-* && \
cp config/starship.toml ~/.config/starship.toml && \
cp config/yazi/*.toml config/yazi/init.lua ~/.config/yazi/ && \
cp config/lazygit/config.yml ~/.config/lazygit/ && \
cp config/atuin/config.toml ~/.config/atuin/ && \
cp config/pet/*.toml ~/.config/pet/ && \
cp config/btop/btop.conf ~/.config/btop/
```

---

## 3. Inicjalizacja pluginow Yazi

```bash
# Zainstaluj pluginy zdefiniowane w package.toml
ya pkg install
```

---

## 4. Inicjalizacja pluginow Neovim

```bash
# Pierwsze uruchomienie — Lazy.nvim zainstaluje sie automatycznie
nvim

# Wewnatrz Neovim:
# :Lazy sync          — zainstaluje pluginy w dokladnych wersjach z lazy-lock.json
# :Mason              — otworzy manager LSP serverow
# :MasonToolsInstall  — zainstaluje skonfigurowane LSP/formattery/lintery
# :TSUpdate           — zaktualizuje parsery Tree-sitter
```

---

## 5. Konfiguracja tmux

```bash
# Zainstaluj TPM (Tmux Plugin Manager) jesli jeszcze nie masz
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Uruchom tmux i zainstaluj pluginy
tmux
# Wewnatrz tmux: prefix + I  (Ctrl+Space, potem I)
```

---

## 6. Weryfikacja

Po instalacji sprawdz czy wszystko dziala:

```bash
# Sprawdz wersje
nvim --version          # >= 0.11
kitty --version         # >= 0.45
tmux -V                 # >= 3.6
rg --version            # ripgrep
fd --version
lazygit --version
yazi --version

# Sprawdz czy Neovim startuje bez bledow
nvim --headless "+Lazy! sync" +qa

# Sprawdz LSP (otworz plik TS/Python i poczekaj na Mason)
nvim exercises/python/calculator.py
# :LspInfo  — powinien pokazac aktywny LSP
```

---

## 7. Struktura plikow konfiguracji

```
config/
├── README.md                          ← ten plik
├── brew-formulae.txt                  ← lista pakietow brew
├── brew-casks.txt                     ← lista czcionek (cask)
├── zsh/
│   ├── zshrc                          ← aliasy, PATH, pluginy, prompt
│   └── zprofile                       ← profil logowania
├── git/
│   ├── gitconfig                      ← user, delta pager, rebase, diff
│   └── gitignore_global               ← globalne wykluczenia (.DS_Store, *~)
├── delta/
│   └── unified.gitconfig              ← konfiguracja delta (git diff pager)
├── nvim/
│   ├── init.lua                       ← glowna konfiguracja (2534 linii)
│   │                                     vim.opt, keybindy, 49 pluginow z setupem
│   ├── lazy-lock.json                 ← pinowane wersje pluginow (49 pluginow)
│   └── lua/custom/
│       └── diffview-render.lua        ← custom renderer dla Diffview
├── kitty/
│   ├── kitty.conf                     ← konfiguracja terminala Kitty
│   │                                     remappingi Cmd+P→Ctrl+P, Cmd+Shift+* itp.
│   └── startup.session                ← auto-start tmux przy starcie Kitty
├── tmux/
│   └── tmux.conf                      ← konfiguracja tmux
│                                         prefix: Ctrl+Space, popups, nawigacja
├── starship.toml                      ← konfiguracja Starship prompt
├── scripts/                           ← skrypty tmux popups (Cmd+Shift+*)
│   ├── tmux-notes                     ← Cmd+Shift+N: notatki
│   ├── tmux-notes-toggle              ← Cmd+Shift+N: toggle notatek
│   ├── tmux-scratch                   ← Cmd+Shift+S: scratchpad
│   ├── tmux-cheatsheet                ← Cmd+Shift+K: sciaga skrotow
│   ├── tmux-git-quick                 ← Cmd+Shift+G: szybkie operacje git
│   ├── tmux-git-diff                  ← helper: git diff
│   ├── tmux-journal                   ← Cmd+Shift+J: dziennik
│   ├── tmux-shortcuts-help            ← Cmd+Shift+?: pomoc skrotow
│   ├── tmux-claude-account            ← Cmd+Shift+A: Claude account switcher
│   ├── tmux-pet                       ← pet snippets helper
│   ├── tmux-pet-clip                  ← Cmd+Shift+P: pet clipboard
│   ├── tmux-pet-menu                  ← pet menu helper
│   ├── tmux-notes-count               ← licznik notatek (statusbar)
│   └── tmux-notes-preview             ← podglad notatek
├── yazi/
│   ├── yazi.toml                      ← glowna konfiguracja (manager, preview, opener)
│   ├── keymap.toml                    ← keybindy (sort, search, view, goto, plugins)
│   ├── theme.toml                     ← Catppuccin Mocha theme + ikony Nerd Font
│   ├── init.lua                       ← pluginy: git, starship, bookmarks, yatline
│   └── package.toml                   ← lista pluginow (ya pkg install)
├── lazygit/
│   └── config.yml                     ← konfiguracja LazyGit
├── atuin/
│   └── config.toml                    ← Atuin — inteligentna historia shella
├── pet/
│   ├── config.toml                    ← Pet — snippet manager config
│   └── snippet.toml                   ← zapisane snippety
└── btop/
    └── btop.conf                      ← Btop — monitor systemowy
```

---

## 8. Kluczowe ustawienia

| Ustawienie          | Wartosc                           |
|---------------------|-----------------------------------|
| Leader              | `Space`                           |
| tmux prefix         | `Ctrl+Space`                      |
| Theme               | OneDark                           |
| Font                | JetBrains Mono Nerd Font          |
| Clipboard           | `unnamedplus` (systemowy)         |
| Scrolloff           | 8                                 |
| Numer linii         | absolute (bez relative)           |
| Tab/indent          | 2 spacje (auto-detect przez guess-indent) |
| Format on save      | tak (conform.nvim)                |

### Lista pluginow (49)

**Wyglad:** onedark, lualine, bufferline, noice, nvim-notify, dressing, mini.icons, nvim-colorizer, render-markdown, which-key

**Edycja:** nvim-surround, Comment.nvim, nvim-autopairs, flash.nvim, mini.ai, guess-indent, LuaSnip, friendly-snippets

**Completion:** nvim-cmp, cmp-nvim-lsp, cmp-buffer, cmp-path, cmp_luasnip

**LSP:** nvim-lspconfig, mason, mason-lspconfig, mason-tool-installer, conform.nvim

**Nawigacja:** telescope, telescope-fzf-native, neo-tree, yazi, aerial, namu, snacks

**Git:** gitsigns, diffview, lazygit, gitgraph

**Narzedzia:** trouble, todo-comments, nvim-spectre, toggleterm, dropbar, image.nvim

**Tree-sitter:** nvim-treesitter

**Biblioteki:** plenary, nui
