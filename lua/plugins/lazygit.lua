-- ~/.config/nvim/lua/plugins/lazygit.lua

return {
   {
      "kdheepak/lazygit.nvim",
      cmd = {
         "LazyGit",
         "LazyGitConfig",
         "LazyGitCurrentFile",
         "LazyGitFilter",
         "LazyGitFilterCurrentFile",
      },
      dependencies = { "nvim-lua/plenary.nvim" },
      keys = { { "<leader>gg", "<cmd>LazyGit<CR>", desc = "Open LazyGit" } },
      config = function()
         vim.g.lazygit_floating_window_scaling_factor = 0.9
         vim.g.lazygit_use_neovim_remote = 0
      end,
   },
}
