-- =============================================================================
-- Neovim Configuration - Full IDE Setup
-- =============================================================================

-- Wyłącz nieużywane remote plugin providery
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- === LAZY.NVIM (Plugin Manager) ===
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- === PLUGINS ===
require("lazy").setup({
  -- =========================================================================
  -- WYGLĄD
  -- =========================================================================

  -- Schemat kolorów (OneDark - jak Zed)
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      require("onedark").setup({
        style = "dark",           -- dark, darker, cool, deep, warm, warmer
        transparent = true,       -- Dla Kitty transparency
        term_colors = true,
        code_style = {
          comments = "italic",
          keywords = "none",
          functions = "none",
          strings = "none",
        },
        lualine = {
          transparent = true,
        },
      })
      require("onedark").load()

      -- Wyciszone indent guides (po załadowaniu kolorów)
      vim.api.nvim_set_hl(0, "SnacksIndent", { fg = "#292e42" })        -- Ledwo widoczne
      vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#3b4261" })   -- Aktywny scope trochę jaśniejszy

      -- Zwinięte bloki (fold) — kolor komentarza, bez tła
      vim.api.nvim_set_hl(0, "Folded", { fg = "#565f89", bg = "NONE", italic = true })
    end,
  },

  -- Mini.icons (zamiennik nvim-web-devicons - lżejszy i szybszy)
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {},
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  -- Snacks.nvim (QoL plugins by folke)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      statuscolumn = { enabled = true },
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true, animate = { duration = { step = 15, total = 150 } } },
      words = { enabled = true },
      image = {
        enabled = true,
        doc = { inline = true, float = true },
      },
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      picker = {
        enabled = true,
        sources = {
          smart = {
            filter = { cwd = true },  -- Tylko pliki z bieżącego projektu
          },
        },
      },
      indent = {
        enabled = true,
        char = "│",
        scope = { enabled = true },
      },
    },
  },

  -- Dropbar (breadcrumbs - IDE-like navigation)
  -- https://github.com/Bekaboo/dropbar.nvim
  {
    "Bekaboo/dropbar.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    opts = {},  -- Domyślna konfiguracja
  },

  -- UWAGA: 3rd/image.nvim zastąpiony przez snacks.image (nowszy, zintegrowany)

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "echasnovski/mini.icons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "onedark",
          component_separators = { left = "│", right = "│" },
          section_separators = { left = "", right = "" },
        },
      })
    end,
  },

  -- Bufferline (taby)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "echasnovski/mini.icons" },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          separator_style = "thin",
          show_buffer_close_icons = false,
          show_close_icon = false,
          diagnostics = "nvim_lsp",
        },
      })
    end,
  },

  -- Noice (ładniejsze UI)
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    config = function()
      require("noice").setup({
        lsp = { override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        }},
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
        },
      })
    end,
  },

  -- UWAGA: alpha-nvim usunięty - zastąpiony przez snacks.dashboard
  -- UWAGA: indent-blankline.nvim usunięty - zastąpiony przez snacks.indent

  -- Guess indent (automatyczne wykrywanie tabulacji/spacji)
  {
    "NMAC427/guess-indent.nvim",
    event = "BufReadPre",
    config = function()
      require("guess-indent").setup({})
    end,
  },

  -- Mini.ai (rozszerzone text objects: va), yinq, ci')
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    config = function()
      require("mini.ai").setup({
        n_lines = 500,  -- Szukaj text objects w 500 liniach
      })
    end,
  },

  -- =========================================================================
  -- MARKDOWN
  -- =========================================================================

  -- Render Markdown (ładne wyświetlanie w Neovim)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
    ft = { "markdown" },
    config = function()
      require("render-markdown").setup({
        heading = {
          enabled = true,
          icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
        },
        bullet = {
          enabled = true,
          icons = { "●", "○", "◆", "◇" },
        },
        checkbox = {
          enabled = true,
          unchecked = { icon = "󰄱 " },
          checked = { icon = "󰄵 " },
        },
        code = {
          enabled = true,
          style = "full",
          border = "thick",
        },
        pipe_table = {
          enabled = true,
          style = "full",
        },
        indent = {
          enabled = true,
          per_level = 4,    -- 4 spacje wcięcia na poziom nagłówka
          skip_level = 1,   -- Nie wcina zawartości pod h1
          skip_heading = true,  -- Nie przesuwaj nagłówków, tylko treść pod nimi
        },
      })
    end,
  },

  -- Markdown Preview (podgląd w przeglądarce z Mermaid!)
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview" },
    ft = { "markdown" },
    build = "cd app && npm install",
    config = function()
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_theme = "dark"
      vim.g.mkdp_preview_options = {
        mermaid = {
          theme = "dark",
        },
      }
    end,
  },

  -- =========================================================================
  -- NAWIGACJA I SZUKANIE
  -- =========================================================================

  -- Telescope (fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",  -- Najnowsza wersja (fix dla Neovim 0.11+)
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git/", "__pycache__", "%.pyc" },
          -- Wyłącz treesitter preview jeśli problemy
          preview = {
            treesitter = false,
          },
        },
      })
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "aerial")
    end,
  },

  -- Yazi (floating file manager)
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>E", "<cmd>Yazi<cr>", desc = "Yazi (file manager)" },
      { "<leader>ew", "<cmd>Yazi cwd<cr>", desc = "Yazi (cwd)" },
    },
    opts = {
      open_for_directories = false,  -- Nie zastępuj netrw (mamy neo-tree)
      keymaps = {
        show_help = "<f1>",
      },
      floating_window_scaling_factor = 0.9,  -- 90% ekranu
      yazi_floating_window_border = "rounded",
    },
  },

  -- Neo-tree (drzewo plików - sidebar)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "echasnovski/mini.icons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      -- Cache dla git diff stats (odświeżany co 3s)
      local git_diff_stats_cache = {}
      local git_diff_stats_time = 0
      local function get_git_diff_stats()
        local now = vim.uv.now()
        if now - git_diff_stats_time < 3000 then return git_diff_stats_cache end
        git_diff_stats_cache = {}
        git_diff_stats_time = now
        local cwd = vim.fn.getcwd()
        -- Unstaged changes
        for _, line in ipairs(vim.fn.systemlist("git -C " .. vim.fn.shellescape(cwd) .. " diff --numstat 2>/dev/null")) do
          local a, d, f = line:match("(%d+)%s+(%d+)%s+(.*)")
          if a and f then git_diff_stats_cache[cwd .. "/" .. f] = { tonumber(a), tonumber(d) } end
        end
        -- Staged changes (dodaj do istniejących)
        for _, line in ipairs(vim.fn.systemlist("git -C " .. vim.fn.shellescape(cwd) .. " diff --cached --numstat 2>/dev/null")) do
          local a, d, f = line:match("(%d+)%s+(%d+)%s+(.*)")
          if a and f then
            local existing = git_diff_stats_cache[cwd .. "/" .. f]
            if existing then
              existing[1] = existing[1] + tonumber(a)
              existing[2] = existing[2] + tonumber(d)
            else
              git_diff_stats_cache[cwd .. "/" .. f] = { tonumber(a), tonumber(d) }
            end
          end
        end
        return git_diff_stats_cache
      end

      -- Patch: grupowanie git_status w sekcje Staged/Changes (styl VS Code)
      -- Zachowuje strukturę drzewa katalogów wewnątrz każdej sekcji
      local neo_renderer = require("neo-tree.ui.renderer")
      local orig_show_nodes = neo_renderer.show_nodes
      neo_renderer.show_nodes = function(sourceItems, state, parentId, callback)
        if state.name == "git_status" and not parentId and sourceItems and #sourceItems > 0 then
          local root = sourceItems[1]
          if root and root.children and #root.children > 0 then
            -- Deep clone drzewa, filtrując pliki wg statusu
            -- expanded_ids zbiera ID katalogów do auto-rozwinięcia
            local function clone_tree(node, filter_fn, id_prefix, expanded_ids)
              if node.type == "file" then
                local s = (node.extra and node.extra.git_status) or ""
                if filter_fn(s) then
                  local clone = vim.tbl_extend("force", {}, node)
                  clone.id = id_prefix .. node.path
                  return clone
                end
                return nil
              end
              -- Directory: rekursywnie klonuj dzieci, zachowaj tylko te z plikami
              if node.children then
                local cloned_children = {}
                for _, child in ipairs(node.children) do
                  local cloned = clone_tree(child, filter_fn, id_prefix, expanded_ids)
                  if cloned then table.insert(cloned_children, cloned) end
                end
                if #cloned_children > 0 then
                  local dir_clone = vim.tbl_extend("force", {}, node)
                  dir_clone.id = id_prefix .. node.path
                  dir_clone.children = cloned_children
                  dir_clone.loaded = true
                  table.insert(expanded_ids, dir_clone.id)
                  return dir_clone
                end
              end
              return nil
            end

            local function is_staged(s)
              local idx = s:sub(1, 1)
              return idx ~= " " and idx ~= "?"
            end
            local function is_changed(s)
              local idx = s:sub(1, 1)
              local wt = #s >= 2 and s:sub(2, 2) or " "
              return wt ~= " " or idx == "?"
            end

            -- Zlicz pliki w każdej sekcji
            local staged_count, changes_count = 0, 0
            local function count_files(node, filter_fn)
              if node.type == "file" then
                local s = (node.extra and node.extra.git_status) or ""
                if filter_fn(s) then return 1 end
                return 0
              end
              local c = 0
              if node.children then
                for _, child in ipairs(node.children) do
                  c = c + count_files(child, filter_fn)
                end
              end
              return c
            end
            for _, child in ipairs(root.children) do
              staged_count = staged_count + count_files(child, is_staged)
              changes_count = changes_count + count_files(child, is_changed)
            end

            local new_children = {}
            state.default_expanded_nodes = state.default_expanded_nodes or {}

            if staged_count > 0 then
              local staged_children = {}
              local staged_expanded = {}
              for _, child in ipairs(root.children) do
                local cloned = clone_tree(child, is_staged, "staged:", staged_expanded)
                if cloned then table.insert(staged_children, cloned) end
              end
              table.insert(new_children, {
                id = "__staged__",
                name = "Staged Changes (" .. staged_count .. ")",
                path = root.path .. "/__staged__",
                type = "directory",
                loaded = true,
                children = staged_children,
                _is_section = true,
              })
              table.insert(state.default_expanded_nodes, "__staged__")
              for _, id in ipairs(staged_expanded) do
                table.insert(state.default_expanded_nodes, id)
              end
            end

            if changes_count > 0 then
              local changes_children = {}
              local changes_expanded = {}
              for _, child in ipairs(root.children) do
                local cloned = clone_tree(child, is_changed, "changes:", changes_expanded)
                if cloned then table.insert(changes_children, cloned) end
              end
              table.insert(new_children, {
                id = "__changes__",
                name = "Changes (" .. changes_count .. ")",
                path = root.path .. "/__changes__",
                type = "directory",
                loaded = true,
                children = changes_children,
                _is_section = true,
              })
              table.insert(state.default_expanded_nodes, "__changes__")
              for _, id in ipairs(changes_expanded) do
                table.insert(state.default_expanded_nodes, id)
              end
            end

            root.children = new_children
          end
        end
        return orig_show_nodes(sourceItems, state, parentId, callback)
      end

      require("neo-tree").setup({
        close_if_last_window = true,
        enable_git_status = true,
        enable_diagnostics = true,
        -- Event handler do wyłączenia numeracji linii (oficjalny sposób)
        event_handlers = {
          {
            event = "neo_tree_buffer_enter",
            handler = function()
              vim.opt_local.number = false
              vim.opt_local.relativenumber = false
              vim.opt_local.signcolumn = "no"
              vim.opt_local.statuscolumn = ""
            end,
          },
        },
        default_component_configs = {
          indent = {
            indent_size = 2,
            padding = 1,
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            with_expanders = true,
            expander_collapsed = "",
            expander_expanded = "",
          },
          icon = {
            folder_closed = "📁",
            folder_open = "📂",
            folder_empty = "📁",
            default = "📄",
            provider = function(icon, node)
              -- Ikony sekcji git_status (Staged/Changes)
              if node._is_section then
                if node.id == "__staged__" then
                  icon.text = " "
                  icon.highlight = "NeoTreeGitAdded"
                elseif node.id == "__changes__" then
                  icon.text = "● "
                  icon.highlight = "NeoTreeGitModified"
                end
                return
              end
              -- Użyj mini.icons (mockuje nvim-web-devicons API) dla plików
              if node.type == "file" then
                local devicons = require("nvim-web-devicons")
                local name = node.name
                local ext = name:match("%.(%w+)$")
                local devicon, hl = devicons.get_icon(name, ext, { default = true })
                if devicon then
                  icon.text = devicon .. " "
                  icon.highlight = hl
                end
              end
            end,
          },
          modified = { symbol = "[+]" },
          name = {
            trailing_slash = false,
            use_git_status_colors = true,
          },
          git_status = {
            symbols = {
              added     = "",
              modified  = "",
              deleted   = "✖",
              renamed   = "󰁕",
              untracked = "",
              ignored   = "",
              unstaged  = "󰄱",
              staged    = "",
              conflict  = "",
            },
          },
        },
        window = {
          width = 35,
          mappings = {
            ["<space>"] = "none",
          },
        },
        filesystem = {
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_by_name = { "node_modules", "__pycache__", ".git" },
            never_show = { ".DS_Store", "thumbs.db" },
          },
          follow_current_file = { enabled = true },
          group_empty_dirs = true,
          use_libuv_file_watcher = true,
        },
        git_status = {
          window = {
            width = 50,
            mappings = {
              ["<space>"] = "none",
            },
          },
          components = {
            diff_stats = function(config, node, _state)
              if node.type ~= "file" then return {} end
              local stats = get_git_diff_stats()
              local s = stats[node.path]
              if not s then return {} end
              local parts = {}
              if s[1] > 0 then
                table.insert(parts, { text = "+" .. s[1], highlight = "NeoTreeGitAdded" })
              end
              if s[2] > 0 then
                if #parts > 0 then table.insert(parts, { text = " ", highlight = "Normal" }) end
                table.insert(parts, { text = "-" .. s[2], highlight = "NeoTreeGitDeleted" })
              end
              if #parts > 0 then
                table.insert(parts, 1, { text = " ", highlight = "Normal" })
              end
              return parts
            end,
          },
          renderers = {
            file = {
              { "indent" },
              { "icon" },
              { "name" },
              { "diff_stats" },
            },
          },
        },
      })
    end,
  },

  -- Which-key (pokazuje skróty)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({})
    end,
  },

  -- =========================================================================
  -- GIT
  -- =========================================================================

  -- Gitsigns
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
        current_line_blame = true,
      })
    end,
  },

  -- Lazygit (TUI git client z delta integration)
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
      { "<leader>gf", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit current file" },
    },
  },

  -- Git Graph (drzewo commitów)
  {
    "isakbm/gitgraph.nvim",
    dependencies = { "sindrets/diffview.nvim" },
    opts = {
      symbols = {
        merge_commit = "M",
        commit = "*",
        merge_commit_end = "M",
        commit_end = "*",
        GVER = "│",
        GHOR = "─",
        GCLD = "╮",
        GCRD = "╭",
        GCLU = "╯",
        GCRU = "╰",
        GLRU = "┴",
        GLRD = "┬",
        GLUD = "┤",
        GRUD = "├",
        GFORKU = "┼",
        GFORKD = "┼",
      },
      format = {
        timestamp = "%Y-%m-%d %H:%M",
        fields = { "hash", "timestamp", "author", "branch_name", "tag" },
      },
      hooks = {
        -- Pokaż pełny opis commitu w popup (klawisz i)
        on_select_commit = function(commit)
          vim.notify("Commit: " .. commit.hash .. "\nNaciśnij 'i' w git graph żeby zobaczyć pełny opis", vim.log.levels.INFO)
        end,
      },
    },
    keys = {
      {
        "<leader>gl",
        function()
          require("gitgraph").draw({}, { all = true, max_count = 5000 })
        end,
        desc = "Git Graph",
      },
    },
    config = function(_, opts)
      require("gitgraph").setup(opts)
      -- Dodaj keybinding 'i' do pokazywania pełnego opisu commitu
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "gitgraph",
        callback = function()
          vim.keymap.set("n", "i", function()
            -- Pobierz hash z linii pod kursorem
            local line = vim.api.nvim_get_current_line()
            local hash = line:match("([a-f0-9]+)")
            if hash and #hash >= 7 then
              -- Pobierz pełny opis commitu
              local result = vim.fn.systemlist("git show --no-patch --format='%H%n%an <%ae>%n%ad%n%n%s%n%n%b' " .. hash)
              -- Wyświetl w floating window
              local buf = vim.api.nvim_create_buf(false, true)
              vim.api.nvim_buf_set_lines(buf, 0, -1, false, result)
              local width = math.min(80, vim.o.columns - 4)
              local height = math.min(#result + 2, vim.o.lines - 4)
              local win = vim.api.nvim_open_win(buf, true, {
                relative = "cursor",
                row = 1,
                col = 0,
                width = width,
                height = height,
                style = "minimal",
                border = "rounded",
                title = " Commit Details ",
                title_pos = "center",
              })
              -- Zamknij przez q lub Esc
              vim.keymap.set("n", "q", function() vim.api.nvim_win_close(win, true) end, { buffer = buf })
              vim.keymap.set("n", "<Esc>", function() vim.api.nvim_win_close(win, true) end, { buffer = buf })
            end
          end, { buffer = true, desc = "Show commit info" })
        end,
      })
    end,
  },

  -- =========================================================================
  -- EDYCJA
  -- =========================================================================

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  -- Comment
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Surround
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },

  -- =========================================================================
  -- NARZĘDZIA
  -- =========================================================================

  -- Toggleterm (wbudowany terminal)
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 15,
        open_mapping = [[<C-\>]],
        direction = "horizontal",
        shade_terminals = true,
        shading_factor = 2,
      })
    end,
  },

  -- Todo-comments (podświetlanie TODO/FIXME)
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({})
    end,
  },

  -- Trouble (lista diagnostics, references, quickfix)
  {
    "folke/trouble.nvim",
    dependencies = { "echasnovski/mini.icons" },
    cmd = "Trouble",
    config = function()
      require("trouble").setup({
        auto_close = true,
        focus = true,
      })
    end,
  },

  -- Spectre (search & replace w projekcie)
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Spectre",
    config = function()
      require("spectre").setup({
        highlight = {
          search = "DiffDelete",
          replace = "DiffAdd",
        },
      })
    end,
  },

  -- Flash (szybka nawigacja w pliku)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function()
      require("flash").setup({
        modes = {
          search = { enabled = false },  -- nie nadpisuj /
          char = { enabled = false },    -- nie nadpisuj f/F/t/T
        },
      })
    end,
  },

  -- Diffview (git diff) - ulepszona konfiguracja
  {
    "sindrets/diffview.nvim",
    config = function()
      -- Podmiana renderera: status za nazwą pliku/folderu, kompaktowe wcięcia
      package.loaded["diffview.scene.views.diff.render"] = require("custom.diffview-render")

      local actions = require("diffview.actions")
      require("diffview").setup({
        enhanced_diff_hl = true,  -- Lepsze podświetlanie różnic
        use_icons = true,         -- Ikony plików i folderów
        view = {
          default = {
            layout = "diff2_horizontal",  -- Side-by-side
            winbar_info = true,           -- Info w winbar
            disable_diagnostics = true,   -- Wyłącz diagnostykę w diff (czytelność)
          },
          merge_tool = {
            layout = "diff3_mixed",
          },
          file_history = {
            layout = "diff2_horizontal",
            winbar_info = true,
          },
        },
        file_panel = {
          listing_style = "tree",         -- "tree" zamiast "list" - pokazuje foldery!
          tree_options = {
            flatten_dirs = true,          -- Spłaszczone ścieżki (kompaktowy widok)
            folder_statuses = "only_folded",  -- Status tylko dla zwiniętych folderów
          },
          win_config = {
            position = "left",
            width = 40,                   -- Szerszy panel
          },
        },
        file_history_panel = {
          log_options = {
            git = {
              single_file = {
                diff_merges = "combined",
              },
              multi_file = {
                diff_merges = "first-parent",
              },
            },
          },
          win_config = {
            position = "bottom",
            height = 16,
          },
        },
        icons = {
          folder_closed = "󰉋",
          folder_open = "󰝰",
        },
        signs = {
          fold_closed = "",
          fold_open = "",
          done = "✓",
        },
        -- Keymaps dla panelu plików
        keymaps = {
          view = {
            { "n", "<tab>", actions.select_next_entry, { desc = "Next file" } },
            { "n", "<s-tab>", actions.select_prev_entry, { desc = "Prev file" } },
            { "n", "gf", actions.goto_file_edit, { desc = "Open file" } },
            { "n", "<leader>e", actions.toggle_files, { desc = "Toggle file panel" } },
            { "n", "<leader>gp", actions.focus_files, { desc = "Focus file panel" } },
          },
          file_panel = {
            { "n", "j", actions.next_entry, { desc = "Next entry" } },
            { "n", "k", actions.prev_entry, { desc = "Prev entry" } },
            { "n", "<cr>", actions.select_entry, { desc = "Select entry" } },
            { "n", "s", actions.toggle_stage_entry, { desc = "Stage/unstage" } },
            { "n", "S", actions.stage_all, { desc = "Stage all" } },
            { "n", "U", actions.unstage_all, { desc = "Unstage all" } },
            { "n", "X", actions.restore_entry, { desc = "Restore entry" } },
            { "n", "L", actions.open_commit_log, { desc = "Commit log" } },
            { "n", "zo", actions.open_fold, { desc = "Open fold" } },
            { "n", "zc", actions.close_fold, { desc = "Close fold" } },
            { "n", "za", actions.toggle_fold, { desc = "Toggle fold" } },
            { "n", "zR", actions.open_all_folds, { desc = "Open all folds" } },
            { "n", "zM", actions.close_all_folds, { desc = "Close all folds" } },
            { "n", "<c-u>", actions.scroll_view(-0.25), { desc = "Scroll up" } },
            { "n", "<c-d>", actions.scroll_view(0.25), { desc = "Scroll down" } },
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close" } },
          },
          file_history_panel = {
            { "n", "j", actions.next_entry, { desc = "Next entry" } },
            { "n", "k", actions.prev_entry, { desc = "Prev entry" } },
            { "n", "<cr>", actions.select_entry, { desc = "Select entry" } },
            { "n", "y", actions.copy_hash, { desc = "Copy commit hash" } },
            { "n", "L", actions.open_commit_log, { desc = "Commit log" } },
            { "n", "zo", actions.open_fold, { desc = "Open fold" } },
            { "n", "zc", actions.close_fold, { desc = "Close fold" } },
            { "n", "za", actions.toggle_fold, { desc = "Toggle fold" } },
            { "n", "zR", actions.open_all_folds, { desc = "Open all folds" } },
            { "n", "zM", actions.close_all_folds, { desc = "Close all folds" } },
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close" } },
          },
        },
      })

      -- === Highlight groups ===

      -- Panel plików
      vim.api.nvim_set_hl(0, "DiffviewFilePanelRootPath", { fg = "#bb9af7", bold = true })
      vim.api.nvim_set_hl(0, "DiffviewFilePanelTitle", { fg = "#7dcfff", bold = true })
      vim.api.nvim_set_hl(0, "DiffviewFilePanelCounter", { fg = "#565f89" })
      vim.api.nvim_set_hl(0, "DiffviewFilePanelPath", { fg = "#7aa2f7", italic = true })
      vim.api.nvim_set_hl(0, "DiffviewFolderName", { fg = "#7aa2f7", bold = true })
      vim.api.nvim_set_hl(0, "DiffviewFolderSign", { fg = "#7aa2f7" })
      vim.api.nvim_set_hl(0, "DiffviewFilePanelFileName", { fg = "#c0caf5" })
      vim.api.nvim_set_hl(0, "DiffviewFilePanelInsertions", { fg = "#9ece6a" })
      vim.api.nvim_set_hl(0, "DiffviewFilePanelDeletions", { fg = "#f7768e" })

      -- Kolory diff - wyraźniejsze tło dla dodanych/usuniętych linii
      vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#1a2e1a" })          -- Dodane linie (ciemny zielony)
      vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#2a1515" })       -- Usunięte linie (ciemny czerwony)
      vim.api.nvim_set_hl(0, "DiffChange", { bg = "#1a1a2e" })       -- Zmienione linie (ciemny niebieski)
      vim.api.nvim_set_hl(0, "DiffText", { bg = "#2d2d4e" })         -- Zmieniony tekst w linii (jaśniejszy)

      -- Filler lines (puste linie wyrównujące) - maksymalnie wyciszone
      vim.api.nvim_set_hl(0, "DiffviewDiffDeleteDim", { bg = "#1a1b26", fg = "#292e42" })

      -- Diffview autocmd: ustaw fillchars i wycisz filler lines w oknach diff
      vim.api.nvim_create_autocmd("User", {
        pattern = "DiffviewViewEnter",
        callback = function()
          -- Zamień przerywane linie na spacje
          vim.opt_local.fillchars:append("diff: ")
          vim.cmd("windo setlocal fillchars+=diff:\\ ")
        end,
      })
    end,
  },

  -- Colorizer (podświetlanie kolorów #ff0000)
  {
    "catgoose/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          RGB = true,
          RRGGBB = true,
          names = true,
          css = true,
          css_fn = true,
        },
      })
    end,
  },

  -- Dressing (ładniejsze UI)
  {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup({
        input = { enabled = true },
        select = { enabled = true },
      })
    end,
  },

  -- Aerial (outline/symbols po prawej stronie)
  {
    "stevearc/aerial.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
    config = function()
      require("aerial").setup({
        -- Backends per-filetype
        -- :help aerial-filetype-map
        -- UWAGA: Aerial treesitter backend ma ograniczone wsparcie symboli (issue #337)
        -- Dla Vue używamy TYLKO LSP - volar lepiej obsługuje script setup
        backends = {
          ["_"] = { "lsp", "treesitter" },  -- Domyślnie: LSP, fallback treesitter
          python = { "treesitter", "lsp" },  -- Python: treesitter (lepsza hierarchia klas)
          lua = { "treesitter", "lsp" },
          vue = { "lsp" },                   -- Vue: TYLKO LSP (treesitter ma problemy z SFC)
          typescript = { "lsp", "treesitter" },
          javascript = { "lsp", "treesitter" },
        },
        layout = {
          default_direction = "right",
          min_width = 30,
          placement = "edge",
        },
        show_guides = true,
        close_on_select = false,
        attach_mode = "global",
        -- WAŻNE: NIE synchronizuj foldów z edytorem (powoduje zwijanie kodu!)
        manage_folds = false,
        link_folds_to_tree = false,
        link_tree_to_folds = false,
        -- Filtrowanie symboli per-filetype
        -- false = pokaż wszystkie, tabela = tylko te typy
        filter_kind = {
          ["_"] = {  -- Domyślne
            "Class", "Constructor", "Enum", "Field", "Function",
            "Interface", "Method", "Module", "Property", "Struct", "Variable",
          },
          vue = {  -- Vue: tylko istotne (bez HTML elements)
            "Class", "Constructor", "Function", "Interface", "Method",
            "Property", "Variable", "Constant", "Field",
            -- Bez: Module (to są <template>, <style>), Struct (HTML tags)
          },
          python = {  -- Python: bez zmiennych lokalnych (tylko struktura)
            "Class", "Constructor", "Enum", "Field", "Function",
            "Interface", "Method", "Property",
            -- Usunięte: Variable (zmienne lokalne), Module (import), Struct
          },
        },
        -- Domyślnie rozwiń do poziomu 1 (klasy + ich metody widoczne)
        default_unfold_level = 1,
        -- Ikony dla typów symboli
        icons = {
          Class = "󰠱 ",
          Constructor = " ",
          Enum = " ",
          Field = "󰜢 ",
          Function = "󰊕 ",
          Interface = " ",
          Method = "󰆧 ",
          Property = " ",
          Struct = "󰙅 ",
          Variable = "󰀫 ",
          Constant = "󰏿 ",
        },
        post_jump_cmd = "normal! zz",
        -- Filtruj bezużyteczne symbole (np. div bez id/class)
        post_parse_symbol = function(bufnr, item, ctx)
          -- Dla Vue: ukryj HTML tagi bez identyfikatora
          if vim.bo[bufnr].filetype == "vue" then
            local name = item.name or ""
            -- Ukryj generyczne tagi HTML (div, span, etc.) bez id/class
            local generic_tags = { "div", "span", "p", "section", "article", "main", "header", "footer", "nav", "aside", "ul", "ol", "li", "table", "tr", "td", "th" }
            for _, tag in ipairs(generic_tags) do
              if name == tag or name:match("^" .. tag .. "$") then
                return false  -- Ukryj ten symbol
              end
            end
            -- Ukryj template, style, script jako top-level (ale pokaż ich zawartość)
            if name == "template" or name == "style" then
              -- Zostaw ale będą zwinięte domyślnie
            end
          end
          return true  -- Pokaż symbol
        end,
        -- Keybindings w oknie Aerial
        keymaps = {
          ["?"] = "actions.show_help",
          ["<CR>"] = "actions.jump",
          ["<C-v>"] = "actions.jump_vsplit",
          ["<C-s>"] = "actions.jump_split",
          ["p"] = "actions.scroll",
          ["<C-j>"] = "actions.down_and_scroll",
          ["<C-k>"] = "actions.up_and_scroll",
          ["{"] = "actions.prev",
          ["}"] = "actions.next",
          ["[["] = "actions.prev_up",
          ["]]"] = "actions.next_up",
          ["q"] = "actions.close",
          ["o"] = "actions.tree_toggle",      -- Rozwiń/zwiń gałąź
          ["O"] = "actions.tree_toggle_recursive",  -- Rozwiń/zwiń rekursywnie
          ["l"] = "actions.tree_open",        -- Rozwiń
          ["L"] = "actions.tree_open_recursive",
          ["h"] = "actions.tree_close",       -- Zwiń
          ["H"] = "actions.tree_close_recursive",
          ["zM"] = "actions.tree_close_all",  -- Zwiń wszystko
          ["zR"] = "actions.tree_open_all",   -- Rozwiń wszystko
        },
      })
    end,
  },

  -- Namu.nvim (fuzzy symbol picker z live preview - inspirowany Zed)
  -- https://github.com/bassamsdata/namu.nvim
  {
    "bassamsdata/namu.nvim",
    event = "VeryLazy",
    config = function()
      require("namu").setup({
        namu_symbols = {
          enable = true,
          options = {
            movement = {
              next = { "<C-n>", "<Down>" },
              previous = { "<C-p>", "<Up>" },
            },
            -- Zachowaj hierarchię symboli (klasa -> metody)
            display = {
              mode = "tree",  -- "tree" lub "flat"
              padding = 2,
            },
            -- Pokaż WSZYSTKIE symbole z LSP (nie filtruj)
            -- Pozwala to na wyświetlenie hierarchii klas
            kind_filter = {
              default = true,  -- true = pokaż wszystkie
              -- Dla Python - włącz wszystkie typy symboli
              python = {
                Class = true,
                Method = true,
                Function = true,
                Property = true,
                Field = true,
                Variable = true,  -- czasami metody są jako Variable
                Module = true,
                Namespace = true,
                Constructor = true,
              },
              typescript = true,
              typescriptreact = true,
              javascript = true,
              vue = true,
            },
            -- Stary format AllowKinds (dla kompatybilności)
            AllowKinds = {
              -- Domyślne - wszystkie ważne typy
              default = {
                "Class", "Constructor", "Enum", "EnumMember", "Function",
                "Interface", "Method", "Module", "Property", "Struct",
                "Variable", "Constant", "Field", "Object", "Namespace",
              },
              -- Python - WSZYSTKIE typy żeby zobaczyć hierarchię
              python = {
                "Class", "Method", "Function", "Property", "Field",
                "Variable", "Module", "Namespace", "Constructor",
              },
              -- TypeScript
              typescript = {
                "Class", "Constructor", "Enum", "EnumMember", "Function",
                "Interface", "Method", "Property", "Variable", "Constant",
                "TypeParameter",
              },
              -- Vue 3
              vue = {
                "Class", "Constructor", "Function", "Interface", "Method",
                "Property", "Variable", "Constant", "Field",
              },
              -- Lua
              lua = { "Function", "Method", "Module", "Field", "Variable" },
            },
            -- BlockList - NIE blokuj nic na razie (debugging)
            BlockList = {
              default = {},
              python = {},  -- Wyłączone tymczasowo dla debugowania
            },
            -- Row position
            row_position = "top10",
          },
        },
        -- Włącz watchtower dla multi-buffer symbols z treesitter fallback
        watchtower = {
          enable = true,
        },
      })
    end,
    keys = {
      { "<leader>ss", "<cmd>Namu symbols<cr>", desc = "Namu: Jump to symbol" },
      { "<leader>sw", "<cmd>Namu workspace<cr>", desc = "Namu: Workspace symbols" },
      -- Alternatywnie: bezpośrednio treesitter symbols
      { "<leader>st", function()
        require("namu.namu_symbols").show_treesitter()
      end, desc = "Namu: Treesitter symbols" },
    },
  },

  -- =========================================================================
  -- LSP (IntelliSense)
  -- =========================================================================

  -- Mason (installer LSP)
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- Mason-lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "pyright",        -- Python
          "ts_ls",          -- TypeScript/JavaScript
          "vue_ls",         -- Vue 3 language server
          "lua_ls",         -- Lua
          "jsonls",         -- JSON
          "yamlls",         -- YAML
          "html",           -- HTML
          "cssls",          -- CSS
        },
        automatic_installation = true,
      })
    end,
  },

  -- Mason-tool-installer (automatyczna instalacja formaterów/linterów)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Formatery
          "stylua",         -- Lua formatter
          "black",          -- Python formatter
          "isort",          -- Python import sorter
          "prettier",       -- JS/TS/Vue/CSS/HTML formatter
          -- Lintery (opcjonalne - LSP zazwyczaj wystarczy)
          "ruff",           -- Python linter (szybszy niż flake8)
        },
        auto_update = false,
        run_on_start = true,
      })
    end,
  },

  -- Conform.nvim (formatowanie kodu z format-on-save)
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      -- Formatery per-filetype
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
      -- Format on save (wyłącz jeśli przeszkadza)
      format_on_save = function(bufnr)
        -- Wyłącz dla dużych plików lub niektórych filetypes
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return
        end
        -- Wyłącz dla plików > 1MB
        local max_filesize = 1024 * 1024 -- 1MB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
        if ok and stats and stats.size > max_filesize then
          return
        end
        return {
          timeout_ms = 500,
          lsp_fallback = true,
        }
      end,
    },
  },

  -- LSP Config (nvim 0.11 native vim.lsp.config API)
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Diagnostic Config (ładniejszy wygląd błędów)
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        },
        virtual_text = {
          source = "if_many",
          spacing = 2,
        },
      })

      -- LSP Document Highlight (podświetla wszystkie wystąpienia symbolu pod kursorem)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-highlight", { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- Aerial on_attach - wymagane dla LSP backend
          pcall(function()
            require("aerial").on_attach(client, event.buf)
          end)

          -- Nowe standardowe LSP keymaps (kickstart.nvim style)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Nawigacja (gr* prefix - "go reference")
          map("grr", vim.lsp.buf.references, "References")
          map("gri", vim.lsp.buf.implementation, "Implementation")
          map("grd", vim.lsp.buf.definition, "Definition")
          map("grt", vim.lsp.buf.type_definition, "Type Definition")
          map("grD", vim.lsp.buf.declaration, "Declaration")

          -- Akcje (gr* prefix)
          map("grn", vim.lsp.buf.rename, "Rename")
          map("gra", vim.lsp.buf.code_action, "Code Action", { "n", "x" })

          -- Dokumentacja
          map("gK", vim.lsp.buf.signature_help, "Signature Help")

          if client and client.supports_method("textDocument/documentHighlight") then
            local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight-" .. event.buf, { clear = true })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("lsp-highlight-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                pcall(vim.api.nvim_del_augroup_by_name, "lsp-highlight-" .. event2.buf)
              end,
            })
          end

          -- Toggle Inlay Hints (jeśli LSP wspiera)
          if client and client.supports_method("textDocument/inlayHint") then
            vim.keymap.set("n", "<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, { buffer = event.buf, desc = "Toggle Inlay Hints" })
          end
        end,
      })

      -- Capabilities dla wszystkich serwerów
      vim.lsp.config("*", { capabilities = capabilities })

      -- Python
      vim.lsp.config("pyright", {})

      -- TypeScript/JavaScript (z Vue support przez @vue/typescript-plugin)
      vim.lsp.config("ts_ls", {
        init_options = {
          plugins = {
            {
              name = "@vue/typescript-plugin",
              location = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
              languages = { "vue" },
            },
          },
        },
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
      })

      -- Vue (Hybrid mode dla Vue 3)
      vim.lsp.config("vue_ls", {
        init_options = {
          vue = { hybridMode = true },
        },
        settings = {
          vue = {
            codeActions = { enabled = true },
            completion = {
              casing = { tags = "autoKebab", props = "autoKebab" },
            },
          },
        },
      })

      -- Lua
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = { diagnostics = { globals = { "vim" } } },
        },
      })

      -- JSON
      vim.lsp.config("jsonls", {})

      -- YAML
      vim.lsp.config("yamlls", {
        filetypes = { "yaml" },
      })

      -- HTML
      vim.lsp.config("html", {})

      -- CSS
      vim.lsp.config("cssls", {})

      -- Uruchom wszystkie serwery
      vim.lsp.enable({
        "pyright", "ts_ls", "vue_ls", "lua_ls",
        "jsonls", "yamlls", "html", "cssls",
      })
    end,
  },

  -- =========================================================================
  -- AUTOCOMPLETION
  -- =========================================================================

  -- LuaSnip (snippety)
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  -- nvim-cmp (autocompletion)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- =========================================================================
  -- TREESITTER (branch master = stare stabilne API)
  -- https://github.com/nvim-treesitter/nvim-treesitter
  -- Wymaga: brew install tree-sitter tree-sitter-cli
  -- =========================================================================

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",  -- WAŻNE: master ma nvim-treesitter.configs
    build = ":TSUpdate",
    lazy = false,
    config = function()
      -- Fix: tree-sitter >= 0.25 usunął --no-bindings
      local install = require("nvim-treesitter.install")
      install.ts_generate_args = { "generate", "--abi", vim.treesitter.language_version }
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash", "c", "diff", "html", "css", "javascript", "jsdoc",
          "json", "jsonc", "lua", "luadoc", "luap", "markdown",
          "markdown_inline", "python", "query", "regex",
          "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
          "vue", "sql",
        },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- UWAGA: nvim-treesitter-textobjects usunięty (niekompatybilny z Neovim 0.11)
  -- Używaj mini.ai dla text objects (af, if, ac, ic) - już zainstalowany!
  -- Nawigacja po funkcjach: użyj Aerial ({/}) lub LSP (gd, gr)
}, {
  rocks = {
    hererocks = true,
  },
})

