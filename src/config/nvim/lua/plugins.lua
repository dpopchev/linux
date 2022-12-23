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
end)

--
--    use {
--        "neovim/nvim-lspconfig",
--        opt = true,
--        event = "BufRead",
--        wants = { "nvim-lsp-installer" },
--        config = function()
--            require("config.lsp").setup()
--        end,
--        requires = {
--            "williamboman/nvim-lsp-installer",
--        },
--    }
