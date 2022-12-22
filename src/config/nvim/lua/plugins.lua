-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        "sainnhe/sonokai",
        config = function()
            vim.g.sonokai_style = 'maia'
            vim.g.sonokai_better_performance = 1
            vim.cmd "colorscheme sonokai"
        end,
    }

    use {
        "folke/which-key.nvim",
        config = function()
            require('config.whichkey').setup()
        end
    }

    use {
        'ojroques/nvim-hardline',
        config = function()
            require('config.hardline').setup()
        end
    }

    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} },
        config = function()
            require('config.telescope').setup()
        end
    }

    use { 'chaoren/vim-wordmotion' }

    use {
        "nvim-treesitter/nvim-treesitter",
        opt = true,
        event = 'BufReadPre',
        run = ":TSUpdate",
        config = function()
            require("config.treesitter").setup()
        end,
    }

    use {
        'unblevable/quick-scope',
        config = function()
            require("config.quick_scope").setup()
        end
    }

    use {
        "windwp/nvim-autopairs",
        config = function()
            require("config.autopairs").setup()
        end,
    }

    use {
        "neovim/nvim-lspconfig",
        opt = true,
        event = "BufRead",
        wants = { "nvim-lsp-installer" },
        config = function()
            require("config.lsp").setup()
        end,
        requires = {
            "williamboman/nvim-lsp-installer",
        },
    }
end)
