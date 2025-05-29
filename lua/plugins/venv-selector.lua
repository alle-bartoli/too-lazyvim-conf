-- ~/.config/nvim/lua/plugins/venv-selector.lua

-- Basic `venv-selector` config.
-- https://github.com/linux-cultist/venv-selector.nvim?tab=readme-ov-file#-installation-and-configuration

return {
   "linux-cultist/venv-selector.nvim",
   dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap-python",
      "nvim-telescope/telescope.nvim",
   },
   opts = {
      name = "venv",
      auto_refresh = false,
   },
   event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
   keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>" }, -- Keymap to open VenvSelector to pick a venv
      { "<leader>vc", "<cmd>VenvSelectCached<cr>" }, --  Keymap to retrieve the venv from a cache (the one previously used for the same project directory)
   },
}
