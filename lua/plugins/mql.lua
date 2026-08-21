-- ~/.config/nvim/lua/plugins/mql.lua
-- MQL4/MQL5 support: filetype + syntax highlighting handled locally.
--   - ftdetect/mql.lua   -> sets ft=mql for .mq5/.mqh/.mq4
--   - syntax/mql.lua     -> dedicated MQL regex highlighting
--   - plugin/mql5-lsp.lua-> mql5-lsp registration (diagnostics/completion)
-- No third-party mql plugin is needed (mql-filetype.nvim only attached a weak
-- generic C++ treesitter parser).
return {}
