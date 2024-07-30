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
}
