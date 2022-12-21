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
end)
