-- detect python 3
(function()
  if vim.g.python3_host_prog then
    return
  end

  for _, python_cmd in ipairs({ 'python', 'python3' }) do
    if vim.fn.executable(python_cmd) == 1 then
      local output = vim.fn.system({ python_cmd, '-c', 'import sys; print(sys.version_info.major)' })
      if (vim.v.shell_error == 0) and (output:gsub('%s+', '') == '3') then
        return
      end
    end
  end

  local fs_stat = (vim.uv or vim.loop).fs_stat
  local win32_program_files = os.getenv('ProgramFiles')
  for _, path in ipairs({ win32_program_files .. [[\Python311\python.exe]] }) do
    if fs_stat(path) then
      vim.g.python3_host_prog = path
      return
    end
  end
end)()

if vim.g.neovide then
  local font_name = 'JetBrainsMonoNL NFM'
  local font_size = vim.loop.os_uname().sysname == 'Windows_NT' and '10' or '14'
  vim.o.guifont = font_name .. ':h' .. font_size

  -- enable MacOS "Command" key
  vim.g.neovide_input_use_logo = 1

  -- enable MacOS system clipboard
  vim.keymap.set('', '<D-v>', '+p<CR>', { noremap = true, silent = true })
  vim.keymap.set({ '!', 't', 'v' }, '<D-v>', '<C-R>+', { noremap = true, silent = true })

  -- enable Windows system clipboard
  vim.keymap.set('i', '<C-v>', '<C-R>+', { noremap = true, silent = true })
  vim.keymap.set('!', '<S-Insert>', '<C-R>+', { noremap = true, silent = true })
end

-- lazy.nvim plugin manager (https://lazy.folke.io/installation)
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- configure wellle/context.vim before the plugin is loaded
vim.g.context_max_height = 5

require('lazy').setup({
  {
    'Mofiqul/vscode.nvim',
    priority = 1000,
    config = function()
      require('vscode').setup({
        color_overrides = {
          vscBack = '#000000',
        },
      })
      vim.cmd.colorscheme('vscode')
    end,
  },
  'nvim-lua/plenary.nvim',
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'lua',
          'python',
          'javascript',
          'json',
          'markdown',
          'markdown_inline',
          -- 'go',
          -- 'c',
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  { 'wellle/context.vim' },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client == nil then
            return
          end
          vim.keymap.set('n', '<Leader>re', vim.lsp.buf.rename, { buffer = event.buf, desc = 'LSP: Rename' })
          vim.keymap.set('n', '<Leader>df', vim.lsp.buf.definition, { buffer = event.buf, desc = 'LSP: Goto defin.' })
        end,
      })
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { 'vim' } },
              -- workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
              telemetry = { enable = false },
            },
          },
        },
        pyright = {
          settings = {
            pyright = {
              disableOrganizeImports = true,
              -- suppress ALL hints, eg unused variables; see https://github.com/microsoft/pyright/discussions/5852 for
              -- a different solution
              disableTaggedHints = true,
            },
            python = {
              -- see https://microsoft.github.io/pyright/#/settings
              pythonPath = vim.g.python3_host_prog,
              analysis = {
                typeCheckingMode = 'off',
                diagnosticMode = 'openFilesOnly',
              },
            },
          },
        },
      }
      require('mason').setup({
        ui = {
          icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
          },
        },
      })
      require('mason-tool-installer').setup({
        ensure_installed = {
          'stylua',
          'lua_ls',
          'prettier',
          'pyright',
          -- 'gopls',
          -- 'goimports',
          -- 'clangd',
          -- 'clang-format',
        },
      })
      require('mason-lspconfig').setup({
        handlers = {
          function(server_name)
            require('lspconfig')[server_name].setup(servers[server_name] or {})
          end,
        },
      })
    end,
  },
  {
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          lua = { 'stylua' },
          -- python = { 'ruff_fix', 'ruff_format' },
          javascript = { 'prettier' },
          typescript = { 'prettier' },
          javascriptreact = { 'prettier' },
          typescriptreact = { 'prettier' },
          json = { 'prettier' },
          markdown = { 'prettier' },
          svelte = { 'prettier' },
          css = { 'prettier' },
          html = { 'prettier' },
          yaml = { 'prettier' },
          -- go = { 'goimports' },
          -- c = { 'clang-format' },
        },
        format_on_save = {
          lsp_fallback = true,
          async = false,
          timeout_ms = 500,
        },
      })
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        -- on_attach = function(buffer)
        --   local map = function (l, r, opts)
        --     opts = opts or {}
        --     opts.buffer = buffer
        --     vim.keymap.set('n', l, r, opts)
        --   end
        --
        --   local gitsigns = require('gitsigns')
        --
        --   map(']]', function()
        --     if vim.wo.diff then
        --       vim.cmd.normal({ ']]', bang = true })
        --     else
        --       gitsigns.nav_hunk('next')
        --     end
        --   end)
        --   map('[[', function()
        --     if vim.wo.diff then
        --       vim.cmd.normal({ '[[', bang = true })
        --     else
        --       gitsigns.nav_hunk('prev')
        --     end
        --   end)
        --
        --   -- map('<leader>hS', gitsigns.stage_buffer)
        --   -- map('<leader>hu', gitsigns.undo_stage_hunk)
        --   -- map('<leader>hR', gitsigns.reset_buffer)
        --   -- map('<leader>hp', gitsigns.preview_hunk)
        --   map('<leader>hd', function()
        --     gitsigns.diffthis('HEAD')
        --   end)
        -- end,
      })
    end,
  },
  'tpope/vim-sleuth',
  'tpope/vim-fugitive',
  'Shatur/neovim-session-manager',
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {}, -- required to enable the plugin with default settings
  },
  {
    'RRethy/vim-illuminate',
    config = function()
      local illuminate = require('illuminate')
      illuminate.configure({
        providers = {
          'regex',
          -- 'lsp',
          -- 'treesitter',
        },
      })
      -- vim.keymap.set('n', '<A-Right>', illuminate.goto_next_reference)
      -- vim.keymap.set('n', '<A-Left>', illuminate.goto_prev_reference)
    end,
  },
  {
    'lewis6991/satellite.nvim',
    config = function()
      require('satellite').setup({
        winblend = 0,
        handlers = {
          cursor = { enable = false },
          search = { enable = false },
          diagnostic = {
            signs = { '━', '━', '━' },
            -- min_severity = vim.diagnostic.severity.HINT,
          },
          gitsigns = { signs = { add = '┃', change = '┃', delete = '━' } },
          marks = { enable = true },
        },
      })
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },
  -- {
  --   'stevearc/oil.nvim',
  --   opts = {},
  -- },
})

