vim.filetype.add({
  extension = {
    mdx = "mdx",
  },
})

-- Fallback: Use markdown treesitter for MDX if mdx parser isn't available
vim.api.nvim_create_autocmd("FileType", {
  pattern = "mdx",
  callback = function()
    vim.treesitter.language.register("markdown", "mdx")
  end,
})
