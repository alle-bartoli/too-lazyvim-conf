-- ~/.config/nvim/lua/config/keymaps.lua

-- Keymaps are automatically loaded on the VeryLazy event.
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here.

local discipline = require("alle.discipline")
discipline.clown()

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Do things without affecting the registers
keymap.set("n", "x", '"_x', { desc = "Delete character without yanking" })
keymap.set("n", "<Leader>p", '"0p', { desc = "Paste from yank register (normal)" })
keymap.set("n", "<Leader>P", '"0P', { desc = "Paste from yank register before (normal)" })
keymap.set("v", "<Leader>p", '"0p', { desc = "Paste from yank register (visual)" })

keymap.set("n", "<Leader>c", '"_c', { desc = "Change without yanking (normal)" })
keymap.set("n", "<Leader>C", '"_C', { desc = "Change line without yanking (normal)" })
keymap.set("v", "<Leader>c", '"_c', { desc = "Change without yanking (visual)" })
keymap.set("v", "<Leader>C", '"_C', { desc = "Change line without yanking (visual)" })

keymap.set("n", "<Leader>d", '"_d', { desc = "Delete without yanking (normal)" })
keymap.set("n", "<Leader>D", '"_D', { desc = "Delete line without yanking (normal)" })
keymap.set("v", "<Leader>d", '"_d', { desc = "Delete without yanking (visual)" })
keymap.set("v", "<Leader>D", '"_D', { desc = "Delete line without yanking (visual)" })

-- Increment/decrement
keymap.set("n", "+", "<C-a>", { desc = "Increment number under cursor" })
keymap.set("n", "-", "<C-x>", { desc = "Decrement number under cursor" })

-- Delete a word backwards
keymap.set("n", "dw", "vb_d", { desc = "Delete previous word (visual-back)" })

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G", { desc = "Select all text" })

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", { desc = "New line below without indent continuation" })
keymap.set("n", "<Leader>O", "O<Esc>^Da", { desc = "New line above without indent continuation" })

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", { desc = "Forward jump in jump list" })

-- NewTab
keymap.set("n", "te", ":tabedit<CR>", { desc = "New tab" })
-- Note: <tab> and <s-tab> are handled by bufferline in lua/plugins/ui.lua

-- Split window
keymap.set("n", "sho", ":split<CR>", { desc = "Horizontal split" })
keymap.set("n", "sv", ":vsplit<CR>", { desc = "Vertical split" })

-- Move between windows
keymap.set("n", "sh", "<C-w>h", { desc = "Move to left window" })
keymap.set("n", "sj", "<C-w>j", { desc = "Move to bottom window" })
keymap.set("n", "sk", "<C-w>k", { desc = "Move to top window" })
keymap.set("n", "sl", "<C-w>l", { desc = "Move to right window" })

-- Resize window
keymap.set("n", "rh", "<Cmd>vertical resize -5<CR>", { desc = "Resize window left" })
keymap.set("n", "rl", "<Cmd>vertical resize +5<CR>", { desc = "Resize window right" })
keymap.set("n", "rk", "<Cmd>resize +5<CR>", { desc = "Resize window taller" })
keymap.set("n", "rj", "<Cmd>resize -5<CR>", { desc = "Resize window shorter" })
