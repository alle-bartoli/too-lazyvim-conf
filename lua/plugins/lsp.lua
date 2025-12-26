-- ~/.config/nvim/lua/plugins/lsp.lua

return {
   -- MASON
   {
      "mason-org/mason.nvim",
      opts = function(_, opts)
         vim.list_extend(opts.ensure_installed, {
            "eslint-lsp",
            "js-debug-adapter",
            "stylua",
            "selene",
            "luacheck",
            "shellcheck",
            "shfmt",
            "tailwindcss-language-server",
            "typescript-language-server",
            "vtsls",
            "css-lsp",
            "rust-analyzer",
            "gopls",
            "goimports",
            "golangci-lint",
            "delve",
            "nomicfoundation-solidity-language-server",
         })
      end,
   },

   -- CONFORM
   {
      "stevearc/conform.nvim",
      opts = {
         formatters_by_ft = {
            javascript = { "prettier" },
            typescript = { "prettier" },
            javascriptreact = { "prettier" },
            typescriptreact = { "prettier" },
            json = { "prettier" },
            html = { "prettier" },
            css = { "prettier" },
            markdown = { "prettier" },
            solidity = { "prettier" },
            go = { "goimports", "gofmt" },
         },
      },
   },

   -- LSP
   {
      "neovim/nvim-lspconfig",
      opts = function(_, opts)
         local util = require("lspconfig.util")

         -- Config inlay hints comune TS/JS
         local function ts_inlay_hints()
            return {
               typescript = {
                  inlayHints = {
                     includeInlayParameterNameHints = "literal",
                     includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                     includeInlayFunctionParameterTypeHints = true,
                     includeInlayVariableTypeHints = false,
                     includeInlayPropertyDeclarationTypeHints = true,
                     includeInlayFunctionLikeReturnTypeHints = true,
                     includeInlayEnumMemberValueHints = true,
                  },
               },
               javascript = {
                  inlayHints = {
                     includeInlayParameterNameHints = "all",
                     includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                     includeInlayFunctionParameterTypeHints = true,
                     includeInlayVariableTypeHints = true,
                     includeInlayPropertyDeclarationTypeHints = true,
                     includeInlayFunctionLikeReturnTypeHints = true,
                     includeInlayEnumMemberValueHints = true,
                  },
               },
            }
         end

         -- Common `on_attach` TS/JS
         local function ts_on_attach(client, bufnr)
            -- LazyVim already handles keymaps & autocmd,
            -- so it allows to customize client behaviour only
            client.server_capabilities.documentFormattingProvider = false
         end

         ---@diagnostic disable-next-line: undefined-field
         opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, {
            -- Global keymaps
            ["*"] = {
               keys = {
                  {
                     "gd",
                     "<cmd>FzfLua lsp_definitions jump1=true ignore_current_line=true silent=true<cr>",
                     desc = "Goto Definition",
                     has = "definition",
                  },
                  {
                     "gr",
                     "<cmd>FzfLua lsp_references jump1=true ignore_current_line=true silent=true<cr>",
                     desc = "References",
                     nowait = true,
                  },
                  {
                     "gI",
                     "<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true silent=true<cr>",
                     desc = "Goto Implementation",
                  },
                  {
                     "gy",
                     "<cmd>FzfLua lsp_typedefs jump1=true ignore_current_line=true silent=true<cr>",
                     desc = "Goto Type Definition",
                  },
                  {
                     "<leader>cM",
                     function()
                        require("lazyvim.util").lsp.action["source.addMissingImports.ts"]()
                     end,
                     desc = "Add missing imports",
                  },
                  {
                     "<leader>cD",
                     function()
                        require("lazyvim.util").lsp.action["source.fixAll.ts"]()
                     end,
                     desc = "Fix all diagnostics",
                  },
               },
            },

            -- TypeScript / JavaScript
            vtsls = {
               enabled = true,
               root_dir = util.root_pattern("tsconfig.json", "package.json", ".git"),
               single_file_support = false,
               settings = ts_inlay_hints(),
               on_attach = ts_on_attach,
            },

            -- HTML / CSS / Tailwind
            cssls = {},
            tailwindcss = {},
            html = {},

            -- Linting
            eslint = { root_dir = util.root_pattern(".eslintrc.json", "package.json", ".git") },

            -- YAML
            yamlls = { settings = { yaml = { keyOrdering = false } } },

            -- Lua
            lua_ls = {
               single_file_support = true,
               settings = {
                  Lua = {
                     workspace = { checkThirdParty = false },
                     completion = { workspaceWord = true, callSnippet = "Both" },
                     hint = {
                        enable = true,
                        setType = false,
                        paramType = true,
                        paramName = "Disable",
                        semicolon = "Disable",
                        arrayIndex = "Disable",
                     },
                     doc = { privateName = { "^_" } },
                     type = { castNumberToInteger = true },
                     diagnostics = {
                        disable = { "incomplete-signature-doc", "trailing-space" },
                        groupSeverity = { strong = "Warning", strict = "Warning" },
                        groupFileStatus = {
                           ambiguity = "Opened",
                           await = "Opened",
                           codestyle = "None",
                           duplicate = "Opened",
                           global = "Opened",
                           luadoc = "Opened",
                           redefined = "Opened",
                           strict = "Opened",
                           strong = "Opened",
                           ["type-check"] = "Opened",
                           unbalanced = "Opened",
                           unused = "Opened",
                        },
                        unusedLocalExclude = { "_*" },
                     },
                     format = {
                        enable = false,
                        defaultConfig = { indent_style = "space", indent_size = "2", continuation_indent_size = "2" },
                     },
                  },
               },
            },

            -- Rust
            rust_analyzer = {
               settings = {
                  ["rust-analyzer"] = {
                     cargo = {
                        -- Enable all features for better IDE support
                        allFeatures = true,
                        loadOutDirsFromCheck = true,
                        buildScripts = { enable = true },
                     },
                     checkOnSave = {
                        -- Enable clippy for code quality checks
                        enable = true,
                        command = "clippy",
                     },
                     procMacro = {
                        enable = true,
                        attributes = {
                           enable = true,
                        },
                     },
                     diagnostics = {
                        experimental = { enable = true },
                     },
                     inlayHints = {
                        bindingModeHints = { enable = true },
                        closureReturnTypeHints = { enable = "always" },
                        lifetimeElisionHints = { enable = "always" },
                        reborrowHints = { enable = true },
                        typeHints = { enable = true },
                     },
                  },
               },
            },

            -- Go (extends lazyvim.plugins.extras.lang.go)
            gopls = {
               -- Use root_markers (go.work first for multi-module workspaces)
               root_markers = { "go.work", "go.mod", ".git" },
               settings = {
                  gopls = {
                     analyses = { unusedparams = true, shadow = true },
                     hints = {
                        assignVariableTypes = true,
                        compositeLiteralFields = true,
                        compositeLiteralTypes = true,
                        constantValues = true,
                        functionTypeParameters = true,
                        parameterNames = true,
                        rangeVariableTypes = true,
                     },
                  },
               },
            },

            -- Solidity
            solidity = {
               cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
               filetypes = { "solidity" },
               root_dir = util.root_pattern("foundry.toml", "hardhat.config.js", "hardhat.config.ts", "truffle-config.js", ".git"),
               single_file_support = true,
            },
         })

         return opts
      end,
   },
}
