vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
    -- Packer can manage itself https://github.com/wbthomason/packer.nvim
    use 'wbthomason/packer.nvim'

    -- ojroques/nvim-hardline
    use 'ojroques/nvim-hardline'

    -- andweeb/presence.nvim
    use 'andweeb/presence.nvim'

    -- dashboard-nvim https://github.com/nvimdev/dashboard-nvim
    use {
        'nvimdev/dashboard-nvim',
        event = 'VimEnter',
        config = function()
            require('dashboard').setup {
                theme = 'hyper',
                config = {
                    header = {
                        "",
                        "",
                        "",
                        "███╗   ██╗   ██████╗  ██████╗ ██╗   ██╗██╗███╗   ███╗",
                        "████╗  ██║██╗╚════██╗██╔═══██╗██║   ██║██║████╗ ████║",
                        "██╔██╗ ██║╚═╝ █████╔╝██║   ██║██║   ██║██║██╔████╔██║",
                        "██║╚██╗██║██╗ ╚═══██╗██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
                        "██║ ╚████║╚═╝██████╔╝╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
                        "╚═╝  ╚═══╝   ╚═════╝  ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
                        "",
                        "",
                        "",
                    }
                },
            }
        end,
        requires = {'nvim-tree/nvim-web-devicons'}
    }

    -- telescope https://github.com/nvim-telescope/telescope.nvim
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- catpuccin colorscheme https://github.com/catppuccin/nvim
    use { "catppuccin/nvim", as = "catppuccin" }
    vim.cmd("colorscheme catppuccin-frappe")
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })

    -- neo-tree.nvim 
    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
            "3rd/image.nvim",
        }
    }

    -- lsp-zero https://github.com/VonHeikemen/lsp-zero.nvim
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            --- Uncomment these if you want to manage LSP servers from neovim
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- LSP Support
            {'neovim/nvim-lspconfig'},
            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'L3MON4D3/LuaSnip'},
        }
    }

    -- lazygit.nvim https://github.com/kdheepak/lazygit.nvim
    -- nvim v0.7.2
    use({
        "kdheepak/lazygit.nvim",
        -- optional for floating window border decoration
        requires = {
            "nvim-lua/plenary.nvim",
        },
    })

end)