-- =============================================================================
-- USTAWIENIA PODSTAWOWE
-- =============================================================================

vim.opt.encoding = "utf-8"
vim.opt.fileencodings = "utf-8,latin1"  -- Kolejność prób odczytu
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.showmatch = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true

-- Statuscolumn - zarządzany przez snacks.statuscolumn
-- vim.opt.statuscolumn = "%=%{v:lnum} │ %s"  -- WYŁĄCZONE - snacks.statuscolumn

-- Wcięcia
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

-- Folding (zwijanie bloków)
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99          -- Domyślnie wszystko rozwinięte
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- Wyszukiwanie
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Live preview substytucji (:s/foo/bar/) w split window
vim.opt.inccommand = "split"

-- Wizualizacja whitespace (taby, trailing spaces, nbsp)
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.fillchars:append("diff: ")  -- Puste filler lines w diff zamiast ─────

-- Nawigacja
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.wrap = true
vim.opt.linebreak = true

-- Zachowanie
vim.opt.hidden = true
vim.opt.mouse = "a"
vim.opt.updatetime = 300

-- Clipboard sync z systemem (scheduled dla szybszego startu)
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)
vim.opt.timeoutlen = 300
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.confirm = true        -- Dialog "Save changes?" zamiast błędu przy :q
vim.opt.breakindent = true    -- Zawiniętę linie zachowują wcięcie
vim.opt.showmode = false      -- Nie pokazuj INSERT/VISUAL (masz w lualine)

