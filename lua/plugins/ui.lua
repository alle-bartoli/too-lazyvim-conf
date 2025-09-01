-- See http://www.lazyvim.org/plugins/ui
return {

   -- Replace the UI for `messages`, `cmdline` and the `popupmenu`
   {
      "folke/noice.nvim",
      opts = function(_, opts)
         table.insert(opts.routes, {
            filter = {
               event = "notify",
               find = "No information available",
            },
            opts = { skip = true },
         })
         local focused = true
         vim.api.nvim_create_autocmd("FocusGained", {
            callback = function()
               focused = true
            end,
         })
         vim.api.nvim_create_autocmd("FocusLost", {
            callback = function()
               focused = false
            end,
         })
         table.insert(opts.routes, 1, {
            filter = {
               cond = function()
                  return not focused
               end,
            },
            view = "notify_send",
            opts = { stop = false },
         })

         opts.commands = {
            all = {
               -- options for the message history that you get with `:Noice`
               view = "split",
               opts = { enter = true, format = "details" },
               filter = {},
            },
         }

         vim.api.nvim_create_autocmd("FileType", {
            pattern = "markdown",
            callback = function(event)
               vim.schedule(function()
                  require("noice.text.markdown").keys(event.buf)
               end)
            end,
         })

         opts.presets.lsp_doc_border = true
      end,
   },

   {
      "rcarriga/nvim-notify",
      opts = {
         timeout = 5000,
      },
   },

   -- Neotree
   {
      "nvim-neo-tree/neo-tree.nvim",
      opts = {
         filesystem = {
            filtered_items = {
               visible = true,
               show_hidden_count = true,
               hide_dotfiles = false,
               hide_gitignored = false,
               hide_by_name = {},
               never_show = {
                  ".git",
                  ".DS_Store",
                  "thumbs.db",
               },
            },
         },
      },
   },

   -- Notification manager
   {
      "rcarriga/nvim-notify",
      opts = {
         timeout = 5000,
      },
   },

   -- Bufferline
   {
      "akinsho/bufferline.nvim",
      keys = {
         { "<Tab>", "<Cmd>BufferlineCycleNext<CR>", desc = "Next tab" },
         { "<S-Tab>", "<Cmd>BufferlineCyclePrev<CR>", desc = "Prev tab" },
      },
      opts = {
         options = {
            mode = "tabs",
            show_buffer_close_icons = false,
            show_close_icon = false,
         },
      },
      -- NOTE: tmp workaround -> https://github.com/LazyVim/LazyVim/pull/6354#issuecomment-3202799735
      init = function()
         local bufline = require("catppuccin.groups.integrations.bufferline")
         function bufline.get()
            return bufline.get_theme()
         end
      end,
   },

   -- Statusline
   {
      "nvim-lualine/lualine.nvim",
      event = "VeryLazy",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = function(_, opts)
         -- set theme
         ---@type table
         opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
            -- theme = "solarized_dark",
            theme = "lackluster",
            -- theme = "flow",
            -- theme = "lackluster",
            -- theme = "habamax",
            -- theme = "grail",
            -- theme = "deviuspro",
            -- theme = "midnight-desert",
         })

         -- add LazyVim pretty_path to lualine_c[4]
         local LazyVim = require("lazyvim.util")
         ---@type table
         opts.sections.lualine_c[4] = {
            LazyVim.lualine.pretty_path({
               length = 0,
               relative = "cwd",
               modified_hl = "MatchParen",
               directory_hl = "",
               filename_hl = "Bold",
               modified_sign = "",
               readonly_icon = " 󰌾 ",
            }),
         }
      end,
   },

   -- Filename
   {
      "b0o/incline.nvim",
      dependencies = { "craftzdog/solarized-osaka.nvim" },
      event = "BufReadPre",
      priority = 1200,
      config = function()
         local colors = require("solarized-osaka.colors").setup()
         require("incline").setup({
            highlight = {
               groups = {
                  InclineNormal = { guibg = colors.magenta500, guifg = colors.base04 },
                  InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
               },
            },
            window = { margin = { vertical = 0, horizontal = 1 } },
            hide = {
               cursorline = true,
            },
            render = function(props)
               local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
               if vim.bo[props.buf].modified then
                  filename = "[+] " .. filename
               end

               local icon, color = require("nvim-web-devicons").get_icon_color(filename)
               return { { icon, guifg = color }, { " " }, { filename } }
            end,
         })
      end,
   },

   -- Animations
   {
      "echasnovski/mini.animate",
      event = "VeryLazy",
      opts = function(_, opts)
         opts.scroll = {
            enable = false,
         }
      end,
   },

   {
      "folke/zen-mode.nvim",
      cmd = "ZenMode",
      opts = {
         plugins = {
            gitsigns = true,
            tmux = true,
            kitty = { enabled = false, font = "+2" },
         },
      },
      keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
   },

   -- Logo
   -- Generated with: https://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=TOO%20LAZY
   {
      "snacks.nvim",
      opts = {
         dashboard = {
            preset = {
               header = [[
████████╗ ██████╗  ██████╗     ██╗      █████╗ ███████╗██╗   ██╗
╚══██╔══╝██╔═══██╗██╔═══██╗    ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝
   ██║   ██║   ██║██║   ██║    ██║     ███████║  ███╔╝  ╚████╔╝ 
   ██║   ██║   ██║██║   ██║    ██║     ██╔══██║ ███╔╝    ╚██╔╝  
   ██║   ╚██████╔╝╚██████╔╝    ███████╗██║  ██║███████╗   ██║   
   ╚═╝    ╚═════╝  ╚═════╝     ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝   
               ]],
            },
         },
      },
      keys = {
         {
            "<leader>n",
            function()
               Snacks.notifier.show_history()
            end,
            desc = "Notification History",
         },
         {
            "<leader>un",
            function()
               Snacks.notifier.hide()
            end,
            desc = "Dismiss All Notifications",
         },
      },
   },
}
