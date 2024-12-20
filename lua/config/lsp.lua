-- LSP config.
return {
   opts = function(_, opts)
      -- Ensure the "ensure_installed" table exists.
      if not opts.ensure_installed then
         opts.ensure_installed = {}
      end

      -- Extend the ensure_installed array with the desired language servers and tools.
      vim.list_extend(opts.ensure_installed, {
         "stylua",
         "selene",
         "luacheck",
         "shellcheck",
         "shfmt",
         "tailwindcss-language-server",
         "typescript-language-server",
         "css-lsp",
         "codelldb", -- Rust debugger.
         "rust-analyzer", -- Rust LSP.
         "taplo", -- TOML LSP, useful for Rust.
         "markdownlint-cli2", -- Markdown linter.
         "markdown-toc", -- Markdown toc.
      })("williamboman/mason.nvim")

      -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the inlay hints.
      opts.inlay_hints = {
         enabled = false,
         --exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints.
      }
   end,

   {
      "williamboman/mason.nvim",
      lazy = false,
      config = function()
         require("mason").setup()
      end,
   },

   {
      "williamboman/mason-lspconfig.nvim",
      lazy = false,
      opts = {
         auto_install = true,
      },
   },

   {
      "neovim/nvim-lspconfig",
      lazy = false,
      opts = {
         setup = {
            rust_analyzer = function()
               return true
            end,
         },
         servers = {
            rust_analyzer = {
               mason = false,
            },
            pyright = {
               settings = {
                  python = {
                     analysis = {
                        diagnosticSeverityOverrides = {
                           reportGeneralTypeIssues = "none", -- Disable general type issues warnings
                           reportMissingImports = "none", -- Disable missing imports warnings
                           reportMissingTypeStubs = "none", -- Disable missing type stubs warnings
                           reportUnnecessaryTypeIgnoreComment = "none", -- Disable unnecessary 'type: ignore' comment warnings
                        },
                     },
                  },
               },
            },
         },
      },
      config = function()
         local capabilities = require("cmp_nvim_lsp").default_capabilities()

         -- Setup language servers.
         local lspconfig = require("lspconfig")
         lspconfig.tsserver.setup({ capabilities = capabilities })
         lspconfig.eslint.setup({
            on_attach = function(client, bufnr)
               vim.api.nvim_create_autocmd("BufWritePre", {
                  buffer = bufnr,
                  command = "EslintFixAll",
               })
            end,
            capabilities = capabilities,
         })
         require("lspconfig").eslint.setup({})
      end,
   },
}
