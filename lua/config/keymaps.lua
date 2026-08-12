-- ~/.config/nvim/lua/config/keymaps.lua

-- Keymaps are automatically loaded on the VeryLazy event.
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here.

local discipline = require("alle.discipline")
discipline.clown()

local keymap = vim.keymap
-- local opts = { noremap = true, silent = true }

-- Do things without affecting the registers
keymap.set("n", "x", '"_x', { desc = "Delete character without yanking" })

keymap.set("n", "<Leader>c", '"_c', { desc = "Change without yanking (normal)" })
keymap.set("n", "<Leader>C", '"_C', { desc = "Change line without yanking (normal)" })
keymap.set("v", "<Leader>c", '"_c', { desc = "Change without yanking (visual)" })
keymap.set("v", "<Leader>C", '"_C', { desc = "Change line without yanking (visual)" })

keymap.set("n", "<Leader>x", '"_d', { desc = "Delete without yanking (normal)" })
keymap.set("n", "<Leader>X", '"_D', { desc = "Delete line without yanking (normal)" })
keymap.set("v", "<Leader>x", '"_x', { desc = "Delete without yanking (visual)" })
keymap.set("v", "<Leader>X", '"_D', { desc = "Delete line without yanking (visual)" })

-- DAP (Debug Adapter Protocol)
keymap.set("n", "<Leader>db", function()
   require("dap").toggle_breakpoint()
end, { desc = "Toggle breakpoint" })
keymap.set("n", "<Leader>dc", function()
   require("dap").continue()
end, { desc = "Continue/Start debugger" })
keymap.set("n", "<Leader>do", function()
   require("dap").step_over()
end, { desc = "Step over" })
keymap.set("n", "<Leader>di", function()
   require("dap").step_into()
end, { desc = "Step into" })
keymap.set("n", "<Leader>dO", function()
   require("dap").step_out()
end, { desc = "Step out" })
keymap.set("n", "<Leader>dr", function()
   require("dap").repl.open()
end, { desc = "Open REPL" })
keymap.set("n", "<Leader>dl", function()
   require("dap").run_last()
end, { desc = "Run last" })
keymap.set("n", "<Leader>dt", function()
   require("dap").terminate()
end, { desc = "Terminate" })

-- Increment/decrement (routed through dial.nvim for booleans, dates, etc.)
local function dial(increment)
   return function()
      local group = vim.g.dials_by_ft and vim.g.dials_by_ft[vim.bo.filetype] or "default"
      local func = increment and "inc_normal" or "dec_normal"
      return require("dial.map")[func](group)
   end
end
keymap.set("n", "+", dial(true), { expr = true, desc = "Increment (dial)" })
keymap.set("n", "-", dial(false), { expr = true, desc = "Decrement (dial)" })

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

-- Pick colorscheme at runtime via vim.ui.select.
-- Union of loaded schemes (runtimepath) + lazy-loaded plugin schemes
-- detected by lazy.nvim. Selecting a lazy scheme triggers plugin load.
keymap.set("n", "<leader>uC", function()
   --- @type table<string, boolean>
   local set = {}
   for _, s in ipairs(vim.fn.getcompletion("", "color")) do
      set[s] = true
   end

   local ok, lazy = pcall(require, "lazy")
   if ok then
      for _, p in ipairs(lazy.plugins()) do
         local meta = p --[[@as table]]
         local list = (meta._ and meta._.colorschemes) or {} ---@type string[]
         for _, cs in ipairs(list) do
            set[cs] = true
         end
      end
   end

   local schemes = vim.tbl_keys(set)
   table.sort(schemes)

   vim.ui.select(schemes, { prompt = "Colorscheme:" }, function(choice)
      if choice then
         vim.cmd.colorscheme(choice)
      end
   end)
end, { desc = "Pick colorscheme" })

------------------------------------------------------------------------------
-- Vault (markdown PKM) navigation
------------------------------------------------------------------------------

local vault = vim.fn.expand("~/vault")

-- LazyVim core (lazyvim/plugins/ui.lua) maps <leader>n to "Notification
-- History". A complete mapping shadows every <leader>n* vault keymap.
--
-- This cannot be fixed with `keys = { { "<leader>n", false } }` in a plugin
-- spec: LazyVim's ui.lua fragment is registered *after* user fragments, so
-- it re-adds the mapping. Rebind it here instead, at VeryLazy, once
-- lazy.nvim has registered its keys.
--
-- Reuse LazyVim's own callback rather than reimplementing it, and warn
-- loudly if upstream moves the mapping so this does not fail silently.
local notif_history = vim.fn.maparg("<leader>n", "n", false, true)
if notif_history and notif_history.callback then
   keymap.set("n", "<leader>uN", notif_history.callback, {
      desc = notif_history.desc or "Notification History",
   })
   vim.keymap.del("n", "<leader>n")
else
   vim.notify(
      "vault: <leader>n is no longer LazyVim's Notification History; "
         .. "review the vault prefix remap in config/keymaps.lua",
      vim.log.levels.WARN
   )
end

keymap.set("n", "<leader>nf", function()
   Snacks.picker.files({ cwd = vault })
end, { desc = "Vault: find note" })

keymap.set("n", "<leader>ng", function()
   Snacks.picker.grep({ cwd = vault })
end, { desc = "Vault: text search" })

keymap.set("n", "<leader>nt", function()
   Snacks.picker.grep({ cwd = vault, search = "#\\w+" })
end, { desc = "Vault: find tag" })

keymap.set("n", "<leader>nd", function()
   local clients = vim.lsp.get_clients({ name = "markdown_oxide", bufnr = 0 })
   if #clients == 0 then
      vim.notify("markdown_oxide not attached — open a note in ~/vault/", vim.log.levels.WARN)
      return
   end
   vim.cmd("Daily today")
end, { desc = "Vault: today's daily note" })

keymap.set("n", "<leader>np", function()
   vim.cmd("MarkdownPreviewToggle")
end, { desc = "Markdown: toggle preview (browser)" })

keymap.set("n", "<leader>nn", function()
   local name = vim.fn.input("New note: ")
   if name == "" then
      return
   end
   local path = vault .. "/notes/" .. name:gsub("%s+", "-"):lower() .. ".md"
   vim.cmd("edit " .. path)
   vim.api.nvim_buf_set_lines(0, 0, 0, false, {
      "---",
      "title: " .. name,
      "date: " .. os.date("%Y-%m-%d"),
      "tags: []",
      "---",
      "",
      "# " .. name,
      "",
   })
   vim.cmd("normal! G")
end, { desc = "Vault: new note" })
