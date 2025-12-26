-- ~/.config/nvim/lua/alle/bru/config.lua
-- Bruno plugin configuration

local M = {}

-- Default highlight links (can be overridden by user)
M.defaults = {
   highlights = {
      -- Block and section names
      bruBlockName = "Keyword",
      bruSectionHeader = "Type",

      -- Keys and properties
      bruKey = "@property",
      bruURLKey = "@property",

      -- Values
      bruHTTPMethod = "Function",
      bruContentType = "Type",
      bruAuthType = "Type",
      bruJSONString = "String",
      bruJSONStringSingle = "String",
      bruUUID = "Special",
      bruNumber = "Number",
      bruBoolean = "Boolean",
      bruNull = "Constant",
      bruStatusCode = "Number",

      -- Variables
      bruVariable = "Special",
      bruEnvVariable = "@variable.builtin",
      bruProcessEnvVariable = "@variable.builtin",
      bruPathParam = "Label",
      bruQueryString = "String",

      -- Assertions
      bruAssertOp = "Operator",

      -- Comments and disabled
      bruComment = "Comment",
      bruDisabled = "Comment",

      -- Delimiters
      bruBrace = "@punctuation.bracket",
      bruBracket = "@punctuation.bracket",
      bruParen = "@punctuation.bracket",
      bruDelimiter = "@punctuation.delimiter",
   },
}

M.options = vim.deepcopy(M.defaults)

--- Setup the Bruno plugin with user options
---@param opts? table User configuration options
function M.setup(opts)
   M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})

   -- Apply highlight links
   for group, target in pairs(M.options.highlights) do
      if type(target) == "string" then
         vim.api.nvim_set_hl(0, group, { link = target })
      elseif type(target) == "table" then
         vim.api.nvim_set_hl(0, group, target)
      end
   end
end

return M
