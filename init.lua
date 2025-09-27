-- ~/.config/nvim/lua/init.lua

-- Enable loader optimizations (Neovim 0.9+)
if vim.loader then
   vim.loader.enable()
end

-- Optional: Define a global debug printer (_G.dd) using util.debug if available
local ok, debug_util = pcall(require, "util.debug")
if ok then
   _G.dd = function(...)
      debug_util.dump(...)
   end
   vim.print = _G.dd
else
   _G.dd = function(...)
      print(vim.inspect(...))
   end
   vim.print = _G.dd
end

-- Enable 24-bit colour
-- See: https://github.com/rcarriga/nvim-notify?tab=readme-ov-file#prerequisites
vim.opt.termguicolors = true

-- Bootstrap LazyVim and your plugin/config setup
require("config.lazy")