-- Winbar - zarządzany przez dropbar.nvim (breadcrumbs)
-- vim.opt.winbar = "%=%m %{expand('%:~:.')}"  -- WYŁĄCZONE - dropbar.nvim

-- Pliki
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.config/nvim/undodir")
vim.fn.mkdir(vim.fn.expand("~/.config/nvim/undodir"), "p")

-- Undercurl support (dla LSP errors w Kitty/tmux)
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- =============================================================================
-- MENU KONTEKSTOWE (PPM)
-- =============================================================================

-- Wyczyść domyślne menu nvim + pluginów
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("popup-menu", { clear = true }),
  once = true,
  callback = function()
    pcall(vim.cmd, "aunmenu PopUp")
    -- Wyłącz wbudowane MenuPopup autocmdy z nvim 0.11 (_defaults.lua)
    for _, au in ipairs(vim.api.nvim_get_autocmds({ event = "MenuPopup" })) do
      pcall(vim.api.nvim_del_autocmd, au.id)
    end

    local e = function(s) return s:gsub(" ", "\\ ") end
    local m = function(label, hint, cmd)
      vim.cmd("anoremenu PopUp." .. e(label .. " [" .. hint .. "]") .. " " .. cmd)
    end
    local sep = function(id)
      vim.cmd("anoremenu PopUp.-" .. id .. "- <Nop>")
    end

    -- Clipboard (visual mode dla cut/copy, normal+visual dla paste)
    vim.cmd("vmenu PopUp." .. e("Cut") ..            ' "+x')
    vim.cmd("vmenu PopUp." .. e("Copy") ..           ' "+y')
    vim.cmd("nmenu PopUp." .. e("Paste") ..          ' "+gP')
    vim.cmd("vmenu PopUp." .. e("Paste") ..          ' "+gP')
    vim.cmd("anoremenu PopUp." .. e("Select All") .. " ggVG")
    sep("clip")

    -- Edit (comment, indent)
    vim.cmd("nmenu PopUp." .. e("Comment Line [gcc]") .. " gcc")
    vim.cmd("vmenu PopUp." .. e("Comment Block [gc]") .. " gc")
    vim.cmd("vmenu PopUp." .. e("Indent [>]") ..         " >gv")
    vim.cmd("vmenu PopUp." .. e("Outdent [<]") ..        " <gv")
    sep("edit_basic")

    -- Navigate
    m("Go to Definition",  "gd",      "<cmd>lua vim.lsp.buf.definition()<CR>")
    m("Peek Definition",   "gp",      "<cmd>normal gp<CR>")
    m("Go Back",           "Ctrl+O",  "<C-o>")
    m("References",        "gr",      "<cmd>lua vim.lsp.buf.references()<CR>")
    m("Implementation",    "gri",     "<cmd>lua vim.lsp.buf.implementation()<CR>")
    m("Type Definition",   "grt",     "<cmd>lua vim.lsp.buf.type_definition()<CR>")
    sep("nav")

    -- Info
    m("Hover Info",        "K",        "<cmd>lua vim.lsp.buf.hover()<CR>")
    m("Signature Help",    "gK",       "<cmd>lua vim.lsp.buf.signature_help()<CR>")
    m("Line Diagnostics",  "Space ld", "<cmd>lua vim.diagnostic.open_float()<CR>")
    sep("info")

    -- Edit
    m("Rename Symbol",     "Space rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
    m("Code Action",       "Space ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
    m("Format Buffer",     "Space cf", "<cmd>lua require('conform').format({async=true, lsp_fallback=true})<CR>")
    sep("edit")

    -- Search
    m("Find File",         "Space ff", "<cmd>Telescope find_files<CR>")
    m("Grep in Files",     "Space fg", "<cmd>Telescope live_grep<CR>")
    m("Find Symbol",       "Space ss", "<cmd>Namu symbols<CR>")
    m("Search Word",       "Space sw", "<cmd>Telescope grep_string<CR>")
    sep("search")

    -- Git
    m("Git Blame",         "Space gb", "<cmd>Gitsigns blame_line<CR>")
    m("Git Diff",          "Space gd", "<cmd>DiffviewOpen<CR>")
    m("Diff File",         "Space gD", "<cmd>Gitsigns diffthis<CR>")
    m("File History",      "Space gh", "<cmd>DiffviewFileHistory %<CR>")
    m("LazyGit",           "Space gg", "<cmd>LazyGit<CR>")
    sep("git")

    -- Folds
    m("Unfold All",        "Space cR", "<cmd>normal! zR<CR>")
    sep("folds")

    -- Panels
    m("IDE Mode",          "Space i",  "<cmd>lua do local o=false; for _,w in ipairs(vim.api.nvim_list_wins()) do if vim.bo[vim.api.nvim_win_get_buf(w)].filetype=='neo-tree' then o=true; break end end; if o then vim.cmd('Neotree close'); vim.cmd('AerialClose') else vim.cmd('Neotree show'); vim.defer_fn(function() vim.cmd('AerialOpen'); vim.cmd('wincmd p') end, 100) end end<CR>")
    m("File Explorer",     "Space e",  "<cmd>Neotree toggle<CR>")
    m("Outline",           "Space o",  "<cmd>AerialToggle<CR>")
    m("Git Status",        "Space gs", "<cmd>lua do for _,w in ipairs(vim.api.nvim_list_wins()) do if vim.bo[vim.api.nvim_win_get_buf(w)].filetype=='aerial' then vim.cmd('AerialClose'); break end end; vim.cmd('Neotree git_status toggle right') end<CR>")
    m("Diagnostics",       "Space xx", "<cmd>Trouble diagnostics toggle<CR>")
  end,
})

