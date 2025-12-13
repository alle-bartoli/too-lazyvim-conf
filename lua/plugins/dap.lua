-- ~/.config/nvim/lua/plugins/dap.lua

-- See https://www.banjocode.com/post/nvim/debug-node

local function pick_script()
   local pilot = require("package-pilot")

   local current_dir = vim.fn.getcwd()
   local package = pilot.find_package_file({ dir = current_dir })

   if not package then
      vim.notify("No package.json found", vim.log.levels.ERROR)
      return require("dap").ABORT
   end

   local scripts = pilot.get_all_scripts(package)

   local label_fn = function(script)
      return script
   end

   local co, ismain = coroutine.running()
   local ui = require("dap.ui")
   local pick = (co and not ismain) and ui.pick_one or ui.pick_one_sync
   local result = pick(scripts, "Select script", label_fn)
   return result or require("dap").ABORT
end

return {
   "mfussenegger/nvim-dap",
   dependencies = { "banjo/package-pilot.nvim" },
   config = function()
      local dap = require("dap")
      local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

      -- Symbols
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "Error", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "Success" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "◌", texthl = "WarningMsg" })

      -- Configure adapters
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

      local current_file = vim.fn.expand("%:t")
      for _, language in ipairs(js_filetypes) do
         dap.configurations[language] = {
            -- node2 + ts-node
            {
               type = "node2",
               request = "launch",
               name = "Debug current file (ts-node)",
               runtimeExecutable = "node",
               runtimeArgs = {
                  "-r",
                  "dotenv/config",
                  "-r",
                  "ts-node/register",
                  "-r",
                  "tsconfig-paths/register",
               },
               args = { "${file}" },
               cwd = "${workspaceFolder}",
               envFile = vim.fn.expand("${workspaceFolder}/.env"),
               env = { NODE_ENV = "development" },
               sourceMaps = true,
               protocol = "inspector",
               skipFiles = { "<node_internals>/**" },
               console = "integratedTerminal",
            },
            -- pwa-node launch
            {
               type = "pwa-node",
               request = "launch",
               name = "Launch file",
               program = "${file}",
               cwd = "${workspaceFolder}",
            },
            -- pwa-node attach
            {
               type = "pwa-node",
               request = "attach",
               name = "Attach",
               processId = require("dap.utils").pick_process,
               cwd = "${workspaceFolder}",
            },
            -- TSX launcher
            {
               name = "tsx (" .. current_file .. ")",
               type = "node",
               request = "launch",
               program = "${file}",
               runtimeExecutable = "tsx",
               cwd = "${workspaceFolder}",
               console = "integratedTerminal",
               internalConsoleOptions = "neverOpen",
               skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
            },
            -- Script via pnpm
            {
               type = "node",
               request = "launch",
               name = "pick script (pnpm)",
               runtimeExecutable = "pnpm",
               runtimeArgs = { "run", pick_script },
               cwd = "${workspaceFolder}",
               skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
            },
         }

         -- Detect venv automatically per project
         local function find_project_venv()
            local cwd = vim.fn.getcwd()
            local possible = {
               cwd .. "/venv/bin/python", -- standard venv folder
               cwd .. "/.venv/bin/python", -- common alternative
               cwd .. "/env/bin/python",
            }

            for _, path in ipairs(possible) do
               if vim.fn.filereadable(path) == 1 then
                  return path
               end
            end

            -- fallback to pyenv if nothing found
            local pyenv_version = vim.fn.system("pyenv version-name"):gsub("%s+", "")
            if pyenv_version and #pyenv_version > 0 then
               return vim.fn.expand("~/.pyenv/versions/" .. pyenv_version .. "/bin/python")
            end

            return "python" -- system fallback
         end

         -- Determine python path dynamically in launch config
         local function get_python()
            local v = os.getenv("VIRTUAL_ENV")
            if v and v ~= "" then
               return v .. "/bin/python"
            end
            local pyenv_version = vim.fn.system("pyenv version-name"):gsub("%s+", "")
            if pyenv_version and #pyenv_version > 0 then
               return vim.fn.expand("~/.pyenv/versions/" .. pyenv_version .. "/bin/python")
            end
            return "python"
         end

         dap.adapters.debugpy = {
            type = "executable",
            command = "python", -- fixed string; actual path handled in pythonPath
            args = { "-m", "debugpy.adapter" },
         }

         dap.configurations.python = {
            {
               type = "debugpy",
               request = "launch",
               name = "Launch file",
               program = "${file}",
               cwd = vim.fn.getcwd(), -- project root
               pythonPath = find_project_venv, -- dynamic per project
            },
            {
               type = "debugpy",
               request = "launch",
               name = "Launch main.py as module",
               program = "-m",
               args = { "src.main" },
               cwd = vim.fn.getcwd(), -- project root
               pythonPath = find_project_venv, -- dynamic per project
            },
            {
               type = "debugpy",
               request = "attach",
               name = "Attach to process",
               processId = require("dap.utils").pick_process,
               justMyCode = true,
               pythonPath = find_project_venv, -- dynamic per project
            },
         }

         ----------------------------------
         -- VS Code launch.json integration
         ----------------------------------

         local vscode = require("dap.ext.vscode")

         -- Load .vscode/launch.json automatically (supports debugpy, node, etc.)
         vscode.load_launchjs(nil, {
            python = { "python" },
            ["debugpy"] = { "python" },
            ["pwa-node"] = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
            ["node2"] = { "javascript", "typescript" },
         })

         -- Auto reload launch.json on save
         vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = "launch.json",
            callback = function()
               vscode.load_launchjs(nil, {
                  python = { "python" },
                  ["debugpy"] = { "python" },
                  ["pwa-node"] = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
                  ["node2"] = { "javascript", "typescript" },
               })
               vim.notify("Reloaded launch.json for nvim-dap", vim.log.levels.INFO)
            end,
         })
      end
   end,
}
