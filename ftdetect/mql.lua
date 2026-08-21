-- ~/.config/nvim/ftdetect/mql.lua
-- MQL4 / MQL5 filetype detection (replaces mql-filetype.nvim).
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
   pattern = { "*.mq5", "*.mqh", "*.mq4" },
   callback = function()
      vim.bo.filetype = "mql"
   end,
})