local function setup()
    local builtin = require('telescope.builtin')

    vim.keymap.set('n', '<leader>eh', builtin.help_tags, {desc = '[E]xplore [H]elp'})
    vim.keymap.set('n', '<leader>ek', builtin.keymaps, { desc = '[E]xplore [K]eymaps' })
    vim.keymap.set('n', '<leader>ef', builtin.find_files, {desc = '[E]xplore [F]iles'})
    vim.keymap.set('n', '<leader>es', builtin.builtin, { desc = '[E]xplore [S]elect Telescope' })
    vim.keymap.set('n', '<leader>ew', builtin.grep_string, { desc = '[E]xplore current [W]ord' })
    vim.keymap.set('n', '<leader>eg', builtin.live_grep, { desc = '[E]xplore by [G]rep' })
    vim.keymap.set('n', '<leader>ed', builtin.diagnostics, { desc = '[E]xplore [D]iagnostics' })
    vim.keymap.set('n', '<leader>er', builtin.resume, { desc = '[E]xplore [R]esume' })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
        })
    end, { desc = '[/] Fuzzily search in current buffer' })

    vim.keymap.set('n', '<leader>ep', builtin.git_files, { desc = '[E]xplore git files'})
    vim.keymap.set('n', '<leader>eg', function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") });
    end, { desc = '[E]xplore [G]rep string'})

    local actions = require "telescope.actions"
    local mappings = { i = { ["<leader>eq"] = actions.close, } }
    local conf = { defaults = { mappings = mappings } }

    require('telescope').setup(conf)
end


return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    lazy = false,
    config = setup,
}
