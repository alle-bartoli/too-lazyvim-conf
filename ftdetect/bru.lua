-- ~/.config/nvim/ftdetect/bru.lua

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
   pattern = "*.bru",
   callback = function()
      vim.bo.filetype = "bru"
   end,
})
