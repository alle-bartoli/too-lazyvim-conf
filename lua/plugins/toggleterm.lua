-- See: https://github.com/akinsho/toggleterm.nvim
return {
   {
      "akinsho/toggleterm.nvim",
      version = "*",
      config = true,
      keys = {
         { "<C-_>", "<cmd>ToggleTerm<cr>", { desc = "Terminal (Root Dir)" } },
      },
      opts = {
         size = 12,
      },
   },
}
