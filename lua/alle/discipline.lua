-- discipline.lua
-- Custom notification about overusing simple move keys.

local M = {}

--- Notifies the user if they overuse movement keys like hjkl (arrows exluded).
function M.clown()
   ---@type number|string|nil
   local id
   local ok = true

   for _, key in ipairs({
      "h",
      "j",
      "k",
      "l",
      "+",
      "-",
      --"<Up>",
      --"<Down>",
      --"<Left>",
      --"<Right>"
   }) do
      local count = 0
      local timer = assert(vim.uv.new_timer())
      local map = key

      vim.keymap.set("n", key, function()
         if vim.v.count > 0 then
            count = 0
         end

         if count >= 10 then
            ok, id = pcall(vim.notify, "Hold on fam 🤡", vim.log.levels.WARN, {
               replace = id,
               keep = function()
                  return count >= 10
               end,
            })

            if not ok then
               id = nil
               return map
            end
         else
            count = count + 1
            timer:start(2000, 0, function()
               count = 0
            end)
            return map
         end
      end, { expr = true, silent = true })
   end
end

return M
