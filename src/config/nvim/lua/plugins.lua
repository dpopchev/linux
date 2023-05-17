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
        'haringsrob/nvim_context_vt',
        'nvim-treesitter/nvim-treesitter-context',
        -- 'nvim-treesitter/nvim-treesitter-textobjects',
        requires = {
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
        },
    }

    use 'tpope/vim-fugitive'

    use { 'akinsho/git-conflict.nvim', tag="*" }

    use 'mbbill/undotree'

    use 'azabiong/vim-highlighter'

    use {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    }

    use {
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
        "rafamadriz/friendly-snippets",
        "lukas-reineke/cmp-under-comparator"
    }

    use {
        "nvim-neotest/neotest",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-python"
        }
    }

    use "wellle/targets.vim"

    use 'lewis6991/gitsigns.nvim'

    -- use 'mtth/scratch.vim'

    -- use 'Konfekt/vim-wsl-copy-paste'

    use 'nelstrom/vim-visual-star-search'

    use 'AndrewRadev/linediff.vim'

    -- use {'hkupty/iron.nvim'}

    use {'aklt/plantuml-syntax'}

end)
