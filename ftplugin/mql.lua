-- ~/.config/nvim/ftplugin/mql.lua
-- MQL4 / MQL5 buffer-local settings and keymaps.

local opt = vim.opt_local

-- Common EA style: 3-space / 4-space indent, no tabs (matches the project
-- code which uses 3-space indentation).
opt.expandtab   = true
opt.tabstop     = 4
opt.shiftwidth  = 3
opt.softtabstop = 3

-- Match MetaEditor convention: comments with // and /* */ are built into the
-- syntax file; keep it simple.
vim.bo.commentstring = "// %s"
vim.opt_local.comments = "s1:/*,mb:*,ex:*/,://"

-- Folding by braces (C-style) helps on long EA files.
vim.cmd("setlocal foldmethod=indent")
vim.cmd("setlocal foldlevelstart=1")

-- Buffer-local keymaps
local map = function(mode, lhs, rhs)
   vim.keymap.set(mode, lhs, rhs, { buffer = true, silent = true })
end

map("n", "<localleader>=", "gg=G", "MQL: Format (indent) buffer")

return {}