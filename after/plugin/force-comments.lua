-- ~/.config/nvim/after/plugin/force-comments.lua
--
-- Ensure termguicolors
vim.opt.termguicolors = true

-- Comment colors
local comment_fg = "#808080" --  #7AD7FF / #5DE4C7 / #FFD86B

-- Function to force highlights
local function force_comment_highlights()
   -- Vim/Neovim
   vim.api.nvim_set_hl(0, "Comment", { fg = comment_fg, italic = true, bold = false })
   vim.api.nvim_set_hl(0, "@comment", { link = "Comment" })

   -- Treesitter / markdown / git
   pcall(vim.api.nvim_set_hl, 0, "markdownComment", { link = "Comment" })
   pcall(vim.api.nvim_set_hl, 0, "gitcommitComment", { link = "Comment" })

   -- TODO/FIXME more visible
   vim.api.nvim_set_hl(0, "Todo", { fg = "#FFD86B", bold = true })
   vim.api.nvim_set_hl(0, "Fixme", { fg = "#FF6C6B", bold = true })
end

-- Apply first
force_comment_highlights()

-- Autocmd to reapply whenever something redefines the highlights
vim.api.nvim_create_augroup("ForceComments", { clear = true })
vim.api.nvim_create_autocmd({
   "ColorScheme", -- when the color scheme changes
   "BufWinEnter", -- when opening a buffer
   "WinEnter", -- when entering a window
   "VimEnter", -- at startup
   "LspAttach", -- when LSP attaches
}, {
   group = "ForceComments",
   pattern = "*",
   callback = force_comment_highlights,
})
