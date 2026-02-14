-- ~/.config/nvim/lua/plugins/dap.lua
-- Extends LazyVim's DAP extras with JS/TS adapters

return {
   -- Extend nvim-dap with JS/TS support
   {
      "mfussenegger/nvim-dap",
      opts = function()
         local dap = require("dap")

         ----------------------------------
         -- Node.js / TypeScript adapter
         ----------------------------------

         dap.adapters["pwa-node"] = {
            type = "server",
            host = "127.0.0.1",
            port = "${port}",
            executable = {
               command = "node",
               args = {
                  vim.fn.expand("~/.local/share/nvim/vscode-js-debug/dist/src/vsDebugServer.js"),
                  "${port}",
               },
            },
         }

         -- Alias for compatibility
         dap.adapters["node"] = dap.adapters["pwa-node"]

         ----------------------------------
         -- TypeScript/JavaScript configs
         ----------------------------------

         local js_based_languages = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

         for _, language in ipairs(js_based_languages) do
            dap.configurations[language] = {
               {
                  type = "pwa-node",
                  request = "launch",
                  name = "Debug Current File (tsx)",
                  runtimeExecutable = "npx",
                  runtimeArgs = { "tsx", "${file}" },
                  cwd = vim.fn.getcwd(),
                  sourceMaps = true,
                  resolveSourceMapLocations = {
                     "${workspaceFolder}/**",
                     "!**/node_modules/**",
                  },
                  skipFiles = { "<node_internals>/**", "**/node_modules/**" },
               },
               {
                  type = "pwa-node",
                  request = "launch",
                  name = "Debug Jest - Current File",
                  runtimeExecutable = "node",
                  runtimeArgs = {
                     "${workspaceFolder}/node_modules/jest/bin/jest.js",
                     "--runInBand",
                     "--no-cache",
                     "--testTimeout=300000",
                     "${file}",
                  },
                  cwd = vim.fn.getcwd(),
                  sourceMaps = true,
                  resolveSourceMapLocations = {
                     "${workspaceFolder}/**",
                     "!**/node_modules/**",
                  },
                  skipFiles = { "<node_internals>/**", "**/node_modules/**" },
               },
               {
                  type = "pwa-node",
                  request = "launch",
                  name = "Debug Jest - All Tests",
                  runtimeExecutable = "node",
                  runtimeArgs = {
                     "${workspaceFolder}/node_modules/jest/bin/jest.js",
                     "--runInBand",
                     "--no-cache",
                     "--testTimeout=300000",
                  },
                  cwd = vim.fn.getcwd(),
                  sourceMaps = true,
                  resolveSourceMapLocations = {
                     "${workspaceFolder}/**",
                     "!**/node_modules/**",
                  },
                  skipFiles = { "<node_internals>/**", "**/node_modules/**" },
               },
               {
                  type = "pwa-node",
                  request = "attach",
                  name = "Attach to Process",
                  processId = require("dap.utils").pick_process,
                  cwd = vim.fn.getcwd(),
                  sourceMaps = true,
                  skipFiles = { "<node_internals>/**", "**/node_modules/**" },
               },
            }
         end
      end,
   },

   ----------------------------------
   -- Python / debugpy (keep existing)
   ----------------------------------
   {
      "mfussenegger/nvim-dap",
      opts = function()
         local dap = require("dap")

         local function find_project_venv()
            local cwd = vim.fn.getcwd()
            local possible = {
               cwd .. "/venv/bin/python",
               cwd .. "/.venv/bin/python",
               cwd .. "/env/bin/python",
            }
            for _, path in ipairs(possible) do
               if vim.fn.filereadable(path) == 1 then
                  return path
               end
            end
            local pyenv_version = vim.fn.system("pyenv version-name"):gsub("%s+", "")
            if pyenv_version and #pyenv_version > 0 then
               return vim.fn.expand("~/.pyenv/versions/" .. pyenv_version .. "/bin/python")
            end
            return "python"
         end

         dap.adapters.debugpy = {
            type = "executable",
            command = "python",
            args = { "-m", "debugpy.adapter" },
         }

         dap.configurations.python = {
            {
               type = "debugpy",
               request = "launch",
               name = "Launch file",
               program = "${file}",
               cwd = vim.fn.getcwd(),
               pythonPath = find_project_venv,
            },
            {
               type = "debugpy",
               request = "attach",
               name = "Attach to process",
               processId = require("dap.utils").pick_process,
               justMyCode = true,
               pythonPath = find_project_venv,
            },
         }
      end,
   },

   ----------------------------------
   -- Go / Delve (keep existing)
   ----------------------------------
   {
      "mfussenegger/nvim-dap",
      opts = function()
         local dap = require("dap")

         dap.adapters.delve = {
            type = "server",
            port = "${port}",
            executable = {
               command = "dlv",
               args = { "dap", "-l", "127.0.0.1:${port}" },
            },
         }

         dap.configurations.go = {
            {
               type = "delve",
               name = "Debug",
               request = "launch",
               program = "${file}",
            },
            {
               type = "delve",
               name = "Debug test",
               request = "launch",
               mode = "test",
               program = "${file}",
            },
            {
               type = "delve",
               name = "Attach",
               request = "attach",
               mode = "local",
               processId = require("dap.utils").pick_process,
            },
         }
      end,
   },

   -- Custom signs
   {
      "mfussenegger/nvim-dap",
      config = function()
         vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
         vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual" })
         vim.fn.sign_define("DapBreakpointRejected", { text = "◌", texthl = "DiagnosticWarn" })
      end,
   },
}
