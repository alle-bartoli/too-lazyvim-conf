-- LSP config.
return {
   opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
         "stylua",
         "selene",
         "luacheck",
         "shellcheck",
         "shfmt",
         "tailwindcss-language-server",
         "typescript-language-server",
         "css-lsp",
         "codelldb", -- rust.
         "rust-analyzer", -- rust.
         "taplo", -- rust.
         "markdownlint-cli2", -- markdown.
         "markdown-toc", -- markdown.
      })("williamboman/mason.nvim")
   end,
}