-- =============================================================================
-- SKRÓTY KLAWISZOWE
-- =============================================================================

vim.g.mapleader = " "

-- Podstawowe
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", function()
  -- Policz "edytorskie" okna (bez neo-tree, aerial, itp.)
  local editor_wins = 0
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    local ft = vim.bo[vim.api.nvim_win_get_buf(w)].filetype
    if ft ~= "neo-tree" and ft ~= "aerial" and ft ~= "trouble" and ft ~= "notify" and ft ~= "" then
      editor_wins = editor_wins + 1
    end
  end
  if editor_wins <= 1 then
    vim.cmd("qa")
  else
    vim.cmd("q")
  end
end, { desc = "Quit (smart)" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
vim.keymap.set("n", "<leader><space>", ":nohlsearch<CR>", { desc = "Clear search", silent = true })

-- Terminal
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Smart open (Cmd+P) — Kitty wysyła Ctrl+P
vim.keymap.set("n", "<C-p>", function() Snacks.picker.smart() end, { desc = "Smart open (Cmd+P)" })
-- Command palette (Cmd+Shift+P) — Kitty wysyła Ctrl+Q
vim.keymap.set("n", "<C-q>", ":Telescope commands<CR>", { desc = "Command palette (Cmd+Shift+P)" })
-- Buffer switching (Ctrl+Tab / Ctrl+Shift+Tab) — Kitty wysyła Ctrl+T / Ctrl+Y
vim.keymap.set("n", "<C-t>", ":BufferLineCycleNext<CR>", { desc = "Next buffer (Ctrl+Tab)" })
vim.keymap.set("n", "<C-y>", ":BufferLineCyclePrev<CR>", { desc = "Prev buffer (Ctrl+Shift+Tab)" })

-- Peek definition (podgląd definicji w floating window)
vim.keymap.set("n", "gp", function()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result)
    if not result or vim.tbl_isempty(result) then
      vim.notify("Brak definicji", vim.log.levels.WARN)
      return
    end
    local def = result[1] or result
    local uri = def.uri or def.targetUri
    local range = def.range or def.targetSelectionRange
    if not uri or not range then return end
    local bufnr = vim.uri_to_bufnr(uri)
    vim.fn.bufload(bufnr)
    local start_line = range.start.line
    local lines = vim.api.nvim_buf_get_lines(bufnr, math.max(0, start_line - 2), start_line + 20, false)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    local ft = vim.bo[bufnr].filetype
    if ft ~= "" then vim.bo[buf].filetype = ft end
    local width = math.min(100, math.max(60, #(lines[1] or "") + 10))
    vim.api.nvim_open_win(buf, true, {
      relative = "cursor",
      row = 1,
      col = 0,
      width = width,
      height = math.min(#lines, 20),
      style = "minimal",
      border = "rounded",
      title = " Peek: " .. vim.fn.fnamemodify(vim.uri_to_fname(uri), ":~:.") .. " ",
      title_pos = "center",
    })
    vim.api.nvim_win_set_cursor(0, { math.min(3, #lines), 0 })
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, desc = "Close peek" })
    vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", { buffer = buf, desc = "Close peek" })
  end)
end, { desc = "Peek definition" })

-- Telescope
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Help" })
vim.keymap.set("n", "<leader>fr", ":Telescope oldfiles<CR>", { desc = "Recent files" })
vim.keymap.set("n", "<leader>fk", ":Telescope keymaps<CR>", { desc = "Keymaps (wszystkie skróty)" })
vim.keymap.set("n", "<leader>fs", ":Telescope aerial<CR>", { desc = "Find symbols (aerial)" })
vim.keymap.set("n", "<leader>sr", ":Telescope resume<CR>", { desc = "Search Resume (kontynuuj)" })
vim.keymap.set("n", "<leader>sw", ":Telescope grep_string<CR>", { desc = "Search Word (pod kursorem)" })
vim.keymap.set("n", "<leader>sd", ":Telescope diagnostics<CR>", { desc = "Search Diagnostics" })
vim.keymap.set("n", "<leader>/", function()
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "Fuzzy search in buffer" })

-- Neo-tree
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "File explorer" })

