return {
   {
      "saghen/blink.cmp",
      opts = {
         snippets = {
            expand = function(snippet, _)
               return LazyVim.cmp.expand(snippet)
            end,
         },
         appearance = {
            -- sets the fallback highlight groups to nvim-cmp's highlight groups
            -- useful for when your theme doesn't support blink.cmp
            -- will be removed in a future release, assuming themes add support
            use_nvim_cmp_as_default = false,
            -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- adjusts spacing to ensure icons are aligned
            nerd_font_variant = "mono",
         },
         completion = {
            accept = {
               -- experimental auto-brackets support
               auto_brackets = {
                  enabled = true,
               },
            },
            menu = {
               draw = {
                  treesitter = { "lsp" },
               },
            },
            documentation = {
               auto_show = true,
               auto_show_delay_ms = 200,
            },
            ghost_text = {
               enabled = vim.g.ai_cmp,
            },
         },

         -- experimental signature help support
         -- signature = { enabled = true },

         sources = {
            -- adding any nvim-cmp sources here will enable them
            -- with blink.compat
            compat = {},
            cmdline = {},
            -- add lazydev to your completion providers
            default = { "lazydev" }, -- default = { "lsp", "path", "snippets", "buffer" },
            providers = {
               lazydev = {
                  name = "LazyDev",
                  module = "lazydev.integrations.blink",
                  score_offset = 100, -- show at a higher priority than lsp
               },
            },
         },

         keymap = {
            preset = "enter",
            ["<C-y>"] = { "select_and_accept" },
         },
      },

      opts = function(_, opts)
         opts.appearance = opts.appearance or {}
         opts.appearance.kind_icons = vim.tbl_extend("keep", {
            Color = "██", -- Use block instead of icon for color items to make swatches more usable
         }, LazyVim.config.icons.kinds)
      end,
   },

   {
      "rafamadriz/friendly-snippets",
      -- add blink.compat to dependencies
      {
         "saghen/blink.compat",
         optional = true, -- make optional so it's only enabled if any extras need it
         opts = {},
         version = not vim.g.lazyvim_blink_main and "*",
      },
   },
}

