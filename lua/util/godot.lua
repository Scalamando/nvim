local M = {}

function M.is_godot_project(path)
  path = path or vim.loop.cwd()

  local found = vim.fs.find("project.godot", {
    upward = true,
    path = path,
    stop = vim.loop.cwd(),
  })[1]

  return found ~= nil
end

return M
