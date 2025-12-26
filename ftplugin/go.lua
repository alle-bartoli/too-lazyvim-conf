-- ~/.config/nvim/ftplugin/go.lua
-- Go-specific buffer settings and keymaps

local opt = vim.opt_local

-- Go standard: tabs, not spaces
opt.expandtab = false
opt.tabstop = 4
opt.shiftwidth = 4

-- Keymaps (buffer-local)
local map = function(mode, lhs, rhs, desc)
   vim.keymap.set(mode, lhs, rhs, { buffer = true, desc = desc })
end

-- Run/Test
map("n", "<leader>gt", "<cmd>!go test -v ./...<cr>", "Go: Test all")
map("n", "<leader>gT", "<cmd>!go test -v -run %:t:r ./...<cr>", "Go: Test current file")
map("n", "<leader>gr", "<cmd>!go run %<cr>", "Go: Run current file")
map("n", "<leader>gb", "<cmd>!go build ./...<cr>", "Go: Build")

-- Tooling
map("n", "<leader>gm", "<cmd>!go mod tidy<cr>", "Go: Mod tidy")
map("n", "<leader>gi", "<cmd>!go mod init<cr>", "Go: Mod init")

-- Code generation (via gopls code actions)
map("n", "<leader>gf", function()
   vim.lsp.buf.code_action({
      context = { only = { "source.organizeImports" } },
      apply = true,
   })
end, "Go: Organize imports")

map("n", "<leader>gs", function()
   vim.lsp.buf.code_action({
      context = { only = { "refactor.extract" } },
   })
end, "Go: Extract to function/variable")
