-- See: https://www.lazyvim.org/extras/lang/markdown
return {
   {
      "MeanderingProgrammer/markdown.nvim",
      opts = {
         file_types = { "markdown", "norg", "rmd", "org" },
         code = {
            sign = false,
            width = "block",
            right_pad = 1,
         },
         heading = {
            sign = false,
            icons = {},
         },
      },
      ft = { "markdown", "norg", "rmd", "org" },
      config = function(_, opts)
         require("render-markdown").setup(opts)
         LazyVim.toggle.map("<leader>um", {
            name = "Render Markdown",
            get = function()
               return require("render-markdown.state").enabled
            end,
            set = function(enabled)
               local m = require("render-markdown")
               if enabled then
                  m.enable()
               else
                  m.disable()
               end
            end,
         })
      end,
   },

   {
      "stevearc/conform.nvim",
      optional = true,
      opts = {
         formatters = {
            ["markdown-toc"] = {
               condition = function(_, ctx)
                  for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
                     if line:find("<!%-%- toc %-%->") then
                        return true
                     end
                  end
               end,
            },
            ["markdownlint-cli2"] = {
               condition = function(_, ctx)
                  local diag = vim.tbl_filter(function(d)
                     return d.source == "markdownlint"
                  end, vim.diagnostic.get(ctx.buf))
                  return #diag > 0
               end,
            },
         },
         formatters_by_ft = {
            ["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
            ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
         },
      },
   },

   {
      "nvimtools/none-ls.nvim",
      optional = true,
      opts = function(_, opts)
         local nls = require("null-ls")
         opts.sources = vim.list_extend(opts.sources or {}, {
            nls.builtins.diagnostics.markdownlint_cli2,
         })
      end,
   },

   {
      "nvimtools/none-ls.nvim",
      optional = true,
      opts = function(_, opts)
         local nls = require("null-ls")
         opts.sources = vim.list_extend(opts.sources or {}, {
            nls.builtins.diagnostics.markdownlint_cli2,
         })
      end,
   },
}
