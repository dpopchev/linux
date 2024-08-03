local function vim_options_factory(desc)
    return { noremap = true, silent = false, desc = desc }
end

local function config_factory()
    vim.keymap.set('n', '<leader>et', ':NERDTree<CR>', vim_options_factory('[E]xplore toggled Nerd[t]ree pane'))
    vim.keymap.set('n', '<leader>eT', ':NERDTreeFind<CR>',
        vim_options_factory('[E]xplore buffer path using Nerd[T]ree'))
end

return {
    'preservim/nerdtree',
    dependencies = {
        'Xuyuanp/nerdtree-git-plugin',
        'tiagofumo/vim-nerdtree-syntax-highlight',
        'PhilRunninger/nerdtree-buffer-ops',
        'PhilRunninger/nerdtree-visual-selection',
    },
    config = config_factory
}
