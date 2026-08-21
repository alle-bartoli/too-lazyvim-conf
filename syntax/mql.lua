-- ~/.config/nvim/syntax/mql.lua
-- MQL4 / MQL5 Syntax Highlighting (regex-based).

if vim.b.current_syntax then
   return
end

vim.cmd("syntax clear")

-- Comments
vim.cmd("syn match mqlComment '//.*$'")
vim.cmd("syn region mqlCommentBlock start='/\\*' end='\\*/'")

-- Strings
vim.cmd("syn region mqlString start='\"' skip='\\\\\"' end='\"'")

-- Numbers
vim.cmd("syn match mqlNumber '\\-\\?\\d\\+\\(\\.\\d\\+\\)\\?'")
vim.cmd("syn match mqlHexNumber '0[xX][0-9a-fA-F]\\+'")
vim.cmd("syn match mqlColor 'C\\d\\+,\\d\\+,\\d\\+'")

-- Preprocessor
vim.cmd("syn match mqlPreprocessor '^#\\s*\\(include\\|define\\|property\\|import\\|require\\)'")

-- Inputs
vim.cmd("syn keyword mqlInput input sinput")

-- Types
vim.cmd("syn keyword mqlType int long double float string bool datetime color void")

-- Control flow
vim.cmd("syn keyword mqlControl if else for while do switch case break continue return goto default")

-- Storage / OOP
vim.cmd("syn keyword mqlModifier const volatile static public private protected virtual internal")
vim.cmd("syn keyword mqlDeclaration enum struct class extends override redef process define")

-- Built-in functions
vim.cmd("syn keyword mqlFunction Alert Print Comment MessageBox Sleep SetTickError ScreenGetLeftMargin")
vim.cmd("syn keyword mqlFunction OrderOpen OrderClose OrderModify OrderDelete OrderInfo_Get")
vim.cmd("syn keyword mqlFunction PositionOpen PositionClose PositionModify")
vim.cmd("syn keyword mqlFunction MarketInfo SymbolTimeFrame")
vim.cmd("syn keyword mqlFunction Account AccountBalance AccountInfo_Get")
vim.cmd("syn keyword mqlFunction TimeCurrent TimeToString TimeToStruct TimeLocal TimeToLocal")
vim.cmd("syn keyword mqlFunction StringLen StringSubstr StringFind StringReplace StringToUpper StringToLower")
vim.cmd("syn keyword mqlFunction StringToInteger StringToDouble DoubleToStr DoubleToString IntegerToString Format")
vim.cmd("syn keyword mqlFunction MathAbs MathRound MathFloor MathCeil MathSqrt MathPow MathMax MathMin")
vim.cmd("syn keyword mqlFunction Symbol Period TimeFrame FileOpen FileWrite FileClose")
vim.cmd("syn keyword mqlFunction ObjectCreate ObjectSetInteger ObjectSetDouble ObjectSetString ObjectDelete")

-- Highlight groups
local function link(group, target)
   vim.api.nvim_set_hl(0, group, { link = target })
end

link("mqlComment", "Comment")
link("mqlCommentBlock", "Comment")
link("mqlString", "String")
link("mqlNumber", "Number")
link("mqlHexNumber", "Number")
link("mqlColor", "Special")
link("mqlPreprocessor", "PreProc")
link("mqlInput", "@keyword.import")
link("mqlType", "Type")
link("mqlControl", "Statement")
link("mqlClass", "Keyword")
link("mqlKeyword", "Keyword")
link("mqlFunction", "Function")

vim.b.current_syntax = "mql"