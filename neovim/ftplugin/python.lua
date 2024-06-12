local read_lines_from_file = function(file_path)
  local file = require("plenary.path").new(file_path)
  return file:exists() and file:readlines() or {}
end

local string_starts_with = function(string, start)
  return string.sub(string, 1, string.len(start)) == start
end

-- if python 2 is the default runtime uses different indentation options...
for _, line in ipairs(read_lines_from_file([[C:\Windows\py.ini]])) do
  if string_starts_with(line, "python=2") then
    vim.opt.expandtab = false
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4
    vim.g.python_recommended_style = 0 -- ensures previous settings would NOT be overwritten
  end
end
