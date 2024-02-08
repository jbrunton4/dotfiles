local builtin = require('telescope.builtin')

-- vim.g.mapleader = " "
vim.keymap.set('n', ':ts', builtin.find_files, {}) -- telescope
vim.keymap.set('n', ':gs', builtin.git_files, {}) -- gitscope
vim.keymap.set("n", ":gh", ":Gitsigns preview_hunk<CR>", {}) -- git hunk
vim.keymap.set("n", ":gb", ":Gitsigns toggle_current_line_blame<CR>", {}) -- git blame (toggle)
vim.keymap.set('n', '<C-,>', builtin.find_files, {}) -- telescope like VS VC# 2005

-- make the telescope window transparent
vim.api.nvim_set_hl(0, "FloatBorder", {bg="#000000", fg="#ffffff" })
vim.api.nvim_set_hl(0, "NormalFloat", {bg="#000000", fg="#ffffff" })
vim.api.nvim_set_hl(0, "TelescopeNormal", {bg="#3c3c3c", fg="#ffffff" })
vim.api.nvim_set_hl(0, "TelescopeBorder", {bg="#3c3c3c", fg="#ffffff" })

