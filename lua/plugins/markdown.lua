-- ~/.config/nvim/lua/plugins/markdown.lua

return {
   {
      "MeanderingProgrammer/render-markdown.nvim",
      ft = { "markdown", "markdown_inline" },
      opts = {
         -- Renderizza anche in insert mode; di default la riga sotto il cursore
         -- si "smonta" e il testo salta. Rimuovere "i" se dà fastidio in scrittura.
         render_modes = { "n", "c", "t" },
         anti_conceal = { enabled = true },

         heading = {
            sign = false,
            width = "block",
            left_pad = 0,
            right_pad = 2,
            icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
         },

         code = {
            style = "full",
            width = "block",
            left_pad = 2,
            right_pad = 4,
            border = "thin",
         },

         bullet = { icons = { "●", "○", "◆", "◇" } },

         checkbox = {
            unchecked = { icon = "󰄱 " },
            checked = { icon = "󰱒 ", scope_highlight = "@markup.strikethrough" },
            custom = {
               todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
               cancelled = { raw = "[~]", rendered = "󰜺 ", highlight = "Comment" },
            },
         },

         pipe_table = { style = "full", alignment_indicator = "─" },
         link = { wiki = { icon = "󰌷 ", highlight = "RenderMarkdownWikiLink" } },
      },
   },
}