-- Buffers
vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bd", function()
  local buf = vim.api.nvim_get_current_buf()
  local bufs = vim.fn.getbufinfo({ buflisted = 1 })
  if #bufs <= 1 then
    vim.cmd("enew") -- ostatni bufor — otwórz pusty
  else
    vim.cmd("BufferLineCycleNext")
  end
  pcall(vim.api.nvim_buf_delete, buf, {})
end, { desc = "Delete buffer" })

-- Nawigacja między oknami
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Helper: przeskocz do okna edytora (nie sidebar)
local function focus_editor_win()
  local cur_ft = vim.bo.filetype
  if cur_ft == "neo-tree" or cur_ft == "aerial" or cur_ft == "trouble" then
    for _, w in ipairs(vim.api.nvim_list_wins()) do
      local ft = vim.bo[vim.api.nvim_win_get_buf(w)].filetype
      if ft ~= "neo-tree" and ft ~= "aerial" and ft ~= "trouble" and ft ~= "notify" and ft ~= "" then
        vim.api.nvim_set_current_win(w)
        return true
      end
    end
  end
  return false
end

-- LSP (z ochroną przed otwarciem w sidebarze)
vim.keymap.set("n", "gd", function() focus_editor_win(); vim.lsp.buf.definition() end, { desc = "Go to definition" })
vim.keymap.set("n", "gr", function() focus_editor_win(); vim.lsp.buf.references() end, { desc = "References" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line diagnostics" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- Git
vim.keymap.set("n", "<leader>gb", ":Gitsigns blame_line<CR>", { desc = "Git blame" })
vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>", { desc = "Diffview open" })
vim.keymap.set("n", "<leader>gD", function()
  -- Toggle: jeśli diff jest otwarty, zamknij go
  if vim.wo.diff then
    -- Zamknij okno HEAD (gitsigns tworzy bufor z prefiksem "gitsigns://")
    for _, w in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(w)
      local name = vim.api.nvim_buf_get_name(buf)
      if name:match("^gitsigns://") then
        vim.api.nvim_win_close(w, true)
        break
      end
    end
    -- Przywróć winbar i wyłącz diff w bieżącym oknie
    vim.wo.winbar = ""
    vim.cmd("diffoff")
    return
  end
  -- Otwórz diff
  local cur_win = vim.api.nvim_get_current_win()
  local wins_before = vim.api.nvim_list_wins()
  require("gitsigns").diffthis()
  vim.schedule(function()
    local head_win = nil
    for _, w in ipairs(vim.api.nvim_list_wins()) do
      local is_new = true
      for _, wb in ipairs(wins_before) do
        if w == wb then is_new = false; break end
      end
      if is_new then head_win = w; break end
    end
    if head_win then
      vim.wo[head_win].winbar = "%#DiffDelete# HEAD (index) %*"
    end
    vim.wo[cur_win].winbar = "%#DiffAdd# Current (working) %*"
  end)
end, { desc = "Toggle diff current file" })
vim.keymap.set("n", "<leader>gc", ":DiffviewClose<CR>", { desc = "Diffview close" })
vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory %<CR>", { desc = "File history" })
-- LazyGit (TUI git client)
vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "LazyGit" })
vim.keymap.set("n", "<leader>gf", ":LazyGitCurrentFile<CR>", { desc = "LazyGit current file" })
-- Git Graph (drzewo commitów)
vim.keymap.set("n", "<leader>gl", function()
  require("gitgraph").draw({}, { all = true, max_count = 5000 })
end, { desc = "Git log (graph)" })

