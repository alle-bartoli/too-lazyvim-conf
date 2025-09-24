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
         },
      },
   },

   -- LSP
   {
      "neovim/nvim-lspconfig",
      opts = function(_, opts)
         local util = require("lspconfig.util")
         local Keys = require("lazyvim.plugins.lsp.keymaps").get()

         local function root_dir()
            return util.root_pattern("tsconfig.json", "package.json", ".git")
         end

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
         local function ts_on_attach(client)
            client.server_capabilities.documentFormattingProvider = false
         end

         -- Init root_pattern
         util.root_pattern(".prettierrc", ".prettierrc.js", "prettier.config.js", "tsconfig.json", "package.json", ".git")

         vim.list_extend(Keys, {
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
            { "<leader>cM", LazyVim.lsp.action["source.addMissingImports.ts"], desc = "Add missing imports" },
            { "<leader>cD", LazyVim.lsp.action["source.fixAll.ts"], desc = "Fix all diagnostics" },
         })

         opts.inlay_hints = { enabled = false }
         opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, {
            -- TypeScript / JavaScript

            -- TODO: investigate why doesn't works
            -- vtsls = {
            --    enabled = true,
            --    root_dir = root_dir(),
            --    single_file_support = false,
            --    settings = ts_inlay_hints(),
            --    on_attach = ts_on_attach,
            -- },

            ts_ls = {
               enabled = false,
               root_dir = root_dir(),
               single_file_support = false,
               settings = ts_inlay_hints(),
               on_attach = ts_on_attach,
            },

            tsserver = {
               enabled = false,
               root_dir = root_dir(),
               single_file_support = false,
               settings = ts_inlay_hints(),
               on_attach = ts_on_attach,
            },

            -- HTML / CSS / Tailwind
            cssls = {},
            tailwindcss = { root_dir = util.root_pattern(".git") },
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
                     cargo = { allFeatures = true },
                     checkOnSave = { command = "clippy" },
                     inlayHints = {
                        bindingModeHints = true,
                        closureReturnTypeHints = "all",
                        lifetimeElisionHints = "always",
                        reborrowHints = true,
                        typeHints = true,
                     },
                  },
               },
            },

            -- Go
            gopls = {
               cmd = { "gopls" },
               root_dir = util.root_pattern("go.mod", ".git"),
               settings = {
                  gopls = {
                     analyses = { unusedparams = true, shadow = true },
                     staticcheck = true,
                     codelenses = { generate = true, gc_details = true, tidy = true, test = true },
                  },
               },
            },
         })

         return opts
      end,
   },
}
