local function vim_options_factory(desc)
    return { noremap = true, silent = false, desc = desc }
end

local function config_factory()
    vim.keymap.set('n', '<leader>enN', ':NERDTree<CR>', vim_options_factory('[E]xplore using [nN]erdtree pane'))
    vim.keymap.set('n', '<leader>enn', ':NERDTreeToggle<CR>', vim_options_factory('[E]xplore [nn]erdtree toggle'))
    vim.keymap.set('n', '<leader>enf', ':NERDTreeToggle<CR>', vim_options_factory('[E]xplore [n]erdtree [f]ind'))
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
