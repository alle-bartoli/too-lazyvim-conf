-- See https://www.lazyvim.org/plugins/treesitter
return {
   {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
         vim.list_extend(opts.ensure_installed, {
            "vimdoc",
            "luadoc",
            "vim",
            "lua",
            "markdown",
            "markdown_inline",
            "mdx",
            "jsdoc",
            "json",
            "jsonc",
            "bash",
            "astro",
            "cmake",
            "make",
            "cpp",
            "css",
            "scss",
            "fish",
            "gitignore",
            "go",
            "graphql",
            "http",
            "java",
            "php",
            "sql",
            "svelte",
            "rust", -- Required for rust
            "toml", -- Required for rust
            "solidity", -- Solidity smart contracts
         })

         return opts
      end,
   },
}
