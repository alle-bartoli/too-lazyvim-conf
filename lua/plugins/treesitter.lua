-- See https://www.lazyvim.org/plugins/treesitter
return {
   {
      "nvim-treesitter/nvim-treesitter",
      highlight = { enable = true },
      indent = { enable = true },
      opts = {
         ensure_installed = {
            "jsdoc",
            "json",
            "jsonc",
            "bash",
            "astro",
            "cmake",
            "cpp",
            "css",
            "fish",
            "gitignore",
            "go",
            "graphql",
            "http",
            "java",
            "php",
            "scss",
            "sql",
            "svelte",
            "rust", -- Required for rust.
            "toml", -- Required for rust.
         },
      },
      config = function(_, opts)
         require("nvim-treesitter.configs").setup(opts)

         -- MDX.
         vim.filetype.add({
            extension = {
               mdx = "mdx",
            },
         })
         vim.treesitter.language.register("markdown", "mdx")
      end,
   },
}
