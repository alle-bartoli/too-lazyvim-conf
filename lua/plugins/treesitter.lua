-- AppleScript isn't in nvim-treesitter's parser list, so register it by hand.
-- nvim-treesitter's install.lua resets package.loaded on every install/update
-- (reload_parsers) and re-reads the table, so we re-apply on the TSUpdate event.
-- This must run at spec-collection time (top-level), before nvim-treesitter
-- loads and fires its first install pass.
local function register_applescript()
   local ok, parsers = pcall(require, "nvim-treesitter.parsers")
   if not ok then
      return
   end
   ---@diagnostic disable-next-line: missing-fields
   parsers.applescript = {
      ---@diagnostic disable-next-line: missing-fields
      install_info = {
         -- revision omitted intentionally; use branch=main for latest
         url = "https://github.com/waddie/tree-sitter-applescript",
         files = { "src/parser.c", "src/scanner.c" },
         queries = "queries",
         branch = "main",
      },
      filetype = "applescript",
   }
end

register_applescript()
vim.api.nvim_create_autocmd("User", {
   pattern = "TSUpdate",
   callback = register_applescript,
})

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
            "applescript", -- AppleScript (.applescript, .scpt source)
         })

         return opts
      end,
   },
}
