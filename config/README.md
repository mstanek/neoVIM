# Przywrocenie konfiguracji srodowiska

Kompletna instrukcja odtworzenia srodowiska deweloperskiego: Neovim + Kitty + tmux.

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
# Neovim
mkdir -p ~/.config/nvim/lua/custom
cp config/nvim/init.lua ~/.config/nvim/init.lua
cp config/nvim/lazy-lock.json ~/.config/nvim/lazy-lock.json
cp config/nvim/lua/custom/diffview-render.lua ~/.config/nvim/lua/custom/diffview-render.lua

# Kitty
mkdir -p ~/.config/kitty
cp config/kitty/kitty.conf ~/.config/kitty/kitty.conf

# tmux
cp config/tmux/tmux.conf ~/.tmux.conf
```

Albo jednolinijkowo (z katalogu vim-tutor):

```bash
mkdir -p ~/.config/nvim/lua/custom ~/.config/kitty && \
cp config/nvim/init.lua ~/.config/nvim/ && \
cp config/nvim/lazy-lock.json ~/.config/nvim/ && \
cp config/nvim/lua/custom/diffview-render.lua ~/.config/nvim/lua/custom/ && \
cp config/kitty/kitty.conf ~/.config/kitty/ && \
cp config/tmux/tmux.conf ~/.tmux.conf
```

---

## 3. Inicjalizacja pluginow Neovim

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

## 4. Konfiguracja tmux

```bash
# Zainstaluj TPM (Tmux Plugin Manager) jesli jeszcze nie masz
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Uruchom tmux i zainstaluj pluginy
tmux
# Wewnatrz tmux: prefix + I  (Ctrl+Space, potem I)
```

---

## 5. Weryfikacja

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

## 6. Struktura plikow konfiguracji

```
config/
├── README.md                          ← ten plik
├── nvim/
│   ├── init.lua                       ← glowna konfiguracja (2534 linii)
│   │                                     vim.opt, keybindy, 49 pluginow z setupem
│   ├── lazy-lock.json                 ← pinowane wersje pluginow (49 pluginow)
│   └── lua/custom/
│       └── diffview-render.lua        ← custom renderer dla Diffview
├── kitty/
│   └── kitty.conf                     ← konfiguracja terminala Kitty
│                                         remappingi Cmd+P→Ctrl+P, Cmd+Shift+* itp.
└── tmux/
    └── tmux.conf                      ← konfiguracja tmux
                                          prefix: Ctrl+Space, popups, nawigacja
```

---

## 7. Kluczowe ustawienia

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
