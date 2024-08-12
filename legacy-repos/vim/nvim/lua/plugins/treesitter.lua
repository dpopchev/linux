local TREESITTER_CONFIGS = {
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = {
        'bash', 'c', 'json', 'lua', 'make',
        'perl', 'python', 'vimdoc',
        'diff', 'markdown', 'markdown_inline', 'yaml'
    },
    auto_install = false,
    sync_install = false,
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "gn]",
            node_decremental = "gn[",
            scope_incremental = false,
        },
    },
}

local function make_treesitter_config()
    require('nvim-treesitter.configs').setup(TREESITTER_CONFIGS)
end

local TREESITTER = {
    "nvim-treesitter/nvim-treesitter",
    config = make_treesitter_config
}

return {
    {'nvim-treesitter/nvim-treesitter-context', dependencies = {TREESITTER} },
}
