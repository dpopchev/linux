local M = {}

function M.setup()
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
