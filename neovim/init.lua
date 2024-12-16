-- lazy.nvim plugin manager (https://lazy.folke.io/installation)
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
  {
    "Mofiqul/vscode.nvim",
    priority = 1000,
    config = function()
      require("vscode").setup({
        color_overrides = {
          vscBack = "#000000",
        },
      })
      vim.cmd.colorscheme("vscode")
    end,
  },
  "nvim-lua/plenary.nvim",
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "python",
          "javascript",
          "json",
          "markdown",
          "markdown_inline",
          -- "go",
          -- "c",
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua",
          "prettier",
          -- "gopls",
          -- "goimports",
          -- "clangd",
          -- "clang-format",
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          -- python = { "ruff_fix", "ruff_format" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          json = { "prettier" },
          markdown = { "prettier" },
          svelte = { "prettier" },
          css = { "prettier" },
          html = { "prettier" },
          yaml = { "prettier" },
          -- go = { "goimports" },
          -- c = { "clang-format" },
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
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      -- vim.keymap.set("n", "<Leader>ff", function()
      --   builtin.find_files({ cwd = require("telescope.utils").buffer_dir() })
      -- end, { desc = "Telescope [F]ind [F]iles in current buffer directory" })
      vim.keymap.set("n", "<Leader>fb", builtin.buffers, { desc = "Telescope [F]ind [B]uffers" })
      vim.keymap.set("n", "<Leader>fk", builtin.keymaps, { desc = "Telescope [F]ind [K]eymaps" })
      -- vim.keymap.set("n", "<Leader>fr", builtin.lsp_references, { desc = "Telescope [F]ind [R]eferences" })
      -- vim.keymap.set("n", "<Leader>sg", builtin.live_grep, { desc = "Telescope [S]earch by [G]rep" })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    opts = {
      icons = {
        mappings = vim.g.have_nerd_font, -- uses icon if nerd font is available
        keys = vim.g.have_nerd_font and {} or { -- if nerd font is not available, list special keys string representation
          Up = "<Up> ",
          Down = "<Down> ",
          Left = "<Left> ",
          Right = "<Right> ",
          C = "<C-…> ",
          M = "<M-…> ",
          D = "<D-…> ",
          S = "<S-…> ",
          CR = "<CR> ",
          Esc = "<Esc> ",
          ScrollWheelDown = "<ScrollWheelDown> ",
          ScrollWheelUp = "<ScrollWheelUp> ",
          NL = "<NL> ",
          BS = "<BS> ",
          Space = "<Space> ",
          Tab = "<Tab> ",
          F1 = "<F1>",
          F2 = "<F2>",
          F3 = "<F3>",
          F4 = "<F4>",
          F5 = "<F5>",
          F6 = "<F6>",
          F7 = "<F7>",
          F8 = "<F8>",
          F9 = "<F9>",
          F10 = "<F10>",
          F11 = "<F11>",
          F12 = "<F12>",
        },
      },
    },
  },
})

vim.schedule(function() -- this setting is applied after `UiEnter` event because it can increase startup-time
  vim.opt.clipboard = "unnamedplus" -- use system clipboard for copy ("yank") / paste
end)
vim.opt.number = true -- show line numbers
vim.opt.relativenumber = true -- show line number offsets
-- do not show line number offsets in insert mode
vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("togglerelativenumber", { clear = true }),
  callback = function(ev)
    vim.opt.relativenumber = ev.event == "InsertLeave"
  end,
})
vim.opt.cursorline = true -- highlight current line
vim.opt.signcolumn = "yes:2" -- extra columns to show line info
vim.opt.wrap = false -- wrap off
vim.opt.colorcolumn = "120" -- show columns margins
vim.cmd("lan en_US.UTF-8") -- no translation, always use english
vim.opt.whichwrap = "b,s,<,>,[,]" -- wraps left/right moves to previous/next row
vim.opt.mouse = "a" -- enable mouse mode (useful for resizing splits, select tabs, etc...)
vim.opt.inccommand = "split" -- preview substitutions live, as you type
vim.opt.timeoutlen = 300 -- displays which-key popup sooner

vim.opt.listchars = { space = "·", tab = "⎯⎯" } -- set symbols for blanks
vim.opt.list = true -- show blanks

-- turn tabs into 2 spaces
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- highlight copied ("yank") text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
  end,
})

vim.keymap.set("i", "jk", "<Esc>", { desc = "'jk' leave INSERT mode, enter NORMAL mode" })
vim.keymap.set("v", "K", ":m '>+1<CR>gv=gv", { desc = "move selection one row up in visual mode" })
vim.keymap.set("v", "J", ":m '<-2<CR>gv=gv", { desc = "move selection one row down in visual mode" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "clear search highlights" })

-- use Shift+cursor to select
-- vim.opt.keymodel = "startsel,stopsel"

-- 'Shift-Tab': unindent
vim.api.nvim_set_keymap("i", "<S-Tab>", "<Esc><<i", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-Tab>", "<<", { noremap = true, silent = true })

-- 'Ctrl-S': save file (WARNING: this might conflict with terminal Ctrl-S)
vim.api.nvim_set_keymap("i", "<C-s>", "<cmd>:w<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-s>", "<cmd>:w<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-s>", "<cmd>:w<CR>", { noremap = true, silent = true })

-- ':Q' aliases ':q' to fix typos...
vim.cmd("command! Qa :qa")
vim.cmd("command! Q :q")

if vim.g.neovide then
  -- local font_name = "SauceCodePro Nerd Font" -- tested both on Windows and MacOS
  local font_name = "JetBrainsMonoNL Nerd Font"
  local font_size = vim.loop.os_uname().sysname == "Windows_NT" and "10" or "14"
  vim.o.guifont = font_name .. ":h" .. font_size

  -- enable MacOS "Command" key
  vim.g.neovide_input_use_logo = 1

  -- enable MacOS system clipboard
  vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })

  -- enable Windows system clipboard
  vim.api.nvim_set_keymap("i", "<C-v>", "<C-R>+", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("!", "<S-Insert>", "<C-R>+", { noremap = true, silent = true })
end
