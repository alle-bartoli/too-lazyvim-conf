-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Enable mouse. (Default "")
vim.opt.mouse = "a"

-- Required for fzf
vim.g.lazyvim_picker = "fzf"

-- set to `true` to follow the main branch
-- you need to have a working rust toolchain to build the plugin in this case.
vim.g.lazyvim_blink_main = false

--  Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m]"]])
vim.cmd([[let &t_Ce = "\e[4:3m]"]])

-- LSP Server to use for Python
-- Set to "basedpyright" to use basedpyright instead of pyright
vim.g.lazyvim_python_lsp = "pyright"
-- Set to "ruff_lsp" to use the old LSP implementation version
vim.g.lazyvim_python_ruff = "ruff"
