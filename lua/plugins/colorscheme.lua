-- ~/.config/nvim/lua/plugins/colorscheme.lua

-- See https://www.lazyvim.org/plugins/colorscheme

return {
   {
      "craftzdog/solarized-osaka.nvim",
      lazy = true,
      priority = 1000,
      opts = function()
         return {
            -- default settings.
            transparent = true, -- Enable this to disable setting the background color
            terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
            styles = {
               -- Style to be applied to different syntax groups
               -- Value is any valid attr-list value for `:help nvim_set_hl`
               comments = { italic = true },
               keywords = { italic = true },
               functions = {},
               variables = {},
               -- Background styles. Can be "dark", "transparent" or "normal"
               sidebars = "transparent",
               floats = "transparent", -- style for floating windows
            },
            sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
            day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
            hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
            dim_inactive = false, -- dims inactive windows
            lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

            --- You can override specific color groups to use other groups or a hex color
            --- function will be called with a ColorScheme table
            ---@param _colors table
            on_colors = function(_colors) end,

            --- You can override specific highlights to use other groups or a hex color
            --- function will be called with a Highlights and ColorScheme table
            ---@param _highlights table
            ---@param _colors table
            on_highlights = function(_highlights, _colors) end,
         }
      end,
   },

   -- flow.nvim: https://github.com/0xstepit/flow.nvim
   {
      "0xstepit/flow.nvim",
      lazy = true,
      priority = 1000,
      tag = "v2.0.1",
      opts = {
         theme = {
            style = "dark", --  "dark" | "light"
            contrast = "high", -- "default" | "high"
            transparent = true, -- true | false
         },
         colors = {
            mode = "default", -- "default" | "dark" | "light"
            fluo = "cyan", -- "pink" | "cyan" | "yellow" | "orange" | "green"
            custom = {
               saturation = "70", -- "" | string representing an integer between 0 and 100
               light = "", -- "" | string representing an integer between 0 and 100
            },
         },
         ui = {
            borders = "inverse", -- "theme" | "inverse" | "fluo" | "none"
            aggressive_spell = false, -- true | false
         },
      },
   },

   -- lackluster
   {
      "slugbyte/lackluster.nvim",
      lazy = true,
      priority = 1000,
      config = function()
         local lackluster = require("lackluster")
         local color = lackluster.color -- blue, green, red, orange, black, lack, luster, gray1-9

         lackluster.setup({
            disable_plugin = {
               bufferline = false, -- Using bufferline
               cmp = true, -- Using blink.cmp, not nvim-cmp
               dashboard = false, -- Using snacks dashboard
               flash = false, -- Using flash
               git_gutter = false,
               git_signs = false, -- Using gitsigns
               indentmini = false,
               headlines = false,
               lazy = false, -- Using lazy.nvim
               lightbulb = false,
               lsp_config = false, -- Using lspconfig
               mason = false, -- Using mason
               mini_diff = false,
               navic = false,
               noice = false, -- Using noice
               notify = false, -- Using nvim-notify
               oil = false,
               rainbow_delimiter = false,
               scrollbar = false,
               telescope = true, -- NOT using telescope
               todo_comments = false, -- Using todo-comments
               tree = false, -- Using neo-tree
               trouble = false, -- Using trouble
               which_key = false, -- Using which-key
               yanky = false,
            },
            -- tweak_color allows you to overwrite the default colors in the lackluster theme
            tweak_color = {
               -- you can set a value to a custom hexcode like' #aaaa77' (hashtag required)
               -- or if the value is 'default' or nil it will use lackluster's default color
               -- lack = "#aaaa77",
               lack = "default",
               luster = "default",
               orange = "default",
               yellow = "default",
               green = "default",
               blue = "default",
               red = "default", -- "#b817ff",
               -- WARN: Watchout! messing with grays is probs a bad idea, its very easy to shoot yourself in the foot!
               -- black = "default",
               -- gray1 = "default",
               -- gray2 = "default",
               -- gray3 = "default",
               -- gray4 = "default",
               -- gray5 = "default",
               -- gray6 = "default",
               -- gray7 = "default",
               -- gray8 = "default",
               -- gray9 = "default",
            },
            -- You can overwrite the following syntax colors by setting them to one of...
            --   1) a hexcode like "#a1b2c3" for a custom color.
            --   2) "default" or nil will just use whatever lackluster's default is.
            tweak_syntax = {
               string = "#a1d1ed",
               string_escape = color.yellow,
               comment = color.lack, -- "#78b37d", -- color.gray4, -- or gray5
               builtin = color.yellow, -- builtin modules and functions.
               type = "#e5a8ff", -- color.orange,
               keyword = "#764279",
               keyword_return = "#ffea70",
               keyword_exception = color.orange, -- "default",
            },
            -- You can overwrite the following background colors by setting them to one of...
            --   1) a hexcode like "#a1b2c3" for a custom color
            --   2) "none" for transparency
            --   3) "default" or nil will just use whatever lackluster's default is.
            tweak_background = {
               normal = "none", -- transparent
               -- normal = 'none',    -- transparent
               -- normal = '#a1b2c3', -- hexcode
               -- normal = color.green, -- lackluster color
               telescope = "default",
               menu = color.gray3,
               popup = "default",
            },
         })

         -- Setup nvim-web-devicons
         require("nvim-web-devicons").setup({
            color_icons = false,
            override = {
               ["default_icon"] = {
                  color = color.gray4,
                  name = "Default",
               },
            },
         })
      end,
   },

   -- catppuccin
   {
      "catppuccin/nvim",
      name = "catppuccin",
      lazy = false,
      priority = 1000,
      opts = {
         flavour = "auto", -- latte, frappe, macchiato, mocha
         background = { -- :h background
            light = "latte",
            dark = "mocha",
         },
         transparent_background = true, -- disables setting the background color.
         float = {
            transparent = true, -- transparent floating windows (v2.0+)
         },
         term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
         dim_inactive = {
            enabled = false, -- dims the background color of inactive window
            shade = "dark",
            percentage = 0.15, -- percentage of the shade to apply to the inactive window
         },
         no_italic = false, -- Force no italic
         no_bold = false, -- Force no bold
         no_underline = false, -- Force no underline
         styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
            comments = { "italic" }, -- Change the style of comments
            conditionals = { "italic" },
            loops = {},
            functions = {},
            keywords = {},
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
            operators = {},
            -- miscs = {}, -- Uncomment to turn off hard-coded styles
         },
         color_overrides = {},
         custom_highlights = function(colors)
            return {
               NeoTreeEndOfBuffer = { bg = "NONE" },
            }
         end,
         default_integrations = true,
         integrations = {
            cmp = true,
            gitsigns = true,
            nvimtree = true,
            treesitter = true,
            notify = true,
            neotree = true,
            snacks = { enabled = true },
            mini = {
               enabled = true,
               indentscope_color = "",
            },
         },
      },
   },

   -- angelic
   {
      "sponkurtus2/angelic.nvim",
      lazy = false,
      priority = 1000,
      -- config = function()
      --    require("angelic").setup({
      --       transparent = true, -- Boolean: Sets the background to transparent
      --       italics = {
      --          comments = true, -- Boolean: Italicizes comments
      --          keywords = true, -- Boolean: Italicizes keywords
      --          functions = true, -- Boolean: Italicizes functions
      --          strings = true, -- Boolean: Italicizes strings
      --          variables = true, -- Boolean: Italicizes variables
      --       },
      --       overrides = {}, -- A dictionary of group names, can be a function returning a dictionary or a table.
      --       palette_overrides = {},
      --    })
      --    vim.cmd.colorscheme("angelic")
      -- end,
   },

   --kanagawa
   {
      "rebelot/kanagawa.nvim",
      lazy = true,
      priority = 1000,
      opts = {
         compile = false,
         undercurl = true,
         commentStyle = { italic = true },
         functionStyle = {},
         keywordStyle = { italic = true },
         statementStyle = { bold = true },
         typeStyle = {},
         transparent = true, -- transparent background
         dimInactive = false,
         terminalColors = true,
         colors = {
            theme = {
               all = {
                  ui = {
                     bg_gutter = "none",
                  },
               },
            },
         },
         theme = "dragon", -- "wave" | "dragon" | "lotus"
         background = {
            dark = "wave",
            light = "lotus",
         },
      },
   },

   -- monokai-pro
   {
      "loctvl842/monokai-pro.nvim",
      lazy = true,
      priority = 1000,
      opts = {
         transparent_background = true,
         terminal_colors = true,
         devicons = true, -- highlight the icons of `nvim-web-devicons`
         styles = {
            comment = { italic = true },
            keyword = { italic = true }, -- any other keyword
            type = { italic = true }, -- (preferred) int, long, char, etc
            storageclass = { italic = true }, -- static, register, volatile, etc
            structure = { italic = true }, -- struct, union, enum, etc
            parameter = { italic = true }, -- parameter pass in function
            annotation = { italic = true },
            tag_attribute = { italic = true }, -- attribute of tag in reactjs
         },
         filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
         -- Enable this will disable filter option
         day_night = {
            enable = false, -- turn off by default
            day_filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
            night_filter = "spectrum", -- classic | octagon | pro | machine | ristretto | spectrum
         },
         inc_search = "background", -- underline | background
         background_clear = {
            "float_win",
            "toggleterm",
            "telescope",
            "which-key",
            "renamer",
            "notify",
            "neo-tree",
            "bufferline", -- better used if background of `neo-tree` or `nvim-tree` is cleared
         }, -- "float_win", "toggleterm", "telescope", "which-key", "renamer", "neo-tree", "nvim-tree", "bufferline"
         plugins = {
            bufferline = {
               underline_selected = false,
               underline_visible = false,
            },
            indent_blankline = {
               context_highlight = "pro", -- default | pro
               context_start_underline = false,
            },
         },
         ---@param c { base: { dimmed3: string } }
         override = function(c)
            return {
               -- Subtle static indent guides
               IblIndent = { fg = c.base.dimmed3 },
               SnacksIndent = { fg = c.base.dimmed3 },
               -- Scope/context lines keep default bright colors for visibility
            }
         end,
      },
   },

   -- black-metal
   {
      "metalelf0/black-metal-theme-neovim",
      lazy = false,
      priority = 1000,
      config = function()
         -- colors/<theme>.lua calls setup({}) on load, resetting all custom opts.
         -- Store opts in a local and re-apply them in the ColorScheme autocmd.
         local opts = {
            -----MAIN OPTIONS-----
            --
            -- Can be one of: bathory | burzum | dark-funeral | darkthrone | emperor | gorgoroth | immortal | impaled-nazarene | khold | marduk | mayhem | nile | taake | thyrfing | venom | windir
            theme = "bathory",
            -- Can be one of: 'light' | 'dark', or set via vim.o.background
            variant = "dark",
            -- Use an alternate, lighter bg
            alt_bg = false,
            -- If true, docstrings will be highlighted like strings, otherwise they will be
            -- highlighted like comments. Note, behavior is dependent on the language server.
            colored_docstrings = true,
            -- If true, highlights the {sign,fold} column the same as cursorline
            cursorline_gutter = true,
            -- If true, highlights the gutter darker than the bg
            dark_gutter = false,
            -- if true favor treesitter highlights over semantic highlights
            favor_treesitter_hl = false,
            -- Don't set background of floating windows. Recommended for when using floating
            -- windows with borders.
            plain_float = false,
            -- Show the end-of-buffer character
            show_eob = true,
            -- If true, enable the vim terminal colors
            term_colors = true,
            -- Keymap (in normal mode) to toggle between light and dark variants.
            toggle_variant_key = nil,
            -- Don't set background
            transparent = true,

            -----DIAGNOSTICS and CODE STYLE-----
            --
            diagnostics = {
               darker = true, -- Darker colors for diagnostic
               undercurl = true, -- Use undercurl for diagnostics
               background = true, -- Use background color for virtual text
            },
            -- The following table accepts values the same as the `gui` option for normal
            -- highlights. For example, `bold`, `italic`, `underline`, `none`.
            code_style = {
               comments = "italic",
               conditionals = "none",
               functions = "none",
               keywords = "none",
               headings = "bold", -- Markdown headings
               operators = "none",
               keyword_return = "none",
               strings = "none",
               variables = "none",
            },

            -----PLUGINS-----
            --
            -- The following options allow for more control over some plugin appearances.
            plugin = {
               lualine = {
                  -- Bold lualine_a sections
                  bold = true,
                  -- Don't set section/component backgrounds. Recommended to not set
                  -- section/component separators.
                  plain = false,
               },
               cmp = { -- works for nvim.cmp and blink.nvim
                  -- Don't highlight lsp-kind items. Only the current selection will be highlighted.
                  plain = false,
                  -- Reverse lsp-kind items' highlights in blink/cmp menu.
                  reverse = false,
               },
            },

            -- CUSTOM HIGHLIGHTS --
            --
            -- Override default colors
            colors = {},
            -- Override highlight groups
            highlights = {
               NeoTreeNormal = { bg = "NONE" },
               NeoTreeNormalNC = { bg = "NONE" },
            },
         }

         require("black-metal").setup(opts)

         -- accent1 = string, accent2 = type, from each palette file
         local bm_palettes = {
            bathory = { accent1 = "#fbcb97", accent2 = "#e78a43", alt_bg = "#3E2018" },
            burzum = { accent1 = "#ddeecc", accent2 = "#99bbaa", alt_bg = "#231c14" },
            ["dark-funeral"] = { accent1 = "#fbcb97", accent2 = "#d0dfee", alt_bg = "#060f23" },
            darkthrone = { accent1 = "#FFFFFF", accent2 = "#FFFFFF", alt_bg = "#000000" },
            emperor = { accent1 = "#756482", accent2 = "#A8A1DE", alt_bg = "#20173B" },
            gorgoroth = { accent1 = "#ddeecc", accent2 = "#9b8d7f", alt_bg = "#2a2325" },
            immortal = { accent1 = "#7799bb", accent2 = "#556677", alt_bg = "#1b161f" },
            ["impaled-nazarene"] = { accent1 = "#DC2A22", accent2 = "#B29740", alt_bg = "#191A11" },
            khold = { accent1 = "#eceee3", accent2 = "#974b46", alt_bg = "#39121b" },
            marduk = { accent1 = "#a5aaa7", accent2 = "#626b67", alt_bg = "#060b12" },
            mayhem = { accent1 = "#f3ecd4", accent2 = "#eecc6c", alt_bg = "#4d2020" },
            nile = { accent1 = "#aa9988", accent2 = "#777755", alt_bg = "#301807" },
            taake = { accent1 = "#a29884", accent2 = "#83756a", alt_bg = "#403035" },
            thyrfing = { accent1 = "#B04024", accent2 = "#AF4C35", alt_bg = "#31120a" },
            venom = { accent1 = "#f8f7f2", accent2 = "#fc302e", alt_bg = "#211816" },
            windir = { accent1 = "#D9D98E", accent2 = "#5E77A3", alt_bg = "#181c15" },
         }

         local function write_lazygit_theme(c)
            local path = vim.fn.expand("~/.config/lazygit/theme.yml")
            local content = string.format(
               "gui:\n"
                  .. "  theme:\n"
                  .. "    activeBorderColor:\n"
                  .. '      - "%s"\n'
                  .. "      - bold\n"
                  .. "    inactiveBorderColor:\n"
                  .. '      - "#505050"\n'
                  .. "    optionsTextColor:\n"
                  .. '      - "%s"\n'
                  .. "    selectedLineBgColor:\n"
                  .. '      - "#333333"\n'
                  .. "    cherryPickedCommitBgColor:\n"
                  .. '      - "%s"\n'
                  .. "    cherryPickedCommitFgColor:\n"
                  .. '      - "%s"\n'
                  .. "    unstagedChangesColor:\n"
                  .. '      - "#505050"\n'
                  .. "    defaultFgColor:\n"
                  .. '      - "#c1c1c1"\n'
                  .. "    searchingActiveBorderColor:\n"
                  .. '      - "%s"\n'
                  .. "      - bold\n",
               c.accent2,
               c.accent1,
               c.alt_bg,
               c.accent2,
               c.accent1
            )
            local f = io.open(path, "w")
            if f then
               f:write(content)
               f:close()
            end
         end

         vim.api.nvim_create_autocmd("ColorScheme", {
            callback = function(ev)
               -- strip -alt suffix so both "bathory" and "bathory-alt" match
               local name = ev.match:gsub("%-alt$", "")
               local palette = bm_palettes[name]
               if palette then
                  -- re-setup with our opts since colors/<theme>.lua reset M.__opts
                  opts.theme = ev.match
                  require("black-metal").setup(opts)
                  require("black-metal.highlights").setup()
                  write_lazygit_theme(palette)
               end
            end,
         })
      end,
   },

   -- Rosé Pine
   {
      "rose-pine/neovim",
      name = "rose-pine",
      lazy = false,
      priority = 1000,
      opts = {
         variant = "auto", -- auto, main, moon, or dawn
         dark_variant = "main", -- main, moon, or dawn
         dim_inactive_windows = false,
         extend_background_behind_borders = true,

         enable = {
            terminal = true,
            legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
            migrations = true, -- Handle deprecated options automatically
         },

         styles = {
            bold = true,
            italic = true,
            -- Native rose-pine transparency. Must be true: with
            -- `extend_background_behind_borders = true` and this false,
            -- rose-pine forces an opaque `palette.surface` bg on Normal,
            -- which breaks transparent mode.
            transparency = true,
         },

         groups = {
            border = "muted",
            link = "iris",
            panel = "surface",

            error = "love",
            hint = "iris",
            info = "foam",
            note = "pine",
            todo = "rose",
            warn = "gold",

            git_add = "foam",
            git_change = "rose",
            git_delete = "love",
            git_dirty = "rose",
            git_ignore = "muted",
            git_merge = "iris",
            git_rename = "pine",
            git_stage = "iris",
            git_text = "rose",
            git_untracked = "subtle",

            h1 = "iris",
            h2 = "foam",
            h3 = "rose",
            h4 = "gold",
            h5 = "pine",
            h6 = "foam",
         },

         -- Override the builtin palette per variant.
         palette = {
            -- moon = {
            --    base = "#18191a",
            --    overlay = "#363738",
            -- },
         },

         -- NOTE: Highlight groups are extended (merged) by default.
         -- Disable this per group via `inherit = false`.
         highlight_groups = {
            -- Keep Diffview side panels transparent with rosé pine.
            DiffviewNormal = { bg = "NONE" },
            DiffviewWinSeparator = { bg = "NONE" },
            -- Comment = { fg = "foam" },
            -- StatusLine = { fg = "love", bg = "love", blend = 15 },
            -- VertSplit = { fg = "muted", bg = "muted" },
            -- Visual = { fg = "base", bg = "text", inherit = false },
         },

         --- @dev Hook to mutate highlights before they are applied.
         --- @param _group string
         --- @param _highlight table
         --- @param _palette table
         before_highlight = function(_group, _highlight, _palette)
            -- Disable all undercurls:
            -- if _highlight.undercurl then
            --    _highlight.undercurl = false
            -- end
            --
            -- Swap a palette colour:
            -- if _highlight.fg == _palette.pine then
            --    _highlight.fg = _palette.foam
            -- end
         end,
      },
   },

   -- Configure and load colorscheme
   {
      "LazyVim/LazyVim",
      opts = function()
         -- Only schemes whose plugins are declared above (or builtins).
         local favorites = {
            "solarized-osaka",
            "flow",
            "lackluster",
            "catppuccin-mocha",
            "kanagawa",
            "monokai-pro",
            "angelic",
            "rose-pine",
            "bathory",
            "habamax",
         }

         local DEFAULT = "catppuccin-mocha"
         local colorscheme_file = vim.fn.stdpath("config") .. "/.colorscheme"

         --- @dev Picks a colorscheme dynamically.
         --- Priority: saved file, `$NVIM_COLORSCHEME` env var, time of day,
         --- random favorite. Falls back to `DEFAULT` if not loadable.
         --- @return string scheme Colorscheme name
         local function pick()
            local f = io.open(colorscheme_file, "r")
            if f then
               local saved = f:read("*l")
               f:close()
               if saved and #saved > 0 then
                  return saved
               end
            end
            local env = os.getenv("NVIM_COLORSCHEME")
            if env and #env > 0 then
               return env
            end
            local hour = tonumber(os.date("%H")) or 12
            if hour >= 6 and hour < 18 then
               return DEFAULT
            end
            math.randomseed(os.time())
            return favorites[math.random(#favorites)]
         end

         local chosen = pick()

         -- Guard: if scheme missing at load time, fall back to DEFAULT.
         vim.api.nvim_create_autocmd("VimEnter", {
            once = true,
            callback = function()
               local ok = pcall(vim.cmd.colorscheme, chosen)
               if not ok then
                  pcall(vim.cmd.colorscheme, DEFAULT)
               end
            end,
         })

         -- Save choice on ColorScheme change so it persists across restarts.
         vim.api.nvim_create_autocmd("ColorScheme", {
            callback = function(ev)
               local fw = io.open(colorscheme_file, "w")
               if fw then
                  fw:write(ev.match .. "\n")
                  fw:close()
               end
            end,
         })

         return {
            colorscheme = chosen,
            news = { lazyvim = true, neovim = true },
         }
      end,
   },
}
