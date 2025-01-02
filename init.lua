-- Enable loader optimizations for better performance if supported.
if vim.loader then
   vim.loader.enable()
end

-- Define global debugging tools (_G.dd and vim.print)
-- for inspecting variables or objects.
_G.dd = function(...)
   require("util.debug").dump(...)
end
vim.print = _G.dd

-- Bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