vim.schedule(function() -- this setting is applied after `UiEnter` event because it can increase startup-time
  vim.opt.clipboard = 'unnamedplus' -- use system clipboard for copy (aka yank) / paste
end)
vim.opt.number = true -- show line numbers
vim.opt.relativenumber = true -- show line number offsets
-- do not show line number offsets in insert mode
vim.api.nvim_create_autocmd({ 'InsertEnter', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('toggle-relativenumber', { clear = true }),
  callback = function(ev)
    vim.opt.relativenumber = ev.event == 'InsertLeave'
  end,
})
vim.opt.cursorline = true -- highlight current line
vim.opt.signcolumn = 'yes:2' -- extra columns to show line info
vim.opt.wrap = false -- wrap off
vim.opt.colorcolumn = '120' -- show columns margins
vim.cmd('lan en_US.UTF-8') -- no translation, always use english
vim.opt.whichwrap = 'b,s,<,>,[,]' -- wraps left/right moves to previous/next row
vim.opt.mouse = 'a' -- enable mouse mode (useful for resizing splits, select tabs, etc...)
vim.opt.inccommand = 'split' -- preview substitutions live, as you type

vim.opt.list = true -- show blanks
vim.opt.listchars = { space = '·', tab = '⎯⎯' } -- set symbols for blanks

-- turn tabs into 2 spaces (same as "vim: ts=2 sts=2 sw=2 et" modeline)
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- highlight when copying (aka yanking) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'highlight when copying (aka yanking) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 300 })
  end,
})

vim.keymap.set('i', 'jk', '<Esc>', { desc = 'leave INSERT mode, enter NORMAL mode' })
vim.keymap.set('i', 'kj', '<C-o>', { desc = 'leave INSERT mode, enter NORMAL mode for one command only' })
vim.keymap.set('i', '<C-Space>', '<C-n>', { desc = 'suggest completion' })
vim.keymap.set('n', '<Esc>', '<Cmd>nohlsearch<CR>', { desc = 'clear search highlights' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'leave TERMINAL mode, enter NORMAL mode' })

-- editing
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'move selection one row up' })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'move selection one row down' })
vim.keymap.set('n', 'U', '<C-r>', { desc = 'redo', noremap = true })

-- navigation
vim.keymap.set('n', '<Tab>', ':bnext<CR>', { desc = 'move to next buffer' })
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { desc = 'move to previous buffer' })
vim.keymap.set('n', '<Leader><Leader>', ':ls<CR>:b<Space>', { desc = 'show buffers and prompt to change current one' })
for _, lhs in pairs({ '<C-d>', '<PageDown>' }) do
  vim.keymap.set('n', lhs, '<C-d>zz', { desc = 'scroll page down and center current line on screen', noremap = true })
end
for _, lhs in pairs({ '<C-u>', '<PageUp>' }) do
  vim.keymap.set('n', lhs, '<C-u>zz', { desc = 'scroll page up and center current line on screen', noremap = true })
end
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'repeat search forward and center current line on screen', noremap = true })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'repeat search backward and center current line on screen', noremap = true })

-- buffers management
vim.keymap.set({ 'i', 'n', 'v' }, 'ZX', '<Cmd>:bd<CR>', { desc = 'close current buffer', noremap = true })
vim.keymap.set({ 'i', 'n', 'v' }, 'ZA', '<Cmd>:w<CR>', { desc = 'save current buffer', noremap = true })
if vim.g.neovide then
  -- 'Ctrl-S': save file (not defined in standard neovim configuration to avoid conflict with terminal)
  vim.keymap.set({ 'i', 'n', 'v' }, '<C-s>', '<Cmd>:w<CR>', { desc = 'save current buffer', noremap = true })
end

-- command aliases to fix typos...
vim.cmd('command! Qa :qa')
vim.cmd('command! Q :q')
vim.cmd('command! Wqa :wqa')
vim.cmd('command! Wq :wq')
vim.cmd('command! W :w')

-- use Shift+cursor to select
-- vim.opt.keymodel = 'startsel,stopsel'
-- vim.opt.selectmode = 'key'
