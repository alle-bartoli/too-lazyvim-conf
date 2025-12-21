-- ~/.config/nvim/lua/plugins/colorscheme.lua

-- See https://www.lazyvim.org/plugins/colorscheme

return {
   {
      "craftzdog/solarized-osaka.nvim",
      lazy = true,
      proprity = 1000,
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
               floats = "dark", -- style for floating windows
            },
            sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
            day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
            hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
            dim_inactive = false, -- dims inactive windows
            lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

            --- You can override specific color groups to use other groups or a hex color
            --- function will be called with a ColorScheme table
            ---@param colors ColorScheme
            on_colors = function(colors) end,

            --- You can override specific highlights to use other groups or a hex color
            --- function will be called with a Highlights and ColorScheme table
            ---@param highlights Highlights
            ---@param colors ColorScheme
            on_highlights = function(highlights, colors) end,
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
      lazy = true,
      priority = 1000,
      opts = {
         flavour = "auto", -- latte, frappe, macchiato, mocha
         background = { -- :h background
            light = "latte",
            dark = "mocha",
         },
         transparent_background = true, -- disables setting the background color.
         show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
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
         custom_highlights = {},
         default_integrations = true,
         integrations = {
            cmp = true,
            gitsigns = true,
            nvimtree = true,
            treesitter = true,
            notify = true,
            mini = {
               enabled = true,
               indentscope_color = "",
            },
            -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
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

   -- monokai-nightasty
   {
      "polirritmico/monokai-nightasty.nvim",
      lazy = false,
      priority = 1000,
      opts = {
         dark_style_background = "transparent",
         hl_styles = {
            -- Background styles for floating windows and sidebars (panels):
            floats = "transparent", -- default, dark, transparent
            sidebars = "transparent", -- default, dark, transparent
         },
      },
   },

   -- Configure and load colorscheme
   {
      "LazyVim/LazyVim",
      opts = {
         -- colorscheme = "flow",
         -- colorscheme = "lackluster",
         -- colorscheme = "habamax",
         -- colorscheme = "grail",
         -- colorscheme = "deviuspro",
         -- colorscheme = "cosec-twilight",
         -- colorscheme = "solarized-osaka",
         colorscheme = "kanagawa",
         -- colorscheme = "monokai-nightasty",
         -- colorscheme = "angelic",
         -- colorscheme = "vesper",
         -- colorscheme = "catppuccin",
         news = { lazyvim = true, neovim = true },
      },
   },
}
