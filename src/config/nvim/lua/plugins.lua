-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use 'sainnhe/sonokai'

    use 'ojroques/nvim-hardline'

    use 'unblevable/quick-scope'

    use "windwp/nvim-autopairs"

    use { "kylechui/nvim-surround", tag = "*", }

    use 'chaoren/vim-wordmotion'

    use "folke/which-key.nvim"

    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} },
    }

    use 'numToStr/Comment.nvim'

    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    }

    use 'tpope/vim-fugitive'

    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},
            {'f3fora/cmp-spell'},
            {'lukas-reineke/cmp-under-comparator'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    }

    use 'mbbill/undotree'

    use 'azabiong/vim-highlighter'

end)
