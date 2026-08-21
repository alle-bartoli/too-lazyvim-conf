-- ~/.config/nvim/indent/mql.lua
-- MQL4 / MQL5 C-style indentation.

if vim.b.did_indent then
   return
end
vim.b.did_indent = true

vim.bo.indentexpr = "v:lua.require('mql_indent').get_indent()"
vim.bo.indentkeys = "o,O,0},0],!^F,0#"

local M = {}

function M.get_indent()
   local lnum  = vim.v.lnum
   local line  = vim.fn.getline(lnum)
   local prev  = vim.fn.prevnonblank(lnum - 1)
   local prev_line = vim.fn.getline(prev)
   local sw    = vim.fn.shiftwidth()
   local prev_indent = vim.fn.indent(prev)

   -- Opening brace/bracket: indent next line.
   if prev_line:match("[{%[]%s*$") then
      return prev_indent + sw
   end

   -- Closing brace/bracket at line start: de-indent.
   if line:match("^%s*[}%]]") then
      local first_non = vim.fn.indent(lnum)
      local dedent = first_non - sw
      return dedent > 0 and dedent or 0
   end

   return prev_indent
end

package.loaded["mql_indent"] = M

return M