-- Todo-comments
vim.keymap.set("n", "<leader>ft", ":TodoTelescope<CR>", { desc = "Find TODOs" })
vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next TODO" })
vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Prev TODO" })

-- Trouble (diagnostics, references)
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics" })
vim.keymap.set("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "LSP Defs/Refs (Trouble)" })
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })

-- Spectre (search & replace w projekcie)
vim.keymap.set("n", "<leader>S", function() require("spectre").toggle() end, { desc = "Toggle Spectre" })
vim.keymap.set("n", "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end, { desc = "Search current word (Spectre)" })
vim.keymap.set("v", "<leader>sw", function() require("spectre").open_visual() end, { desc = "Search selection (Spectre)" })
vim.keymap.set("n", "<leader>sp", function() require("spectre").open_file_search({ select_word = true }) end, { desc = "Search in current file (Spectre)" })

-- Flash (szybka nawigacja)
vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash jump" })
vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })

-- Markdown
vim.keymap.set("n", "<leader>mp", ":MarkdownPreviewToggle<CR>", { desc = "Markdown preview (browser)" })
vim.keymap.set("n", "<leader>mr", ":RenderMarkdown toggle<CR>", { desc = "Render markdown toggle" })

-- IDE mode (neo-tree + aerial)
vim.keymap.set("n", "<leader>i", function()
  local neotree_open = false
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(w)].filetype == "neo-tree" then
      neotree_open = true
      break
    end
  end

  if neotree_open then
    vim.cmd("Neotree close")
    vim.cmd("AerialClose")
  else
    vim.cmd("Neotree show")
    vim.defer_fn(function()
      vim.cmd("AerialOpen")
      vim.cmd("wincmd p")
    end, 100)
  end
