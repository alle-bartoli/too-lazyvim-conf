-- ~/.config/nvim/after/syntax/bru.lua

-- Bruno (.bru) Syntax Highlighting — Flow-inspired

-- Clear any existing syntax
vim.cmd("syntax clear")

-- IMPORTANT: Order matters! More specific patterns first

-- Variables with double braces - MUST come early to take priority
vim.cmd([=[syntax match bruEnvVariable /{{env\.[^}]\+}}/]=])
vim.cmd([=[syntax match bruVariable /{{[^}]\+}}/]=])

-- Path parameters (like :userId in URLs)
vim.cmd([=[syntax match bruPathParam /:\w\+/ contained]=])

-- Block headers (meta, put, post, etc.) - just the word
vim.cmd([=[syntax match bruBlockName /^\(meta\|get\|post\|put\|patch\|delete\|head\|options\)\>/]=])

-- Section headers - use a single match and highlight with conceal/matchadd
-- Just match the whole section header for now with one color each
vim.cmd(
   [=[syntax match bruSectionHeader /^params:path\|^params:query\|^body:json\|^body:text\|^body:xml\|^body:form-urlencoded\|^auth:basic\|^auth:bearer\|^auth:inherit\|^headers\|^vars\|^assert\|^script\|^tests\|^docs/]=]
)

-- Keys (property names before colons) - but NOT at start of line (to avoid section headers)
vim.cmd([=[syntax match bruKey /^\s\+\w\+\ze\s*:/]=])

-- JSON strings (in quotes)
vim.cmd([=[syntax region bruJSONString start=/"/ skip=/\\"/ end=/"/ ]=])

-- UUIDs
vim.cmd([=[syntax match bruUUID /\<[0-9a-f]\{8\}-[0-9a-f]\{4\}-[0-9a-f]\{4\}-[0-9a-f]\{4\}-[0-9a-f]\{12\}\>/]=])

-- Numbers
vim.cmd([=[syntax match bruNumber /\<\d\+\>/]=])

-- Booleans
vim.cmd([=[syntax keyword bruBoolean true false null]=])

-- HTTP methods as values
vim.cmd([=[syntax match bruHTTPMethod /:\s*\zs\(http\|https\|get\|post\|put\|patch\|delete\)\ze\s*$/]=])

-- Special keywords (inherit, json, etc.) as values
vim.cmd([=[syntax match bruKeyword /:\s*\zs\(inherit\|json\|text\|xml\|form-urlencoded\|basic\|bearer\)\ze\s*$/]=])

-- URL line with special handling
vim.cmd([=[syntax match bruURLLine /^\s*url:.*$/ contains=bruURLKey,bruVariable,bruEnvVariable,bruPathParam]=])
vim.cmd([=[syntax match bruURLKey /^\s*url/ contained]=])

-- Comments
vim.cmd([=[syntax match bruComment /#.*/]=])

-- Delimiters
vim.cmd([=[syntax match bruBrace /[{}]/]=])
vim.cmd([=[syntax match bruBracket /[\[\]]/]=])
vim.cmd([=[syntax match bruComma /,/]=])

-- Flow-inspired color palette
local colors = {
   -- Block and section names
   bruBlockName = { fg = "#ff5370", bold = true }, -- HTTP methods (meta, put, post)
   bruSectionHeader = { fg = "#c792ea", bold = true }, -- section headers

   -- Keys and properties
   bruKey = { fg = "#7fdbff" }, -- keys
   bruURLKey = { fg = "#7fdbff" }, -- "url"

   -- Values
   bruHTTPMethod = { fg = "#f78c6c", bold = true }, -- method values
   bruKeyword = { fg = "#c792ea" }, -- keywords
   bruJSONString = { fg = "#5affbd" }, -- JSON strings
   bruUUID = { fg = "#80cbc4" }, -- teal for UUIDs
   bruNumber = { fg = "#ffcb6b" }, -- numbers
   bruBoolean = { fg = "#ff5370" }, -- booleans/null

   -- Variables and URLs
   bruVariable = { fg = "#f78c6c", bold = true }, -- {{VARIABLES}}
   bruEnvVariable = { fg = "#ff9d00", bold = true }, -- {{env.VARIABLES}}
   bruPathParam = { fg = "#00e5ff", bold = true, underline = true }, -- path param

   -- Comments
   bruComment = { fg = "#546e7a", italic = true }, -- muted gray

   -- Delimiters
   bruBrace = { fg = "#c792ea" }, -- purple for {}
   bruBracket = { fg = "#c792ea" }, -- cyan for []
   bruComma = { fg = "#c792ea" },
   bruColon = { fg = "#c792ea" },
   bruSemicolon = { fg = "#c792ea" }, -- muted "#4a5f7a"
}

-- Apply highlight groups
for group, opts in pairs(colors) do
   vim.api.nvim_set_hl(0, group, opts)
end
