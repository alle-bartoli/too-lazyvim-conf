-- ~/.config/nvim/lua/util/debug.lua

local M = {}

function M.dump(...)
   local args = { ... }
   for i, v in ipairs(args) do
      print(vim.inspect(v))
   end
end

return M
