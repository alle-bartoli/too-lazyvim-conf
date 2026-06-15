-- ~/.config/nvim/lua/plugins/test.lua
-- Neotest adapter configuration for JS/TS test runners.
-- Go adapter (neotest-golang) is provided by the lang.go extra.
-- Python adapter (neotest-python) will be provided by the lang.python extra.

return {
   {
      "nvim-neotest/neotest",
      dependencies = {
         "marilari88/neotest-vitest",
         "nvim-neotest/neotest-jest",
      },
      opts = {
         adapters = {
            ["neotest-vitest"] = {},
            ["neotest-jest"] = {
               jestCommand = "npx jest",
               cwd = function()
                  return vim.fn.getcwd()
               end,
            },
         },
      },
   },
}