end, { desc = "Toggle IDE mode (panels)" })

-- Aerial (outline) — zamyka git_status jeśli otwarty
vim.keymap.set("n", "<leader>o", function()
  -- Zamknij git_status panel jeśli jest otwarty (wymienność)
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(w)
    local ft = vim.bo[buf].filetype
    local name = vim.api.nvim_buf_get_name(buf)
    if ft == "neo-tree" and name:match("git_status") then
      vim.cmd("Neotree git_status close")
      break
    end
  end
  vim.cmd("AerialToggle")
end, { desc = "Toggle outline" })

-- Git status panel (prawy, wymiennie z aerial)
vim.keymap.set("n", "<leader>gs", function()
  -- Zamknij aerial jeśli otwarty (wymienność)
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(w)].filetype == "aerial" then
      vim.cmd("AerialClose")
      break
    end
  end
  vim.cmd("Neotree git_status toggle right")
end, { desc = "Git status panel" })

-- Auto-refresh git_status co 30s (dla zmian zewnętrznych, np. Claude Code agent)
local git_status_timer = vim.uv.new_timer()
git_status_timer:start(30000, 30000, vim.schedule_wrap(function()
  -- Odświeżaj tylko gdy panel git_status jest otwarty
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(w)
    local name = vim.api.nvim_buf_get_name(buf)
    if vim.bo[buf].filetype == "neo-tree" and name:match("git_status") then
      pcall(vim.cmd, "Neotree git_status show right")
      return
    end
  end
end))
vim.keymap.set("n", "<leader>O", ":AerialNavToggle<CR>", { desc = "Aerial navigation" })
-- Ręczne odświeżenie symboli (pomocne dla Vue gdy LSP wolno startuje)
vim.keymap.set("n", "<leader>or", function()
  require("aerial").refetch_symbols()
  vim.notify("Aerial: symbols refreshed", vim.log.levels.INFO)
end, { desc = "Refresh outline symbols" })
-- Bezpieczna nawigacja z pcall (ignoruje błędy gdy bufor się zmienił)
vim.keymap.set("n", "{", function()
  pcall(function() require("aerial").prev() end)
end, { desc = "Prev symbol" })
vim.keymap.set("n", "}", function()
  pcall(function() require("aerial").next() end)
end, { desc = "Next symbol" })

-- Dropbar (breadcrumbs picker)
vim.keymap.set("n", "<leader>dp", function() require("dropbar.api").pick() end, { desc = "Dropbar pick" })

-- Fold/unfold komentarzy + docstringów (treesitter)
vim.keymap.set("n", "<leader>cc", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
  if not lang then
    vim.notify("Brak treesitter parsera dla tego typu pliku", vim.log.levels.WARN)
    return
  end

  local parser = vim.treesitter.get_parser(bufnr, lang)
  if not parser then return end
  local tree = parser:parse()[1]
  if not tree then return end

  vim.opt_local.foldmethod = "manual"
  vim.cmd("normal! zE")

  -- Python: komentarze + docstringi, inne języki: tylko komentarze
  local query_str = (lang == "python")
    and "[(comment) (expression_statement (string))] @c"
    or "(comment) @c"

  local ok, query = pcall(vim.treesitter.query.parse, lang, query_str)
  if not ok then
    vim.notify("Nie można znaleźć komentarzy dla " .. lang, vim.log.levels.WARN)
    return
  end

  local comments = {}
  for _, node in query:iter_captures(tree:root(), bufnr, 0, -1) do
    local sr, _, er, _ = node:range()
    if er > sr then -- tylko wieloliniowe bloki (pomijaj inline)
      table.insert(comments, { sr + 1, er + 1 })
    end
  end
  -- Jednoliniowe komentarze — scal sąsiednie w bloki
  for _, node in query:iter_captures(tree:root(), bufnr, 0, -1) do
    local sr, _, er, _ = node:range()
    if er == sr then
      table.insert(comments, { sr + 1, er + 1 })
    end
  end
  table.sort(comments, function(a, b) return a[1] < b[1] end)

  local blocks = {}
  for _, c in ipairs(comments) do
    local last = blocks[#blocks]
    if last and c[1] <= last[2] + 1 then
      last[2] = math.max(last[2], c[2])
    else
      table.insert(blocks, { c[1], c[2] })
    end
  end

  local count = 0
  for _, b in ipairs(blocks) do
    pcall(vim.cmd, b[1] .. "," .. b[2] .. "fold")
    count = count + 1
  end
  vim.notify("Zwinięto " .. count .. " bloków komentarzy/docstringów", vim.log.levels.INFO)
end, { desc = "Fold all comments" })

vim.keymap.set("n", "<leader>cC", function()
  vim.opt_local.foldmethod = "expr"
  vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.cmd("normal! zR")
  vim.notify("Przywrócono treesitter folding", vim.log.levels.INFO)
end, { desc = "Unfold comments (restore)" })

vim.keymap.set("n", "<leader>cR", "zR", { desc = "Unfold all (open all folds)" })

-- Przesuwanie linii
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Zachowaj zaznaczenie
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Config
vim.keymap.set("n", "<leader>ve", ":e $MYVIMRC<CR>", { desc = "Edit config" })
vim.keymap.set("n", "<leader>vr", ":source $MYVIMRC<CR>", { desc = "Reload config" })

-- =============================================================================
-- AUTOCMDS
-- =============================================================================

-- IDE mode nie jest otwierany automatycznie — użyj <leader>i żeby włączyć/wyłączyć

-- Highlight on yank (podświetlenie tekstu przy kopiowaniu)
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
})

-- Filetype specific
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "vue", "json" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "yaml",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- Trailing whitespace
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Remember cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Ukryj winbar/dropbar w specjalnych buforach
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "neo-tree", "snacks_dashboard", "Trouble", "trouble", "lazy", "mason", "toggleterm", "spectre_panel", "aerial", "gitgraph" },
  callback = function()
    vim.opt_local.winbar = nil
  end,
})

-- Aerial: Automatycznie zwiń wszystko po otwarciu okna Aerial
vim.api.nvim_create_autocmd("User", {
  pattern = "AerialOpen",
  callback = function()
    -- Małe opóźnienie żeby Aerial zdążył załadować symbole
    vim.defer_fn(function()
      pcall(function()
        require("aerial").tree_close_all()
      end)
    end, 50)
  end,
})

-- Wymuś synchronizację scroll w Diffview
vim.api.nvim_create_autocmd("User", {
  pattern = "DiffviewViewEnter",
  callback = function()
    -- Synchronizuj scroll wszystkich okien diff
    vim.cmd("windo set scrollbind")
    vim.cmd("syncbind")
  end,
})

