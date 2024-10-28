-- lazy.nvim plugin manager (https://github.com/folke/lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = "\\" -- Same for `maplocalleader`
require("lazy").setup({
  "nvim-lua/plenary.nvim",
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "python", "javascript", "json", "markdown", "markdown_inline" },
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
        ensure_installed = { "stylua", "prettier" },
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
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
    end,
  },
})

vim.opt.clipboard = "unnamedplus" -- use system clipboard for copy ("yank") / paste
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

vim.keymap.set("i", "jk", "<esc>") -- exit insert mode, enter normal mode
vim.keymap.set("v", "K", ":m '>+1<cr>gv=gv") -- move selection one row up in visual mode
vim.keymap.set("v", "J", ":m '<-2<cr>gv=gv") -- move selection one row down in visual mode

-- "Shift-Tab": unindent
vim.api.nvim_set_keymap("i", "<S-Tab>", "<esc><<i", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-Tab>", "<<", { noremap = true, silent = true })

-- "Ctrl-S": save file
vim.api.nvim_set_keymap("i", "<C-s>", "<cmd>:w<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-s>", "<cmd>:w<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-s>", "<cmd>:w<cr>", { noremap = true, silent = true })

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
