-- ~/.config/nvim/ftplugin/bru.lua
-- Bruno filetype settings

-- Buffer-local options
vim.bo.commentstring = "# %s"
vim.bo.comments = ":#"
vim.bo.expandtab = true
vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.softtabstop = 2

-- Enable folding
vim.wo.foldmethod = "indent"
vim.wo.foldlevel = 99

-- Set formatoptions
vim.bo.formatoptions = "tcqj"
