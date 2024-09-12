local function opts(desc)
    return {
        desc = "nvim-tree: " .. desc,
        noremap = true,
        silent = false,
    }
end

local function config_factory()
    local function on_attach(bufnr)
        local api = require "nvim-tree.api"
        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- custom mappings
        -- vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
    end

    -- disable netrw at the very start of your init.lua
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    local conf = { on_attach = on_attach }

    local api = require "nvim-tree.api"
    vim.keymap.set('n', '<leader>eo', function() api.tree.find_file({ open = true, focus = true }) end,
        opts('[t]oggle'))
    vim.keymap.set('n', '<leader>et', function() api.tree.toggle({ find_file = false, focus = true }) end,
        opts('[t]oggle'))
    vim.keymap.set('n', '<leader>ec', function() api.tree.collapse_all(true) end,
        opts('[C]ollapse recursively tree keeping open buffers'))
    vim.keymap.set('n', '<leader>eC', function() api.tree.collapse_all(false) end,
        opts('[C]ollapse all recursively'))

    require('nvim-tree').setup(conf)
end


return {
    'nvim-tree/nvim-tree.lua',
    version = "*",
    lazy = false,
    config = config_factory,
}
