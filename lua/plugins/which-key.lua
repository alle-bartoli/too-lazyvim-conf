-- ~/.config/nvim/lua/plugins/which-key.lua
-- Register custom keymap groups so they appear in which-key menus.

return {
   {
      "folke/which-key.nvim",
      opts = {
         spec = {
            { "s", group = "split/window", mode = "n" },
            { "r", group = "resize", mode = "n" },
            { "<leader>t", group = "Test" },
            { "<leader>v", group = "Venv" },
            { "<leader>n", group = "Vault" },
         },
      },
   },
}
