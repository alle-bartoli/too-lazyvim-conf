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
      })("williamboman/mason.nvim")
   end,
}
