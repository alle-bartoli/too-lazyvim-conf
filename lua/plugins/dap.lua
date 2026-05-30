-- ~/.config/nvim/lua/plugins/dap.lua
-- Extends LazyVim's DAP extras with JS/TS adapters

return {
   -- Extend nvim-dap with JS/TS support
   {
      "mfussenegger/nvim-dap",
      opts = function()
         local dap = require("dap")

         ----------------------------------
         -- Bun adapter (stdio shim wrapping bun-debug-adapter-protocol)
         -- See ~/.config/nvim/docs/bun-debug.md for setup + patches.
         ----------------------------------

         dap.adapters["bun"] = {
            type = "executable",
            command = "bun",
            args = { vim.fn.expand("~/.local/share/bun-dap/bun-dap-stdio.mjs") },
         }

         ----------------------------------
         -- TypeScript/JavaScript configs
         ----------------------------------

         local js_based_languages = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

         local bun_configs = {
            {
               type = "bun",
               request = "launch",
               name = "Bun: Debug Current File",
               program = "${file}",
               cwd = "${workspaceFolder}",
               stopOnEntry = false,
               watchMode = false,
            },
            {
               type = "bun",
               request = "launch",
               name = "Bun: Debug Tests in Current File",
               program = "${file}",
               runtimeArgs = { "test" },
               cwd = "${workspaceFolder}",
               stopOnEntry = false,
            },
            {
               type = "bun",
               request = "attach",
               name = "Bun: Attach (ws://localhost:6499)",
               url = "ws://localhost:6499/",
               stopOnEntry = false,
            },
         }

         for _, language in ipairs(js_based_languages) do
            dap.configurations[language] = bun_configs
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
               command = vim.fn.expand("~/.local/go/bin/dlv"),
               args = { "dap", "-l", "127.0.0.1:${port}" },
            },
         }

         dap.configurations.go = {
            {
               type = "delve",
               name = "Debug Package",
               request = "launch",
               program = "${fileDirname}",
            },
            {
               type = "delve",
               name = "Debug (args)",
               request = "launch",
               program = "${fileDirname}",
               args = function()
                  local args_string = vim.fn.input("Args: ")
                  return vim.split(args_string, " +")
               end,
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
               name = "Debug test (go.mod)",
               request = "launch",
               mode = "test",
               program = "${workspaceFolder}",
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

   -- Custom signs and logging
   {
      "mfussenegger/nvim-dap",
      config = function()
         vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
         vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual" })
         vim.fn.sign_define("DapBreakpointRejected", { text = "◌", texthl = "DiagnosticWarn" })

         -- Enable debug logging
         require("dap").set_log_level("TRACE")
      end,
   },
}
