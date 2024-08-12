local function setup()
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ee', builtin.builtin, {})
    vim.keymap.set('n', '<leader>ef', builtin.find_files, {})
    vim.keymap.set('n', '<leader>ep', builtin.git_files, {})
    vim.keymap.set('n', '<leader>et', builtin.help_tags, {})
    vim.keymap.set('n', '<leader>eG', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>eg', function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") });
    end)
    local actions = require "telescope.actions"
    local mappings = { i = { ["<leader>eq"] = actions.close, } }
    local conf = { defaults = { mappings = mappings } }

    require('telescope').setup(conf)
end


return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    lazy = false,
    config = setup,
}
