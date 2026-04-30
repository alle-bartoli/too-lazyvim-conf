-- ~/.config/nvim/lua/plugins/lsp.lua

return {
   -- MASON: Automatic installation of LSP servers, formatters, linters
   {
      "mason-org/mason.nvim",
      opts = function(_, opts)
         -- Extend (not replace) LazyVim's default ensure_installed list
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
            "astro-language-server",
         })
      end,
   },

   -- CONFORM: Formatter configuration (replaces null-ls formatting)
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
            mdx = { "prettier" },
            solidity = { "prettier" },
            astro = { "prettier" },
            -- goimports first to organize imports, then gofmt for style
            go = { "goimports", "gofmt" },
         },
      },
   },

   -- LSP
   {
      "neovim/nvim-lspconfig",
      opts = function(_, opts)
         -- Shared inlay hints config for TypeScript/JavaScript
         -- TS shows fewer hints (literal only) since types are explicit
         -- JS shows more hints (all) to compensate for dynamic typing
         local function ts_inlay_hints()
            return {
               typescript = {
                  inlayHints = {
                     includeInlayParameterNameHints = "literal", -- Only for literals, not variables
                     includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                     includeInlayFunctionParameterTypeHints = true,
                     includeInlayVariableTypeHints = false, -- Avoid noise in typed TS
                     includeInlayPropertyDeclarationTypeHints = true,
                     includeInlayFunctionLikeReturnTypeHints = true,
                     includeInlayEnumMemberValueHints = true,
                  },
               },
               javascript = {
                  inlayHints = {
                     includeInlayParameterNameHints = "all", -- More hints needed in untyped JS
                     includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                     includeInlayFunctionParameterTypeHints = true,
                     includeInlayVariableTypeHints = true, -- Helpful in untyped JS
                     includeInlayPropertyDeclarationTypeHints = true,
                     includeInlayFunctionLikeReturnTypeHints = true,
                     includeInlayEnumMemberValueHints = true,
                  },
               },
            }
         end

         -- Common on_attach for TS/JS servers
         local function ts_on_attach(client, bufnr)
            -- Disable LSP formatting to avoid conflicts with conform.nvim
            client.server_capabilities.documentFormattingProvider = false
         end

         ---@diagnostic disable-next-line: undefined-field
         -- Deep merge to preserve LazyVim's default server configs
         opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, {
            -- Global keymaps applied to ALL LSP servers
            -- Override LazyVim defaults to use FzfLua instead of Telescope
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
                     nowait = true, -- Don't wait for timeout (immediate execution)
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

            -- TypeScript / JavaScript (vtsls is faster than tsserver)
            vtsls = {
               enabled = true,
               -- Only start in projects with explicit TS/JS config (avoids random .js files)
               root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
               single_file_support = false,
               settings = ts_inlay_hints(),
               on_attach = ts_on_attach,
            },

            -- HTML / CSS / Tailwind
            cssls = {
               settings = {
                  -- Ignore @tailwind, @apply, and other PostCSS/Tailwind directives
                  css = { lint = { unknownAtRules = "ignore" } },
               },
            },
            tailwindcss = {},
            html = {},

            -- Linting: only start in projects that have an eslint config file
            eslint = {
               root_markers = {
                  ".eslintrc.cjs",
                  ".eslintrc.js",
                  ".eslintrc.json",
                  ".eslintrc.yaml",
                  ".eslintrc.yml",
                  "eslint.config.js",
                  "eslint.config.mjs",
                  "eslint.config.cjs",
                  "package.json",
                  ".git",
               },
               settings = {
                  workingDirectories = { mode = "auto" },
               },
            },

            -- YAML
            -- Disable key ordering to allow flexible formatting (e.g., version at top)
            yamlls = { settings = { yaml = { keyOrdering = false } } },

            -- Lua
            lua_ls = {
               single_file_support = true, -- Allow LSP for standalone Lua scripts
               settings = {
                  Lua = {
                     -- Don't prompt to configure workspace for neovim runtime
                     workspace = { checkThirdParty = false },
                     -- Enable completion from all workspace words and show both snippet types
                     completion = { workspaceWord = true, callSnippet = "Both" },
                     hint = {
                        enable = true,
                        setType = false, -- Don't hint explicit type assignments (noisy)
                        paramType = true,
                        paramName = "Disable", -- Function param names are usually clear
                        semicolon = "Disable",
                        arrayIndex = "Disable",
                     },
                     -- Treat underscore-prefixed as private
                     doc = { privateName = { "^_" } },
                     type = { castNumberToInteger = true },
                     diagnostics = {
                        -- Disable noisy or subjective diagnostics
                        disable = { "incomplete-signature-doc", "trailing-space" },
                        -- Downgrade strict checks to warnings instead of errors
                        groupSeverity = { strong = "Warning", strict = "Warning" },
                        groupFileStatus = {
                           ambiguity = "Opened",
                           await = "Opened",
                           codestyle = "None", -- Disable codestyle checks (handled by stylua)
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
                        -- Ignore unused variables starting with underscore
                        unusedLocalExclude = { "_*" },
                     },
                     format = {
                        enable = false, -- Use stylua instead
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
               -- Prioritize go.work for multi-module workspaces, fallback to go.mod
               root_markers = { "go.work", "go.mod", ".git" },
               settings = {
                  gopls = {
                     -- Enable extra static analysis checks
                     analyses = { unusedparams = true, shadow = true },
                     -- Comprehensive inlay hints for Go's implicit typing
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

            -- Astro: mason-lspconfig before_init auto-resolves tsdk from project node_modules
            astro = {},

            -- Solidity
            solidity = {
               cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
               filetypes = { "solidity" },
               root_markers = { "foundry.toml", "hardhat.config.js", "hardhat.config.ts", "truffle-config.js", ".git" },
               single_file_support = true,
            },
         })

         return opts
      end,
   },
}
