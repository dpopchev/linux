local M = {}

function M.setup()

    local builtin = require('telescope.builtin')

    vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
    vim.keymap.set('n', '<C-p>', builtin.git_files, {})
    vim.keymap.set('n', '<leader>pS', builtin.live_grep, {})

    vim.keymap.set('n', '<leader>ps', function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") });
    end)

    local telescope = require "telescope"

    local actions = require "telescope.actions"
    local mappings = {
        i = { ["<C-e>"] = actions.close, }
    }

    local conf = {
        defaults = { mappings = mappings }
    }

    telescope.setup(conf)
end

return M
