-- ~/.config/nvim/syntax/bru.lua
-- Bruno (.bru) Syntax Highlighting

if vim.b.current_syntax then
   return
end

vim.cmd("syntax clear")

-- ============================================================================
-- VARIABLES (highest priority - must come first)
-- ============================================================================
vim.cmd([=[syntax match bruEnvVariable /{{env\.[^}]\+}}/ containedin=ALL]=])
vim.cmd([=[syntax match bruProcessEnvVariable /{{process\.env\.[^}]\+}}/ containedin=ALL]=])
vim.cmd([=[syntax match bruVariable /{{[^}]\+}}/ containedin=ALL]=])

-- ============================================================================
-- DISABLED LINES (lines starting with ~)
-- ============================================================================
vim.cmd([=[syntax match bruDisabled /^\s*\~.*$/]=])

-- ============================================================================
-- COMMENTS
-- ============================================================================
vim.cmd([=[syntax match bruComment /#.*$/]=])

-- ============================================================================
-- BLOCK HEADERS (HTTP methods and meta)
-- ============================================================================
vim.cmd([=[syntax match bruBlockName /^\(meta\|get\|post\|put\|patch\|delete\|head\|options\|trace\|connect\)\>/]=])

-- ============================================================================
-- SECTION HEADERS (all Bruno section types)
-- ============================================================================
local section_headers = {
   -- Parameters
   "params:path",
   "params:query",
   "query",
   -- Body types
   "body:json",
   "body:text",
   "body:xml",
   "body:sparql",
   "body:form-urlencoded",
   "body:multipart-form",
   "body:graphql",
   "body:graphql:vars",
   "body:none",
   -- Authentication
   "auth:awsv4",
   "auth:basic",
   "auth:bearer",
   "auth:digest",
   "auth:inherit",
   "auth:oauth2",
   "auth:wsse",
   "auth:none",
   -- Scripts
   "script:pre-request",
   "script:post-response",
   "script",
   -- Variables
   "vars:pre-request",
   "vars:post-response",
   "vars",
   -- Other sections
   "headers",
   "assert",
   "tests",
   "docs",
}
vim.cmd(
   [=[syntax match bruSectionHeader /^]=]
      .. table.concat(section_headers, [=[\|^]=])
      .. [=[/]=]
)

-- ============================================================================
-- URL HANDLING
-- ============================================================================
vim.cmd([=[syntax match bruURLLine /^\s*url:.*$/ contains=bruURLKey,bruVariable,bruEnvVariable,bruProcessEnvVariable,bruPathParam,bruQueryString]=])
vim.cmd([=[syntax match bruURLKey /^\s*url/ contained]=])
vim.cmd([=[syntax match bruPathParam /:\w\+/ contained]=])
vim.cmd([=[syntax match bruQueryString /?.*$/ contained contains=bruVariable,bruEnvVariable,bruProcessEnvVariable]=])

-- ============================================================================
-- KEYS AND VALUES
-- ============================================================================
vim.cmd([=[syntax match bruKey /^\s\+[a-zA-Z_][a-zA-Z0-9_-]*\ze\s*:/]=])

-- JSON strings
vim.cmd([=[syntax region bruJSONString start=/"/ skip=/\\"/ end=/"/ contains=bruVariable,bruEnvVariable,bruProcessEnvVariable]=])
vim.cmd([=[syntax region bruJSONStringSingle start=/'/ skip=/\\'/ end=/'/ contains=bruVariable,bruEnvVariable,bruProcessEnvVariable]=])

-- ============================================================================
-- LITERALS
-- ============================================================================
vim.cmd([=[syntax match bruUUID /\<[0-9a-fA-F]\{8\}-[0-9a-fA-F]\{4\}-[0-9a-fA-F]\{4\}-[0-9a-fA-F]\{4\}-[0-9a-fA-F]\{12\}\>/]=])
vim.cmd([=[syntax match bruNumber /-\?\<\d\+\(\.\d\+\)\?\>/]=])
vim.cmd([=[syntax keyword bruBoolean true false]=])
vim.cmd([=[syntax keyword bruNull null undefined]=])

-- ============================================================================
-- SPECIAL VALUES
-- ============================================================================
vim.cmd([=[syntax match bruHTTPMethod /:\s*\zs\(http\|https\|GET\|POST\|PUT\|PATCH\|DELETE\|HEAD\|OPTIONS\)\ze\s*$/]=])
vim.cmd([=[syntax match bruContentType /:\s*\zs\(json\|text\|xml\|sparql\|form-urlencoded\|multipart-form\|graphql\|none\)\ze\s*$/]=])
vim.cmd([=[syntax match bruAuthType /:\s*\zs\(inherit\|basic\|bearer\|digest\|oauth2\|awsv4\|wsse\|none\)\ze\s*$/]=])

-- ============================================================================
-- ASSERTION OPERATORS
-- ============================================================================
vim.cmd([=[syntax keyword bruAssertOp eq neq gt gte lt lte]=])
vim.cmd([=[syntax keyword bruAssertOp notContains startsWith endsWith]=])
vim.cmd([=[syntax keyword bruAssertOp matches isNull isUndefined isDefined]=])
vim.cmd([=[syntax keyword bruAssertOp isJson isNumber isString isBoolean isArray]=])
vim.cmd([=[syntax match bruAssertOp /\<contains\>/]=])

-- ============================================================================
-- SCRIPT BLOCKS (foldable regions)
-- ============================================================================
vim.cmd([=[syntax region bruScriptBlock start=/^script\(:\(pre-request\|post-response\)\)\?\s*{$/ end=/^}$/ contains=bruVariable,bruEnvVariable,bruProcessEnvVariable,bruJSONString,bruJSONStringSingle,bruComment,bruNumber,bruBoolean,bruNull keepend fold]=])
vim.cmd([=[syntax region bruTestBlock start=/^tests\s*{$/ end=/^}$/ contains=bruVariable,bruEnvVariable,bruProcessEnvVariable,bruJSONString,bruJSONStringSingle,bruComment,bruNumber,bruBoolean,bruNull keepend fold]=])

-- ============================================================================
-- DELIMITERS
-- ============================================================================
vim.cmd([=[syntax match bruBrace /[{}]/]=])
vim.cmd([=[syntax match bruBracket /[\[\]]/]=])
vim.cmd([=[syntax match bruParen /[()]/]=])
vim.cmd([=[syntax match bruDelimiter /[,;:]/]=])

-- ============================================================================
-- RESPONSE STATUS CODES
-- ============================================================================
vim.cmd([=[syntax match bruStatusCode /\<[1-5]\d\d\>/]=])

-- ============================================================================
-- HIGHLIGHT GROUPS (apply from config or use defaults)
-- ============================================================================
local ok, config = pcall(require, "alle.bru.config")
local highlights = ok and config.options.highlights or {
   bruBlockName = "Keyword",
   bruSectionHeader = "Type",
   bruKey = "@property",
   bruURLKey = "@property",
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
   bruVariable = "Special",
   bruEnvVariable = "@variable.builtin",
   bruProcessEnvVariable = "@variable.builtin",
   bruPathParam = "Label",
   bruQueryString = "String",
   bruAssertOp = "Operator",
   bruComment = "Comment",
   bruDisabled = "Comment",
   bruBrace = "@punctuation.bracket",
   bruBracket = "@punctuation.bracket",
   bruParen = "@punctuation.bracket",
   bruDelimiter = "@punctuation.delimiter",
}

for group, target in pairs(highlights) do
   if type(target) == "string" then
      vim.api.nvim_set_hl(0, group, { link = target })
   elseif type(target) == "table" then
      vim.api.nvim_set_hl(0, group, target)
   end
end

vim.b.current_syntax = "bru"
