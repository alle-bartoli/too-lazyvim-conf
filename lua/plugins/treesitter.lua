-- See https://www.lazyvim.org/plugins/treesitter
return {
   {
      "nvim-treesitter/nvim-treesitter",
      highlight = { enable = true },
      indent = { enable = true },
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

         -- https://github.com/nvim-treesitter/playground#query-linter
         opts.query_linter = {
            enable = true,
            use_virtual_text = true,
            lint_events = { "BufWrite", "CursorHold" },
         }

         opts.playground = {
            enable = true,
            disable = {},
            updatetime = 25,
            persist_queries = true,
            keybindings = {
               toggle_query_editor = "o",
               toggle_hl_groups = "i",
               toggle_injected_languages = "t",
               toggle_anonymous_nodes = "a",
               toggle_language_display = "I",
               focus_language = "f",
               unfocus_language = "F",
               update = "R",
               goto_node = "<cr>",
               show_help = "?",
            },
         }

         return opts
      end,
   },
}
