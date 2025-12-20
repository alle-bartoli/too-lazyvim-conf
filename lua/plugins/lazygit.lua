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

   -- Diffview
   {
      "sindrets/diffview.nvim",
      cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
      dependencies = { "nvim-lua/plenary.nvim" },
      keys = {
         { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Open Diffview" },
         { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File History" },
         { "<leader>gH", "<cmd>DiffviewFileHistory<CR>", desc = "Repo History" },
         { "<leader>gc", "<cmd>DiffviewClose<CR>", desc = "Close Diffview" },
      },
      opts = {
         enhanced_diff_hl = true,
         view = {
            default = { layout = "diff2_horizontal" },
            file_history = { layout = "diff2_horizontal" },
         },
      },
   },
}
