-- ~/.config/nvim/lua/plugins/venv-selector.lua
-- Extends lang.python extra's venv-selector with fzf-lua picker and custom keymaps.

return {
   "linux-cultist/venv-selector.nvim",
   opts = {
      name = "venv",
      auto_refresh = false,
      picker = "fzf-lua",
   },
   keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select Venv", ft = "python" },
      { "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "Select Cached Venv", ft = "python" },
   },
}
