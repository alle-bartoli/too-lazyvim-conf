-- See http://www.lazyvim.org/plugins/ui
return {
   opts = {
      options = {
         mode = "tabs",
         show_buffer_close_icons = false,
         show_close_icon = false,
      },
   },

   -- Replace the UI for `messages`, `cmdline` and the `popupmenu`.
   {
      "folke/noice.nvim",
      event = "VeryLazy",
      dependencies = {
         -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
         "MunifTanjim/nui.nvim",
         -- OPTIONAL:
         --   `nvim-notify` is only needed, if you want to use the notification view.
         --   If not available, we use `mini` as the fallback
         "rcarriga/nvim-notify",
      },

      opts = function(_, opts)
         -- Merge the lsp config.
         opts.lsp = {
            override = {
               ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
               ["vim.lsp.util.stylize_markdown"] = true,
               ["cmp.entry.get_documentation"] = true,
            },
         }

         -- Merge the routes config.
         opts.routes = opts.routes or {}
         vim.list_extend(opts.routes, {
            {
               filter = {
                  event = "notify",
                  find = "No information available",
               },
               opts = { skip = true },
            },
            {
               filter = {
                  event = "msg_show",
                  any = {
                     { find = "%d+L, %d+B" },
                     { find = "; after #%d+" },
                     { find = "; before #%d+" },
                  },
               },
               view = "mini",
            },
         })

         -- Merge the presets config.
         opts.presets = vim.tbl_deep_extend("force", opts.presets or {}, {
            lsp_doc_border = true,
            bottom_search = true,
            command_palette = true,
            long_message_to_split = true,
         })
      end,
   },

   -- Neotree.
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

   -- Notification manager.
   {
      "rcarriga/nvim-notify",
      opts = {
         timeout = 10000,
      },
   },

   -- Bufferline.
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
   },

   -- Statusline.
   {
      "nvim-lualine/lualine.nvim",
      event = "VeryLazy",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {
         options = {
            -- theme = "solarized_dark",
            theme = "lackluster",
         },
      },
   },

   -- Filename.
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
                  InlcineNormal = {
                     guibg = colors.magenta500,
                     guifg = colors.base04,
                  },
                  InclineNormalNC = {
                     guifg = colors.violet500,
                     guibg = colors.base03,
                  },
               },
            },
            window = { margin = { vertical = 0, horizontal = 0 } },
            hide = {
               cursorline = true,
            },
            render = function(props)
               local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
               if vim.bo[props.buf].modified then
                  filename = "[+]" .. filename
               end
               local icon, color = require("nvim-web-devicons").get_icon_color(filename)
               return { { icon, guifg = color }, { " " }, { filename } }
            end,
         })
      end,
   },

   -- Animations.
   {
      "echasnovski/mini.animate",
      event = "VeryLazy",
      opts = function(_, opts)
         opts.scroll = {
            enable = false,
         }
      end,
   },

   -- Disable new dashboard.
   { "folke/snacks.nvim", opts = { dashboard = { enabled = true } } },

   -- Logo.
   -- Generated with: https://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=TOO%20LAZY
   {
      "nvimdev/dashboard-nvim",
      event = "VimEnter",
      opts = function(_, opts)
         local logo = [[
████████╗ ██████╗  ██████╗     ██╗      █████╗ ███████╗██╗   ██╗
╚══██╔══╝██╔═══██╗██╔═══██╗    ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝
   ██║   ██║   ██║██║   ██║    ██║     ███████║  ███╔╝  ╚████╔╝ 
   ██║   ██║   ██║██║   ██║    ██║     ██╔══██║ ███╔╝    ╚██╔╝  
   ██║   ╚██████╔╝╚██████╔╝    ███████╗██║  ██║███████╗   ██║   
   ╚═╝    ╚═════╝  ╚═════╝     ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝   
         ]]
         logo = string.rep("\n", 8) .. logo .. "\n\n"

         opts.config = opts.config or {} -- Ensure `opts.config` exists before indexing it to avoid errors.
         opts.config.header = vim.split(logo, "\n")
      end,
   },
}
