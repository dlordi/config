local M = {}

M.setup = function()
  print('sample.nvim loaded')
end

local on_select = function()
  local win = 0
  local buf = vim.api.nvim_win_get_buf(win)
  local cursor = vim.api.nvim_win_get_cursor(win)
  local row = cursor[1] -- 1-indexed
  -- local col = cursor[2] -- 0-indexed
  print(vim.api.nvim_buf_get_lines(buf, 0, -1, true)[row])
end

local on_quit = function()
  local win = 0
  pcall(vim.api.nvim_win_close, win, true)
end

local create_win_config = function()
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  return {
    title = 'Title of sample.nvim',
    relative = 'editor',
    style = 'minimal',
    border = 'rounded',
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2 - 1,
  }
end

M.sample = function(lines)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)
  -- modifiable must be disabled AFTER its content has been set/changed!
  vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
  vim.api.nvim_buf_add_highlight(buf, -1, 'String', 0, 0, -1)
  vim.keymap.set('n', 'x', on_select, { buffer = buf })
  vim.keymap.set('n', 'q', on_quit, { buffer = buf })

  local win = vim.api.nvim_open_win(buf, true, create_win_config())
  vim.api.nvim_create_autocmd('WinLeave', { callback = on_quit })
  vim.api.nvim_create_autocmd('VimResized', {
    group = vim.api.nvim_create_augroup('sample-VimResized', {}),
    callback = function()
      if not vim.api.nvim_win_is_valid(win) then
        -- handles closed window
        return
      end
      vim.api.nvim_win_set_config(win, create_win_config())
    end,
  })
end

-- vim.keymap.set('n', '<Leader>la', function()
--   local lines = { 'sample.nvim line 1', 'sample.nvim line 2', 'sample.nvim line 3' }
--   M.sample(lines)
-- end)

return M
