-- ~/.config/nvim/plugin/mql5-lsp.lua
--
-- Auto-loaded on startup: register the MQL5 language server, then attach the
-- client on the actual mql5 filetype event so it spawns only when a .mq5/.mqh
-- buffer opens (robust to startup ordering).
--
-- mql5 is not a built-in lazy/lspconfig server, so we register it once here
-- using nvim 0.11+ vim.lsp.config/vim.lsp.enable.
local ok, err = pcall(vim.lsp.config, "mql5", {
   cmd = { vim.fn.expand("~/.local/bin/mql5-lsp") },
   filetypes = { "mql5", "mqh" },
   root_markers = { "MQL5", "src", ".git" },
})
if not ok then
   print("[mql5-lsp] register failed: " .. tostring(err))
end

-- Attach on the real filetype event so order of plugin load doesn't matter.
vim.api.nvim_create_autocmd("FileType", {
   pattern = "mql5",
   callback = function(args)
      local attached = vim.lsp.get_clients() and vim.lsp.get_clients()[args.buf]
      if not attached then
         vim.lsp.enable("mql5")
      end
   end,
})
