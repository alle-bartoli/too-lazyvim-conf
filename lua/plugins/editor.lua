-- ~/.config/nvim/lua/plugins/editor.lua

-- Editor confiuration

-- `mfussenegger/nvim-lint`
-- Thanks to `luigir-it`: https://github.com/LazyVim/LazyVim/discussions/4094#discussioncomment-10178217
-- The issue is that "~" is not expanded.
-- And this is the standard behavior in bash when quoted.
-- I also tried with $HOME, which is also not expanded.
-- This hints that the string is passed as literal to the shell.
-- If you want your config to be machine agnostic,
-- you can declare a local variable and substitute it in the args table.
local HOME = os.getenv("HOME")

return {

   -- File browser
   {
      "fzf-lua", -- opts = nil
   },

   -- fzf-lua (fzf improved)
   {
      "ibhagwan/fzf-lua",
      cmd = "FzfLua",
      -- optional for icon support
      dependencies = { "nvim-tree/nvim-web-devicons" },
      -- or if using mini.icons/mini.nvim
      -- dependencies = { "nvim-mini/mini.icons" },
      opts = function(_, opts)
         local config = require("fzf-lua.config")
         local actions = require("fzf-lua.actions")

         -- Quickfix
         config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
         config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
         config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
         config.defaults.keymap.fzf["ctrl-x"] = "jump"
         config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
         config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
         config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
         config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"

         -- Trouble
         if LazyVim.has("trouble.nvim") then
            config.defaults.actions.files["ctrl-t"] = require("trouble.sources.fzf").actions.open
         end

         -- Toggle root dir / cwd
         config.defaults.actions.files["ctrl-r"] = function(_, ctx)
            local o = vim.deepcopy(ctx.__call_opts)
            o.root = o.root == false
            o.cwd = nil
            o.buf = ctx.__CTX.bufnr
            LazyVim.pick.open(ctx.__INFO.cmd, o)
         end
         config.defaults.actions.files["alt-c"] = config.defaults.actions.files["ctrl-r"]
         config.set_action_helpstr(config.defaults.actions.files["ctrl-r"], "toggle-root-dir")

         local img_previewer ---@type string[]?
         for _, v in ipairs({
            { cmd = "ueberzug", args = {} },
            { cmd = "chafa", args = { "{file}", "--format=symbols" } },
            { cmd = "viu", args = { "-b" } },
         }) do
            if vim.fn.executable(v.cmd) == 1 then
               img_previewer = vim.list_extend({ v.cmd }, v.args)
               break
            end
         end

         return {
            "default-title",
            fzf_colors = true,
            fzf_opts = {
               ["--no-scrollbar"] = true,
            },
            defaults = {
               -- formatter = "path.filename_first",
               formatter = "path.dirname_first",
            },
            previewers = {
               builtin = {
                  extensions = {
                     ["png"] = img_previewer,
                     ["jpg"] = img_previewer,
                     ["jpeg"] = img_previewer,
                     ["gif"] = img_previewer,
                     ["webp"] = img_previewer,
                  },
                  ueberzug_scaler = "fit_contain",
               },
            },
            -- Custom LazyVim option to configure vim.ui.select
            ui_select = function(fzf_opts, items)
               return vim.tbl_deep_extend("force", fzf_opts, {
                  prompt = " ",
                  winopts = {
                     title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
                     title_pos = "center",
                  },
               }, fzf_opts.kind == "codeaction" and {
                  winopts = {
                     layout = "vertical",
                     -- height is number of items minus 15 lines for the preview, with a max of 80% screen height
                     height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 2) + 0.5) + 16,
                     width = 0.5,
                     preview = not vim.tbl_isempty(vim.lsp.get_clients({ bufnr = 0, name = "vtsls" })) and {
                        layout = "vertical",
                        vertical = "down:15,border-top",
                        hidden = "hidden",
                     } or {
                        layout = "vertical",
                        vertical = "down:15,border-top",
                     },
                  },
               } or {
                  winopts = {
                     width = 0.5,
                     -- height is number of items, with a max of 80% screen height
                     height = math.floor(math.min(vim.o.lines * 0.8, #items + 2) + 0.5),
                  },
               })
            end,
            winopts = {
               width = 0.8,
               height = 0.8,
               row = 0.5,
               col = 0.5,
               preview = {
                  scrollchars = { "┃", "" },
               },
            },
            files = {
               cwd_prompt = false,
               actions = {
                  ["alt-i"] = { actions.toggle_ignore },
                  ["alt-h"] = { actions.toggle_hidden },
               },
            },
            grep = {
               actions = {
                  ["alt-i"] = { actions.toggle_ignore },
                  ["alt-h"] = { actions.toggle_hidden },
               },
            },
            lsp = {
               symbols = {
                  symbol_hl = function(s)
                     return "TroubleIcon" .. s
                  end,
                  symbol_fmt = function(s)
                     return s:lower() .. "\t"
                  end,
                  child_prefix = false,
               },
               code_actions = {
                  previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
               },
            },
         }
      end,
   },

   -- Todo Comments
   {
      "folke/todo-comments.nvim",
      optional = true,
      -- stylua: ignore
      keys = {
         { "<leader>st", function() require("todo-comments.fzf").todo() end, desc = "Todo" },
         { "<leader>sT", function () require("todo-comments.fzf").todo({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
      },
   },

   -- Navigate your code with search labels
   {
      "folke/flash.nvim",
      event = "VeryLazy",
      ---@type Flash.Config
      opts = {},
      -- stylua: ignore
      keys = {
        { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
        { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
        { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      },
   },

   {
      "nvim-mini/mini.hipatterns",
      event = "BufReadPre",
      opts = function()
         local hipatterns = require("mini.hipatterns")
         local hsl_utils = require("solarized-osaka.hsl")

         return {
            highlighters = {
               hsl_color = {
                  pattern = "hsl%(%d+,%s*%d+%%,%s*%d+%%%)",
                  group = function(_, match)
                     ---@type string
                     local str = match
                     local nh, ns, nl = str:match("hsl%((%d+),%s*(%d+)%%,%s*(%d+)%%%)")
                     local h, s, l = tonumber(nh), tonumber(ns), tonumber(nl)

                     if h == nil or s == nil or l == nil then
                        return nil -- fallback: don't highlight if parsing fails
                     end

                     local hex_color = hsl_utils.hslToHex(h, s, l)
                     return hipatterns.compute_hex_color_group(hex_color, "bg")
                  end,
               },
               hex_color = {
                  pattern = "#%x%x%x%x%x%x?", -- #RGB o #RRGGBB
                  group = function(_, match)
                     return hipatterns.compute_hex_color_group(match, "bg")
                  end,
               },
            },
         }
      end,
   },

   -- `markdownlint-cli2` config.
   -- Thanks to `luigir-it`: https://github.com/LazyVim/LazyVim/discussions/4094#discussioncomment-10178217
   {
      "mfussenegger/nvim-lint",
      optional = true,
      opts = {
         linters_by_ft = {
            -- Go: disable golangci-lint, rely on gopls + staticcheck instead
            -- (golangci-lint's typecheck doesn't work well with go.work)
            go = {},
         },
         linters = {
            ["markdownlint-cli2"] = {
               args = { "--config", HOME .. "/.markdownlint-cli2.yaml", "--" },
            },
         },
      },
   },

   -- nvim-spectre: Search and replace
   {
      "nvim-pack/nvim-spectre",
      dependencies = { "nvim-lua/plenary.nvim" },
      keys = {
         {
            "<leader>sr",
            function()
               require("spectre").open()
            end,
            desc = "Search and Replace",
         },
      },
   },
}
