-- ~/.config/nvim/lua/plugins/hunk.lua

-- Hunk: terminal-based diff viewer for reviewing agent-authored changesets.
-- https://hunk.dev/

return {
   {
      "snacks.nvim",
      keys = {
         { "<leader>hd", function() Snacks.terminal("hunk diff", { cwd = LazyVim.root.git() }) end, desc = "Hunk: diff (working tree)" },
         { "<leader>hS", function() Snacks.terminal("hunk diff --staged", { cwd = LazyVim.root.git() }) end, desc = "Hunk: diff (staged)" },
         { "<leader>hs", function() Snacks.terminal("hunk show", { cwd = LazyVim.root.git() }) end, desc = "Hunk: show (last commit)" },
      },
   },
}