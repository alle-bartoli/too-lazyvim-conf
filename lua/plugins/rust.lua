-- See https://www.lazyvim.org/extras/lang/rust
return {
   -- extend auto completion.
   {
      "hrsh7th/nvim-cmp",
      dependencies = {
         {
            "Saecki/crates.nvim",
            event = { "BufRead Cargo.toml" },
            config = true,
         },
      },
      ---@param opts cmp.ConfigSchema
      opts = function(_, opts)
         local cmp = require("cmp")
         opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
            { name = "crates", priority = 750 },
         }))
      end,
   },

   -- add rust to treesitter (see `treesitter.lua`)
   -- {
   --   "nvim-treesitter/nvim-treesitter",
   --   opts = function(_, opts)
   --      if type(opts.ensure_installed) == "table" then
   --         vim.list_extend(opts.ensure_installed, { "rust", "toml" })
   --      end
   --   end,
   -- },

   -- correctly setup mason lsp / dap extensions (see config.lsp.lua)
   --{
   --   "williamboman/mason.nvim",
   --   opts = function(_, opts)
   --      if type(opts.ensure_installed) == "table" then
   --         vim.list_extend(opts.ensure_installed, { "codelldb", "rust-analyzer", "taplo" })
   --      end
   --   end,
   --},

   {
      "mrcjkb/rustaceanvim",
      version = "^4", -- Recommended.
      ft = { "rust" },
      opts = {
         server = {
            on_attach = function(_, bufnr)
               vim.keymap.set("n", "<leader>cR", function()
                  vim.cmd.RustLsp("codeAction")
               end, { desc = "Code Action", buffer = bufnr })
               vim.keymap.set("n", "<leader>dr", function()
                  vim.cmd.RustLsp("debuggables")
               end, { desc = "Rust Debuggables", buffer = bufnr })
            end,
            default_settings = {
               -- rust-analyzer language server configuration.
               ["rust-analyzer"] = {
                  cargo = {
                     allFeatures = true,
                     loadOutDirsFromCheck = true,
                     buildScripts = {
                        enable = true,
                     },
                  },
                  -- Add clippy lints for Rust.
                  checkOnSave = true,
                  procMacro = {
                     enable = true,
                     ignored = {
                        ["async-trait"] = { "async_trait" },
                        ["napi-derive"] = { "napi" },
                        ["async-recursion"] = { "async_recursion" },
                     },
                  },
               },
            },
         },
      },
      config = function(_, opts)
         vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
         if vim.fn.executable("rust-analyzer") == 0 then
            LazyVim.error(
               "**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/",
               { title = "rustaceanvim" }
            )
         end
      end,
   },

   -- correctly setup lspconfig for Rust 🚀
   {
      "neovim/nvim-lspconfig",
      opts = {

         setup = {
            -- fix rust-analyzer plugin mismatch.
            rust_analyzer = function()
               return true
            end,
         },
         servers = {
            taplo = {
               keys = {
                  {
                     "K",
                     function()
                        if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                           require("crates").show_popup()
                        else
                           vim.lsp.buf.hover()
                        end
                     end,
                     desc = "Show Crate Documentation",
                  },
               },
            },
         },
      },
   },
}
