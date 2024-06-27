require("config.lazy")

vim.cmd.colorscheme("catppuccin-mocha")

-- Indentation 
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Wrapping
vim.opt.wrap = true
vim.opt.smartindent = true

-- Scrolloff
vim.scrolloff = 8

-- Use relative line numbers
vim.cmd.set "nu rnu"
vim.cmd.set "autochdir"

vim.g.have_nerd_font = true
vim.opt.showmode = false

vim.opt.list = true
vim.opt.listchars = { tab = "   ", trail = "·", nbsp = "␣" }

vim.opt.cursorline = true

-- easier binds to close highlights and terminal
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Keymaps
-- move selected lines in visual mode by shift+dir
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
