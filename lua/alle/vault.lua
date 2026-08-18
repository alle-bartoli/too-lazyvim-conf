local M = {}

-- Keep vault operations in one module so keymaps stay declarative and easy to change.
local VAULT = vim.fn.expand("~/vault")
local DAILY_DIR = VAULT .. "/daily"
local NOTES_DIR = VAULT .. "/notes"
local PROJECTS_DIR = VAULT .. "/projects"
local TEMPLATES_DIR = VAULT .. "/templates"

-- Prepare export.
M.root = VAULT

---@param name string
---@return string
local function slugify(name)
   return name:gsub("%s+", "-"):lower()
end

---@param path string
local function edit_file(path)
   vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
   vim.cmd.edit(vim.fn.fnameescape(path))
end

-- Open today's daily note, creating a small, predictable frontmatter block when needed.
function M.open_daily()
   local date = os.date("%Y-%m-%d")
   local path = DAILY_DIR .. "/" .. date .. ".md"

   if vim.fn.filereadable(path) == 0 then
      edit_file(path)
      vim.api.nvim_buf_set_lines(0, 0, 0, false, {
         "---",
         "title: " .. date,
         "date: " .. date,
         "tags: [daily]",
         "---",
         "",
         "# " .. date,
         "",
      })
      vim.cmd("normal! G")
      return
   end

   edit_file(path)
end

function M.new_note()
   local name = vim.fn.input("New note: ")
   if name == "" then
      return
   end

   local path = NOTES_DIR .. "/" .. slugify(name) .. ".md"
   edit_file(path)
   if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
      vim.api.nvim_buf_set_lines(0, 0, 0, false, {
         "---",
         "title: " .. name,
         "date: " .. os.date("%Y-%m-%d"),
         "tags: []",
         "---",
         "",
         "# " .. name,
         "",
      })
      vim.cmd("normal! G")
   end
end

-- Create project notes separately from permanent notes to keep the vault organized.
function M.new_project()
   local name = vim.fn.input("New project: ")
   if name == "" then
      return
   end

   local title = name:gsub("^%l", string.upper)
   local project_dir = PROJECTS_DIR .. "/" .. slugify(name)
   local path = project_dir .. "/index.md"
   edit_file(path)
   if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
      vim.api.nvim_buf_set_lines(0, 0, 0, false, {
         "---",
         "title: " .. title,
         "date: " .. os.date("%Y-%m-%d"),
         "tags: [project]",
         "status: active",
         "---",
         "",
         "# " .. title,
         "",
         "## TODO",
         "",
      })
      vim.cmd("normal! G")
   end
end

-- Create an additional Markdown note inside an existing project directory.
function M.new_project_note()
   ---@type string[]
   local directories = vim.fn.globpath(PROJECTS_DIR, "*", false, true)
   ---@type string[]
   local projects = {}
   for _, path in ipairs(directories) do
      if vim.fn.isdirectory(path) == 1 then
         table.insert(projects, path)
      end
   end

   if #projects == 0 then
      vim.notify("No project directories found in " .. PROJECTS_DIR, vim.log.levels.WARN)
      return
   end

   vim.ui.select(
      projects,
      {
         prompt = "Project:",
         ---@param path string
         ---@return string
         format_item = function(path)
            return vim.fn.fnamemodify(path, ":t")
         end,
      },
      ---@param project string|nil
      function(project)
         if not project then
            return
         end

         local name = vim.fn.input("New project note: ")
         if name == "" then
            return
         end

         local path = project .. "/" .. slugify(name) .. ".md"
         if vim.fn.filereadable(path) == 1 then
            vim.notify("Note already exists: " .. path, vim.log.levels.WARN)
            return
         end

         edit_file(path)
         vim.api.nvim_buf_set_lines(0, 0, -1, false, {
            "---",
            "title: " .. name,
            "date: " .. os.date("%Y-%m-%d"),
            "tags: [project]",
            "---",
            "",
            "# " .. name,
            "",
         })
         vim.cmd("normal! G")
      end
   )
end

-- Copy a template into notes/. Templates may use {{title}} and {{date}} placeholders.
function M.new_from_template()
   local files = vim.fn.globpath(TEMPLATES_DIR, "**/*.md", false, true)
   if #files == 0 then
      vim.notify("No Markdown templates found in " .. TEMPLATES_DIR, vim.log.levels.WARN)
      return
   end

   vim.ui.select(
      files,
      {
         prompt = "Template:",
         ---@param path string
         ---@return string
         format_item = function(path)
            return path:sub(#TEMPLATES_DIR + 2)
         end,
      },
      ---@param template string|nil
      function(template)
         if not template then
            return
         end

         local name = vim.fn.input("New note: ")
         if name == "" then
            return
         end

         local path = NOTES_DIR .. "/" .. slugify(name) .. ".md"
         if vim.fn.filereadable(path) == 1 then
            vim.notify("Note already exists: " .. path, vim.log.levels.WARN)
            return
         end

         local content = vim.fn.readfile(template)
         local today = os.date("%Y-%m-%d")
         for index, line in ipairs(content) do
            content[index] = line:gsub("{{title}}", name):gsub("{{date}}", today)
         end
         edit_file(path)
         vim.api.nvim_buf_set_lines(0, 0, -1, false, content)
         vim.cmd("normal! G")
      end
   )
end

return M
