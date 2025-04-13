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

   -- midnight-desert.nvim
   {
      "CosecSecCot/midnight-desert.nvim",
      dependencies = {
         "rktjmp/lush.nvim",
      },
   },

   -- chama-chomo/grail
   {
      "chama-chomo/grail",
      version = false,
      lazy = false,
      priority = 1000, -- make sure to load this before all the other start plugins.
      -- Optional.
      -- Default configuration will be used if setup isn't called.
      config = function()
         require("grail").setup({
            -- Your config here.
            transparent_background_level = 1,
            background = "hard",
            disable_italic_comments = false,
            italics = true,
         })
      end,
   },

   -- deviuspro.nvim
   {
      "DeviusVim/deviuspro.nvim",
   },

   -- flow.nvim
   {
      "0xstepit/flow.nvim",
      lazy = false,
      priority = 1000,
      tag = "v2.0.0",
      opts = {
         theme = {
            --style = "dark", --  "dark" | "light"
            --contrast = "default", -- "default" | "high"
            transparent = true, -- true | false
         },
         --colors = {
         --mode = "default", -- "default" | "dark" | "light"
         --fluo = "pink", -- "pink" | "cyan" | "yellow" | "orange" | "green"
         --},
         --ui = {
         -- borders = "inverse", -- "theme" | "inverse" | "fluo" | "none"
         -- aggressive_spell = false, -- true | false
         --},
         config = function(_, opts)
            require("flow").setup(opts)
            vim.cmd("colorscheme flow")
         end,
      },
   },

   -- lackluster
   {
      "slugbyte/lackluster.nvim",
      lazy = false,
      priority = 1000,
      init = function()
         local lackluster = require("lackluster")

         local color = lackluster.color -- blue, green, red, orange, black, lack, luster, gray1-9

         lackluster.setup({
            disable_plugin = {
               bufferline = false,
               cmp = true,
               dashboard = false,
               flash = false,
               git_gutter = false,
               git_signs = false,
               indentmini = false,
               headlines = false,
               lazy = false,
               lightbulb = false,
               lsp_config = false,
               mason = false,
               mini_diff = false,
               navic = false,
               noice = false,
               notify = false,
               oil = false,
               rainbow_delimiter = false,
               scrollbar = false,
               telescope = true,
               todo_comments = false,
               tree = false,
               trouble = false,
               which_key = false,
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
               string = "#a1d1ed", -- "#e5a8ff",
               string_escape = color.yellow,
               comment = color.gray5, -- "#78b37d", -- color.gray4, -- or gray5
               builtin = color.yellow, -- builtin modules and functions.
               type = "#e5a8ff", -- color.orange,
               keyword = "#764279",
               keyword_return = "#ffea70",
               keyword_exception = "#ffea70", -- "default",
            },
            -- You can overwrite the following background colors by setting them to one of...
            --   1) a hexcode like "#a1b2c3" for a custom color
            --   2) "none" for transparency
            --   3) "default" or nil will just use whatever lackluster's default is.
            tweak_background = {
               normal = "none", -- transparent
               -- normal = 'none',    -- transparent
               -- normal = '#a1b2c3',    -- hexcode
               -- normal = color.green,    -- lackluster color
               telescope = "none",
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

         -- !must set colorscheme after calling setup()!
         -- vim.cmd.colorscheme("lackluster")
         vim.cmd.colorscheme("lackluster-hack") -- my favorite
         -- vim.cmd.colorscheme("lackluster-mint")
      end,
   },

   -- vesper
   {
      "datsfilipe/vesper.nvim",
      config = function()
         require("vesper").setup({
            -- Your config here
            transparent = true, -- Boolean: Sets the background to transparent
            italics = {
               comments = true, -- Boolean: Italicizes comments
               keywords = true, -- Boolean: Italicizes keywords
               functions = true, -- Boolean: Italicizes functions
               strings = true, -- Boolean: Italicizes strings
               variables = true, -- Boolean: Italicizes variables
            },
            overrides = {}, -- A dictionary of group names, can be a function returning a dictionary or a table
            palette_overrides = {},
            --highlights = require("vesper").bufferline.highlights, -- To use the theme with bufferline.nvim, you can use the following configuration
         })
      end,
   },
}
