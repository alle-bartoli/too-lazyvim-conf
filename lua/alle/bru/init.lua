-- ~/.config/nvim/lua/alle/bru/init.lua
-- Bruno filetype plugin for Neovim

local M = {}

local config = require("alle.bru.config")

--- Setup the Bruno plugin
---@param opts? table User configuration
function M.setup(opts)
   config.setup(opts)
end

return M
