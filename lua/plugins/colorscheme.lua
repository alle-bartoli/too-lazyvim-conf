-- See https://www.lazyvim.org/plugins/colorscheme
return {
   {
      "craftzdog/solarized-osaka.nvim",
      lazy = true,
      proprity = 1000,
      opts = function()
         return {
            transparent = true,
         }
      end,
   },

   -- midnight-desert.nvim.
   {
      "CosecSecCot/midnight-desert.nvim",
      dependencies = {
         "rktjmp/lush.nvim",
      },
   },

   -- chama-chomo/grail.
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

   -- deviuspro.nvim.
   {
      "DeviusVim/deviuspro.nvim",
   },

   -- flow.nvim.
   {
      "0xstepit/flow.nvim",
      lazy = false,
      priority = 1000,
      opts = {
         transparent = true,
         transparent_background_level = 1,
         background = "hard",
         disable_italic_comments = false,
         italics = true,
      },
   },

   -- lackluster.
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
               cmp = false,
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
               telescope = false,
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

         -- Setup nvim-web-devicons.
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
}
