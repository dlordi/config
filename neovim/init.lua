vim.opt.clipboard = "unnamedplus" -- use system clipboard for copy ("yank") / paste
vim.opt.number = true -- show line numbers
vim.opt.relativenumber = true -- show line number offsets
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
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 300,
    })
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
  vim.o.guifont = "JetBrainsMono Nerd Font:h10"

  -- enable Windows system clipboard
  vim.api.nvim_set_keymap("i", "<C-v>", "<C-R>+", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("!", "<S-Insert>", "<C-R>+", { noremap = true, silent = true })
end
