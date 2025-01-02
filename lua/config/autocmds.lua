-- Autocmds are automatically loaded on the VeryLazy event.
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here.

-- Turn off paste mode when leaving insert.
vim.api.nvim_create_autocmd("InsertLeave", {
   pattern = "*",
   command = "set nopaste",
})

-- Disable cancel. Default 3.
vim.api.nvim_create_autocmd("FileType", {
   pattern = { "json", "jsonc", "markdown" },
   callback = function()
      vim.wo.conceallevel = 0 -- fully visible.
   end,
})
