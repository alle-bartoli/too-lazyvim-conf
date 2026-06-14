-- ~/.config/nvim/lua/config/autocmds.lua

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

----------------------------------------------------------------------
-- Force transparent background across every colorscheme.
----------------------------------------------------------------------

--- @dev Highlight groups whose background must stay transparent.
--- Covers core UI, popup menus, statuslines, tabs, file tree, notify.
local transparent_groups = {
   "Normal",
   "NormalNC",
   "NormalFloat",
   "FloatBorder",
   "SignColumn",
   "EndOfBuffer",
   "LineNr",
   "CursorLineNr",
   "StatusLine",
   "StatusLineNC",
   "WinBar",
   "WinBarNC",
   "TabLine",
   "TabLineFill",
   "TabLineSel",
   "Folded",
   "Pmenu",
   "PmenuSbar",
   "PmenuThumb",
   "TelescopeNormal",
   "TelescopeBorder",
   "NeoTreeNormal",
   "NeoTreeNormalNC",
   "NeoTreeEndOfBuffer",
   "NotifyBackground",
   "MsgArea",
}

--- @dev Clears `bg` on every group in `transparent_groups`.
--- pcall guards groups not defined by the current scheme.
local function force_transparent()
   for _, group in ipairs(transparent_groups) do
      pcall(vim.api.nvim_set_hl, 0, group, { bg = "NONE", ctermbg = "NONE" })
   end
end

vim.api.nvim_create_augroup("ForceTransparent", { clear = true })
vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
   group = "ForceTransparent",
   callback = force_transparent,
})

force_transparent()
