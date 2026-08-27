-- ~/.config/nvim/lua/util/lazygit.lua

local M = {}

function M.config_dir()
   local config_home = vim.env.XDG_CONFIG_HOME
   if not config_home or config_home == "" then
      config_home = vim.fn.expand("~/.config")
   end

   return config_home .. "/lazygit"
end

function M.config_files()
   local directory = M.config_dir()
   local candidates = {
      directory .. "/config.yml",
      directory .. "/rose-pine.yml",
   }

   return vim.tbl_filter(function(path)
      return vim.fn.filereadable(path) == 1
   end, candidates)
end

return M
