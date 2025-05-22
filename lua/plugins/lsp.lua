-- ~/.config/nvim/lua/plugins/lsp.lua

return {
   -- tools
   {
      "williamboman/mason.nvim",
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
            "css-lsp",
         })
      end,
   },

   --  CONFORM
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
         format_on_save = {
            lsp_fallback = true,
            timeout_ms = 500,
         },
      },
   },

   -- LSP
   {
      "neovim/nvim-lspconfig",
      opts = function(_, opts)
         local util = require("lspconfig.util")
         local Keys = require("lazyvim.plugins.lsp.keymaps").get()

         util.root_pattern(".prettierrc", ".prettierrc.js", "prettier.config.js", "package.json", ".git")

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
               desc = "Goto T[y]pe Definition",
            },
         })

         -- Modifica o estendi le opzioni esistenti
         opts.inlay_hints = { enabled = false }

         opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, {
            cssls = {},
            tailwindcss = {
               root_dir = util.root_pattern(".git"),
            },
            eslint = {
               root_dir = util.root_pattern(".eslintrc.json", "package.json", ".git"),
            },
            tsserver = {
               root_dir = util.root_pattern(".git"),
               single_file_support = false,
               on_attach = function(client)
                  client.server_capabilities.documentFormattingProvider = false
               end,
               settings = {
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
               },
            },
            html = {},
            yamlls = {
               settings = {
                  yaml = {
                     keyOrdering = false,
                  },
               },
            },
            lua_ls = {
               single_file_support = true,
               settings = {
                  Lua = {
                     workspace = {
                        checkThirdParty = false,
                     },
                     completion = {
                        workspaceWord = true,
                        callSnippet = "Both",
                     },
                     hint = {
                        enable = true,
                        setType = false,
                        paramType = true,
                        paramName = "Disable",
                        semicolon = "Disable",
                        arrayIndex = "Disable",
                     },
                     doc = {
                        privateName = { "^_" },
                     },
                     type = {
                        castNumberToInteger = true,
                     },
                     diagnostics = {
                        disable = { "incomplete-signature-doc", "trailing-space" },
                        groupSeverity = {
                           strong = "Warning",
                           strict = "Warning",
                        },
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
                        defaultConfig = {
                           indent_style = "space",
                           indent_size = "2",
                           continuation_indent_size = "2",
                        },
                     },
                  },
               },
            },
         })

         return opts
      end,
   },
}
