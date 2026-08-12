-- ~/.config/nvim/lua/plugins/lsp.lua

return {
   -- MASON: Automatic installation of LSP servers, formatters, linters
   {
      "mason-org/mason.nvim",
      opts = function(_, opts)
         -- Extend (not replace) LazyVim's default ensure_installed list
         -- Extras handle: vtsls, js-debug-adapter (lang.typescript),
         -- eslint-lsp (linting.eslint), gopls, goimports, golangci-lint,
         -- delve (lang.go), astro-language-server (lang.astro),
         -- rust-analyzer, codelldb (lang.rust)
         vim.list_extend(opts.ensure_installed, {
            "stylua",
            "selene",
            "luacheck",
            "shellcheck",
            "shfmt",
            "tailwindcss-language-server",
            "typescript-language-server",
            "css-lsp",
            "nomicfoundation-solidity-language-server",
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
            -- vtsls does not support documentHighlight in astro buffers
            if vim.bo[bufnr].filetype == "astro" then
               client.server_capabilities.documentHighlightProvider = false
            end
         end

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
               },
            },

            -- TypeScript / JavaScript (vtsls is faster than tsserver)
            vtsls = {
               enabled = true,
               -- Only start in projects with explicit TS/JS config (avoids random .js files)
               root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
               single_file_support = false,
               filetypes = {
                  "javascript",
                  "javascriptreact",
                  "typescript",
                  "typescriptreact",
                  "astro",
               },
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
               filetypes = {
                  "javascript",
                  "javascriptreact",
                  "javascript.jsx",
                  "typescript",
                  "typescriptreact",
                  "typescript.tsx",
                  "vue",
                  "svelte",
                  "astro",
               },
               settings = {
                  workingDirectories = {
                     mode = "auto",
                  },
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

            -- Rust: handled by lang.rust extra (rustaceanvim).
            -- Custom settings applied via rustaceanvim opts in this file below.

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

            -- Astro: tsdk must be explicit -- server won't find TS types otherwise
            astro = {
               root_markers = {
                  "package.json",
                  "astro.config.mjs",
                  "astro.config.ts",
                  "astro.config.js",
                  ".git",
               },
               filetypes = {
                  "astro",
               },
               init_options = {
                  typescript = {
                     tsdk = vim.fn.fnamemodify(vim.fn.resolve(vim.fn.exepath("tsserver")), ":h"),
                  },
               },
               before_init = function(_, config)
                  -- Prefer project-local typescript over global
                  local root = vim.fs.root(0, { "package.json", "astro.config.mjs", "astro.config.ts" })
                  if root then
                     local local_tsdk = root .. "/node_modules/typescript/lib"
                     if vim.fn.isdirectory(local_tsdk) == 1 then
                        config.init_options = config.init_options or {}
                        config.init_options.typescript = config.init_options.typescript or {}
                        config.init_options.typescript.tsdk = local_tsdk
                     end
                  end
               end,
            },

            -- Solidity
            solidity = {
               cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
               filetypes = { "solidity" },
               root_markers = { "foundry.toml", "hardhat.config.js", "hardhat.config.ts", "truffle-config.js", ".git" },
               single_file_support = true,
            },

            -- Marksman
            marksman = false, -- Disabled: markdown-oxide handles PKM semantics

            -- markdown-oxide: PKM LSP con wikilink, backlink, rename, completion
            markdown_oxide = {
               capabilities = {
                  workspace = {
                     didChangeWatchedFiles = { dynamicRegistration = true },
                  },
               },
            },
         }) --[[@as table]]

         -- Setup hooks per server
         opts.setup = opts.setup or {}
         opts.setup.markdown_oxide = function(_, _)
            vim.api.nvim_create_user_command("Daily", function(args)
               vim.lsp.exec_cmd({ command = "jump", arguments = { args.args } }, { bufnr = 0 })
            end, { nargs = "*", desc = "Open the daily note (today/tomorrow/yesterday)" })
            return false -- lascia che LazyVim faccia il setup standard
         end

         return opts
      end,
   },

   -- Rustaceanvim: extend lang.rust extra with custom rust-analyzer settings.
   -- The extra provides cargo.allFeatures, buildScripts, procMacro, checkOnSave.
   -- We add: clippy command, experimental diagnostics, detailed inlay hints.
   {
      "mrcjkb/rustaceanvim",
      opts = {
         server = {
            default_settings = {
               ["rust-analyzer"] = {
                  checkOnSave = {
                     command = "clippy",
                  },
                  procMacro = {
                     attributes = { enable = true },
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
      },
   },
}
