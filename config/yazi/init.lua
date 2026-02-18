-- =============================================================================
-- Yazi Plugin Configuration
-- =============================================================================

-- Git status (pokazuje status Git przy plikach: M, A, D, ?)
require("git"):setup()

-- Full border (ładne ramki jak w Neovim)
require("full-border"):setup()

-- Starship prompt w headerze (jeśli masz zainstalowany starship)
require("starship"):setup()

-- Bookmarks - zakładki (m = mark, ' = jump)
require("bookmarks"):setup({
    -- Ostatnio odwiedzone katalogi
    last_directory_jump = true,
    -- Notify przy zapisie zakładki
    notify = {
        enable = true,
        message = {
            new = "Bookmark saved!",
            delete = "Bookmark deleted!",
        },
    },
    -- Persistence - zakładki zapisywane między sesjami
    persist = "all",
})

-- =============================================================================
-- Yatline - Custom status bar with Catppuccin Mocha theme
-- =============================================================================
local catppuccin_theme = require("yatline-catppuccin"):setup("mocha")

require("yatline"):setup({
    theme = catppuccin_theme,
    show_background = true,

    -- Header line (góra)
    header_line = {
        left = {
            section_a = {
                { type = "line", custom = false, name = "tabs", params = { "left" } },
            },
            section_b = {},
            section_c = {},
        },
        right = {
            section_a = {
                { type = "string", custom = false, name = "date", params = { "%H:%M" } },
            },
            section_b = {},
            section_c = {
                { type = "string", custom = true, name = "R·efresh  f·ind  F·zf  /·filter  s+search  S+sort  V+view  g+goto  c+copy  T·preview  H·idden  m·ark  ?·help" },
            },
        },
    },

    -- Status line (dół)
    status_line = {
        left = {
            section_a = {
                { type = "string", custom = false, name = "tab_mode" },
            },
            section_b = {
                { type = "string", custom = false, name = "hovered_size" },
            },
            section_c = {
                { type = "string", custom = false, name = "hovered_path" },
                { type = "coloreds", custom = false, name = "count" },
            },
        },
        right = {
            section_a = {
                { type = "string", custom = false, name = "cursor_position" },
            },
            section_b = {
                { type = "string", custom = false, name = "cursor_percentage" },
            },
            section_c = {
                { type = "string", custom = false, name = "hovered_file_extension", params = { true } },
                { type = "coloreds", custom = false, name = "permissions" },
            },
        },
    },
})
