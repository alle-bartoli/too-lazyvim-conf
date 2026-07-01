-- ~/.config/nvim/lua/plugins/dap.lua
-- Extends LazyVim's DAP extras with JS/TS (bun) and Go (delve) adapters.
-- Python DAP handled by lang.python extra (nvim-dap-python).

return {
   {
      "mfussenegger/nvim-dap",
      opts = function()
         local dap = require("dap")

         ----------------------------------
         -- Signs + logging
         ----------------------------------

         vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
         vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual" })
         vim.fn.sign_define("DapBreakpointRejected", { text = "◌", texthl = "DiagnosticWarn" })
         dap.set_log_level("TRACE")

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

         -- Per-project .vscode/launch.json (type "bun" entries) loads automatically via dap providers.
         -- Register "bun" -> JS/TS filetypes so picker maps project presets.
         pcall(function()
            local vscode = require("dap.ext.vscode") --[[@as table]]
            vscode.type_to_filetypes["bun"] = js_based_languages
         end)

         ----------------------------------
         -- Go / Delve
         ----------------------------------

         dap.adapters.delve = {
            type = "server",
            port = "${port}",
            executable = {
               command = vim.fn.expand("~/.local/go/bin/dlv"),
               args = { "dap", "-l", "127.0.0.1:${port}" },
            },
         }

         -- Keep the debugger alive when detaching from a remote/headless Delve session.
         -- Without this, nvim-dap sends terminateDebuggee=true on disconnect, killing
         -- the process even though Delve was started with --accept-multiclient.
         dap.listeners.before["disconnect"]["keep_debuggee"] = function(session, body)
            if session and session.config and session.config.request == "attach" and body then
               ---@diagnostic disable-next-line: inject-field
               body.terminateDebuggee = false
            end
         end

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
}
