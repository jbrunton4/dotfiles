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


-- Keymaps
-- move selected lines in visual mode by shift+dir
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")


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
    { "andweeb/presence.nvim" }
}

-- Package setup
require('gitsigns').setup()
require("presence").setup()
