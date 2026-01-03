-- ~/.config/nvim/lua/plugins/dap.lua

return {
   "mfussenegger/nvim-dap",
   dependencies = { "banjo/package-pilot.nvim" },
   config = function()
      local dap = require("dap")

      -- Symbols
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "Error", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "Success" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "◌", texthl = "WarningMsg" })

      ----------------------------------
      -- Node.js / TypeScript adapters
      ----------------------------------

      -- vscode-js-debug (modern)
      dap.adapters["pwa-node"] = {
         type = "server",
         host = "localhost",
         port = "${port}",
         executable = {
            command = "node",
            args = {
               vim.fn.expand("~/.local/share/nvim/vscode-js-debug/dist/src/vsDebugServer.js"),
               "${port}",
            },
         },
      }

      -- vscode-node-debug2 (older but stable)
      dap.adapters["node2"] = {
         type = "executable",
         command = "node",
         args = {
            vim.fn.expand("~/.local/share/nvim/vscode-node-debug2/out/src/nodeDebug.js"),
         },
      }

      ----------------------------------
      -- Python / debugpy
      ----------------------------------

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
            request = "launch",
            name = "Launch main.py as module",
            program = "-m",
            args = { "src.main" },
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

      ----------------------------------
      -- Go / Delve
      ----------------------------------

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
            name = "Debug (go.mod)",
            request = "launch",
            program = "./${relativeFileDirname}",
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
            program = "./${relativeFileDirname}",
         },
         {
            type = "delve",
            name = "Attach",
            request = "attach",
            mode = "local",
            processId = require("dap.utils").pick_process,
         },
      }

      ----------------------------------
      -- VS Code launch.json integration
      -- JS/TS configs loaded from .vscode/launch.json
      ----------------------------------

      local vscode = require("dap.ext.vscode")

      vscode.load_launchjs(nil, {
         python = { "python" },
         ["debugpy"] = { "python" },
         ["pwa-node"] = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
         ["node2"] = { "javascript", "typescript" },
         ["delve"] = { "go" },
      })

      vim.api.nvim_create_autocmd("BufWritePost", {
         pattern = "launch.json",
         callback = function()
            vscode.load_launchjs(nil, {
               python = { "python" },
               ["debugpy"] = { "python" },
               ["pwa-node"] = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
               ["node2"] = { "javascript", "typescript" },
               ["delve"] = { "go" },
            })
            vim.notify("Reloaded launch.json for nvim-dap", vim.log.levels.INFO)
         end,
      })
   end,
}
