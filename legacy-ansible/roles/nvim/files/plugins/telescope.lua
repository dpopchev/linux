local function setup()
    local builtin = require('telescope.builtin')

    vim.keymap.set('n', '<leader>eh', builtin.help_tags, { desc = '[E]xplore [H]elp', noremap = true, silent = false })
    vim.keymap.set('n', '<leader>ek', builtin.keymaps, { desc = '[E]xplore [K]eymaps', noremap = true, silent = false })
    vim.keymap.set('n', '<leader>ef', builtin.find_files, { desc = '[E]xplore [F]iles', noremap = true, silent = false })
    vim.keymap.set('n', '<leader>es', builtin.builtin,
        { desc = '[E]xplore [S]elect Telescope', noremap = true, silent = false })
    vim.keymap.set('n', '<leader>ew', builtin.grep_string,
        { desc = '[E]xplore current [W]ord', noremap = true, silent = false })
    vim.keymap.set('n', '<leader>eg', builtin.live_grep, { desc = '[E]xplore by [G]rep', noremap = true, silent = false })
    vim.keymap.set('n', '<leader>ed', builtin.diagnostics,
        { desc = '[E]xplore [D]iagnostics', noremap = true, silent = false })
    vim.keymap.set('n', '<leader>er', builtin.resume, { desc = '[E]xplore [R]esume', noremap = true, silent = false })

    vim.keymap.set('n', '<leader>eW', function()
        builtin.grep_string({ word_match = "-w" })
    end, { desc = '[E]xplore current exact [W]ord', noremap = true, silent = false })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
        })
    end, { desc = '[/] Fuzzily search in current buffer', noremap = true, silent = false })

    vim.keymap.set('n', '<leader>ep', builtin.git_files, { desc = '[E]xplore git files', noremap = true, silent = false })

    local actions = require "telescope.actions"
    local mappings = { i = { ["<esc>"] = actions.close, } }
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
