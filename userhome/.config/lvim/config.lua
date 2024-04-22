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

-- Flash highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Keymaps
-- move selected lines in visual mode by shift+dir
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- alt-arrow for moving windows 
vim.keymap.set("n", "<M-Left>", ":wincmd h<CR>")
vim.keymap.set("n", "<M-Down>", ":wincmd j<CR>")
vim.keymap.set("n", "<M-Up>", ":wincmd k<CR>")
vim.keymap.set("n", "<M-Right>", ":wincmd l<CR>")
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Default behaviour fixes
-- paste over doesn't overwrite paste buffer
vim.keymap.set("x", "<leader>p", "\"_dp")
-- in half-page jump, cursor remains stationary
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")


-- Lazy 
lvim.plugins = {
    {
        "catppuccin/nvim",
        config = function()
            vim.cmd("colorscheme catppuccin-frappe")
        end
    },
    { "lewis6991/gitsigns.nvim" },
    { "andweeb/presence.nvim" },
    { "tpope/vim-fugitive" },
    { 
        "christoomey/vim-tmux-navigator",
        vim.keymap.set("n", "<M-Left>", ":TmuxNavigateLeft<CR>"),
        vim.keymap.set("n", "<M-Down>", ":TmuxNavigateDown<CR>"),
        vim.keymap.set("n", "<M-Up>", ":TmuxNavigateUp<CR>"),
        vim.keymap.set("n", "<M-Right>", ":TmuxNavigateRight<CR>")
    }
}

-- Package setup
require('gitsigns').setup()
require("presence").setup()
