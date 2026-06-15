-- ~/.config/nvim/lua/plugins/lazygit.lua

return {
   -- Snacks.lazygit handles <leader>gg (LazyVim default).
   -- Configure the float window size via snacks opts.
   {
      "snacks.nvim",
      opts = {
         lazygit = {
            win = {
               width = 0.9,
               height = 0.9,
            },
         },
      },
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
