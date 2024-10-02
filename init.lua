-- Bootstrap lazy.nvim, LazyVim and your plugins.
require("config.lazy")

-- Disable inlay hints.
--vim.lsp.buf.inlay_hint(0, false)

-- Get the current line's content.
--local current_line = vim.api.nvim_get_current_line()

-- Get the current cursor position (row, col).
--local cursor_pos = vim.api.nvim_win_get_cursor(0)

-- If the current line is empty and we're not at the top of the buffer, move the cursor up.
--if #current_line == 0 and cursor_pos[1] > 1 then
--cursor_pos[1] = cursor_pos[1] - 1 -- Move cursor to the previous line.
--vim.api.nvim_win_set_cursor(0, cursor_pos) -- Set the new cursor position.
--end
