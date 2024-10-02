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

      -- LSP Setup for rust-analyzer.
      require("lspconfig").rust_analyzer.setup({
         settings = {
            ["rust-analyzer"] = {
               inlayHints = {
                  parameterHints = false,
                  variableHints = false,
                  -- You can add more settings here if needed.
               },
            },
         },
      })
   end,
}
