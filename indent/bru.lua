-- ~/.config/nvim/indent/bru.lua
-- Bruno indentation rules

if vim.b.did_indent then
   return
end
vim.b.did_indent = true

vim.bo.indentexpr = "v:lua.require('bru_indent').get_indent()"
vim.bo.indentkeys = "o,O,0},0],!^F"

-- Create the indent module
local M = {}

function M.get_indent()
   local lnum = vim.v.lnum
   local line = vim.fn.getline(lnum)
   local prev_lnum = vim.fn.prevnonblank(lnum - 1)
   local prev_line = vim.fn.getline(prev_lnum)
   local shiftwidth = vim.fn.shiftwidth()

   -- Get previous line's indent
   local prev_indent = vim.fn.indent(prev_lnum)

   -- Opening brace/bracket increases indent
   if prev_line:match("[{%[]%s*$") then
      return prev_indent + shiftwidth
   end

   -- Closing brace/bracket at start of line decreases indent
   if line:match("^%s*[}%]]") then
      return prev_indent - shiftwidth
   end

   -- Section headers (body:json, headers, etc.) keep same indent
   if prev_line:match("^%w") or prev_line:match("^%w+:") then
      return 0
   end

   -- Keep previous indent by default
   return prev_indent
end

-- Register the module
package.loaded["bru_indent"] = M

return M