-- Vue SFC: Treesitter ma problemy z foldingiem (nvim-treesitter#7459)
-- Używamy indent-based folding dla Vue zamiast treesitter expr
vim.api.nvim_create_autocmd("FileType", {
  pattern = "vue",
  callback = function()
    -- Indent folding działa lepiej dla Vue niż treesitter
    vim.opt_local.foldmethod = "indent"
    vim.opt_local.foldlevel = 99  -- Domyślnie rozwinięte
    -- Odśwież Aerial po załadowaniu LSP
    vim.defer_fn(function()
      pcall(function()
        require("aerial").refetch_symbols()
      end)
    end, 500)
  end,
})

-- =============================================================================
-- TODO NOTES - interaktywne zarządzanie taskami (*/notes/todo.md)
-- =============================================================================

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*/notes/todo.md",
  callback = function(ev)
    local buf = ev.buf
    local map = function(key, fn, desc)
      vim.keymap.set("n", key, fn, { buffer = buf, desc = "Todo: " .. desc })
    end

    -- Helper: znajdź linię z nagłówkiem sekcji
    local function find_section(name)
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      for i, line in ipairs(lines) do
        if line:match("^## " .. name) then
          return i -- 1-indexed
        end
      end
      return nil
    end

    -- Helper: znajdź pierwszą pustą linię lub koniec sekcji (następny ##)
    local function find_section_end(section_line)
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local last_task = section_line
      for i = section_line + 1, #lines do
        if lines[i]:match("^## ") then
          return last_task
        end
        if lines[i]:match("^%- %[.%]") then
          last_task = i
        end
      end
      return last_task
    end

    -- Helper: dzisiejsza data
    local function today()
      return os.date("%Y-%m-%d")
    end

    -- Helper: dodaj timestamp @created jeśli nie ma
    local function with_created(line)
      if not line:match("@created") then
        return line .. " @created(" .. today() .. ")"
      end
      return line
    end

    -- Helper: przenieś aktualną linię do sekcji
    local function move_to_section(section_name)
      local row = vim.api.nvim_win_get_cursor(0)[1]
      local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]

      -- Tylko linie z taskami
      if not line:match("^%- %[.%]") then
        vim.notify("Nie task", vim.log.levels.WARN)
        return
      end

      -- Znajdź sekcję docelową
      local section_line = find_section(section_name)
      if not section_line then
        -- Utwórz sekcję na końcu
        local last = vim.api.nvim_buf_line_count(buf)
        vim.api.nvim_buf_set_lines(buf, last, last, false, { "", "## " .. section_name, "" })
        section_line = last + 2
      end

      -- Przy przenoszeniu do Done - zaznacz jako ukończone + dodaj @done
      if section_name == "Done" then
        line = line:gsub("%- %[ %]", "- [x]")
        line = line:gsub(" @done%([^)]*%)", "")  -- Usuń stary @done
        line = line .. " @done(" .. today() .. ")"
      end
      -- Przy przenoszeniu do In Progress/Backlog - odznacz + usuń @done
      if section_name == "In Progress" or section_name == "Backlog" then
        line = line:gsub("%- %[x%]", "- [ ]")
        line = line:gsub(" @done%([^)]*%)", "")
      end

      -- Usuń z aktualnej pozycji
      vim.api.nvim_buf_set_lines(buf, row - 1, row, false, {})

      -- Przelicz pozycję sekcji (mogła się przesunąć po usunięciu)
      section_line = find_section(section_name)
      local insert_at = find_section_end(section_line)

      -- Wstaw po ostatnim tasku w sekcji
      vim.api.nvim_buf_set_lines(buf, insert_at, insert_at, false, { line })

      -- Ustaw kursor na przeniesionym tasku
      vim.api.nvim_win_set_cursor(0, { insert_at + 1, 0 })

      vim.cmd("silent write")
      vim.notify("→ " .. section_name, vim.log.levels.INFO)
    end

    -- ═══ Keybindings (Space+t prefix) ═══

    -- Zarejestruj grupę w which-key
    pcall(function()
      require("which-key").add({
        { "<leader>t", group = "Todo", buffer = buf, icon = "󰄵" },
      })
    end)

    -- Toggle checkbox [ ] ↔ [x]  (Enter jako bonus - nie wymaga prefix)
    map("<CR>", function()
      local row = vim.api.nvim_win_get_cursor(0)[1]
      local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]
      if line:match("%- %[ %]") then
        line = line:gsub("%- %[ %]", "- [x]", 1)
      elseif line:match("%- %[x%]") then
        line = line:gsub("%- %[x%]", "- [ ]", 1)
      else
        return
      end
      vim.api.nvim_buf_set_lines(buf, row - 1, row, false, { line })
      vim.cmd("silent write")
    end, "Toggle checkbox")

    map("<leader>tx", function()
      local row = vim.api.nvim_win_get_cursor(0)[1]
      local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]
      if line:match("%- %[ %]") then
        move_to_section("Done")
      elseif line:match("%- %[x%]") then
        move_to_section("In Progress")
      end
    end, "Toggle done (move)")

    -- Dodawanie tasków
    map("<leader>ta", function()
      local row = vim.api.nvim_win_get_cursor(0)[1]
      vim.api.nvim_buf_set_lines(buf, row, row, false, { "- [ ] " })
      vim.api.nvim_win_set_cursor(0, { row + 1, 6 })
      vim.cmd("startinsert!")
    end, "Add task below")

    -- Helper: dodaj nowy task do sekcji
    local function add_to_section(section_name)
      local section = find_section(section_name)
      if not section then
        vim.notify("Brak sekcji '## " .. section_name .. "'", vim.log.levels.WARN)
        return
      end
      local insert_at = find_section_end(section)
      vim.api.nvim_buf_set_lines(buf, insert_at, insert_at, false, { "- [ ] " })
      vim.api.nvim_win_set_cursor(0, { insert_at + 1, 6 })
      vim.cmd("startinsert!")
    end

    map("<leader>tI", function() add_to_section("In Progress") end, "New → In Progress")
    map("<leader>tB", function() add_to_section("Backlog") end, "New → Backlog")

    -- Przenoszenie między sekcjami
    map("<leader>td", function() move_to_section("Done") end, "Move → Done")
    map("<leader>ti", function() move_to_section("In Progress") end, "Move → In Progress")
    map("<leader>tb", function() move_to_section("Backlog") end, "Move → Backlog")

    -- Usuwanie
    map("<leader>tD", function()
      local row = vim.api.nvim_win_get_cursor(0)[1]
      local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]
      if line:match("^%- %[.%]") then
        vim.api.nvim_buf_set_lines(buf, row - 1, row, false, {})
        vim.cmd("silent write")
        vim.notify("Task usunięty", vim.log.levels.INFO)
      end
    end, "Delete task")

    -- Przesuwanie tasków w sekcji
    map("<leader>tk", function()
      local row = vim.api.nvim_win_get_cursor(0)[1]
      local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]
      if not line:match("^%- %[.%]") then return end
      if row < 2 then return end
      local above = vim.api.nvim_buf_get_lines(buf, row - 2, row - 1, false)[1]
      if above and above:match("^%- %[.%]") then
        vim.api.nvim_buf_set_lines(buf, row - 2, row, false, { line, above })
        vim.api.nvim_win_set_cursor(0, { row - 1, 0 })
        vim.cmd("silent write")
      end
    end, "Move task up")

    map("<leader>tj", function()
      local row = vim.api.nvim_win_get_cursor(0)[1]
      local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]
      if not line:match("^%- %[.%]") then return end
      local below = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
      if below and below:match("^%- %[.%]") then
        vim.api.nvim_buf_set_lines(buf, row - 1, row + 1, false, { below, line })
        vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
        vim.cmd("silent write")
      end
    end, "Move task down")

    -- Archiwizacja starych tasków z Done (>7 dni)
    local function archive_done_tasks(days)
      days = days or 7
      local done_line = find_section("Done")
      if not done_line then return 0 end

      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local cutoff = os.time() - (days * 86400)
      local to_archive = {}
      local rows_to_remove = {}

      for i = done_line + 1, #lines do
        local line = lines[i]
        if line:match("^## ") then break end
        if line:match("^%- %[x%]") then
          local done_date = line:match("@done%((%d%d%d%d%-%d%d%-%d%d)%)")
          if done_date then
            local y, m, d = done_date:match("(%d+)-(%d+)-(%d+)")
            local done_time = os.time({ year = tonumber(y), month = tonumber(m), day = tonumber(d) })
            if done_time < cutoff then
              table.insert(to_archive, line)
              table.insert(rows_to_remove, i)
            end
          end
        end
      end

      if #to_archive == 0 then return 0 end

      -- Dopisz do pliku archiwum
      local todo_path = vim.api.nvim_buf_get_name(buf)
      local archive_path = vim.fn.fnamemodify(todo_path, ":h") .. "/archive.md"

      local archive_content = {}
      local f = io.open(archive_path, "r")
      if f then
        for l in f:lines() do
          table.insert(archive_content, l)
        end
        f:close()
      else
        table.insert(archive_content, "# Archive")
        table.insert(archive_content, "")
      end

      table.insert(archive_content, "## " .. os.date("%Y-%m-%d"))
      for _, task in ipairs(to_archive) do
        table.insert(archive_content, task)
      end
      table.insert(archive_content, "")

      local af = io.open(archive_path, "w")
      if af then
        af:write(table.concat(archive_content, "\n") .. "\n")
        af:close()
      end

      -- Usuń z bufora (od dołu żeby indeksy się nie przesunęły)
      for i = #rows_to_remove, 1, -1 do
        vim.api.nvim_buf_set_lines(buf, rows_to_remove[i] - 1, rows_to_remove[i], false, {})
      end
      vim.cmd("silent write")

      return #to_archive
    end

    map("<leader>tA", function()
      local count = archive_done_tasks(7)
      if count > 0 then
        vim.notify("Zarchiwizowano " .. count .. " tasków", vim.log.levels.INFO)
      else
        vim.notify("Brak tasków do archiwizacji (>7 dni)", vim.log.levels.INFO)
      end
    end, "Archive old Done")

    -- Auto-archiwizacja przy otwarciu pliku
    vim.defer_fn(function()
      local count = archive_done_tasks(7)
      if count > 0 then
        vim.notify("Auto-archive: " .. count .. " tasków", vim.log.levels.INFO)
      end
    end, 200)

    -- Auto-save + auto-timestamp przy wyjściu z insert mode
    vim.api.nvim_create_autocmd("InsertLeave", {
      buffer = buf,
      callback = function()
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]
        -- Dodaj @created do nowych tasków (mają treść ale brak @created)
        if line and line:match("^%- %[ %] .+") and not line:match("@created") then
          line = with_created(line)
          vim.api.nvim_buf_set_lines(buf, row - 1, row, false, { line })
        end
        if vim.bo[buf].modified then
          vim.cmd("silent write")
        end
      end,
    })

    -- Wyłącz rozpraszacze
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.statuscolumn = ""
    vim.opt_local.spell = false
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    -- conceallevel zarządzany przez render-markdown
  end,
})

-- =============================================================================
-- GOTOWE! Naciśnij <Space> i poczekaj - which-key pokaże wszystkie skróty
-- =============================================================================
