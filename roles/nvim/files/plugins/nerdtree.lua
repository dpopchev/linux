local function vim_options_factory(desc)
    return { noremap = true, silent = false, desc = desc }
end

local function config_factory()
    vim.keymap.set('n', '<leader>eT', ':NERDTreeFind<CR>',
        vim_options_factory('[E]xplore active buffer path with Nerd[T]ree '))
    vim.keymap.set('n', '<leader>et', ':NERDTreeToggle<CR>', vim_options_factory('[E]xplore using Nerd[t]ree pane'))
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
