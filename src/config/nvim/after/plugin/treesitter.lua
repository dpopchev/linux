local treesitter = require 'nvim-treesitter.configs'

local highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
}

local incremental_selection = {
    enable = true,
    keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
    }
}

local conf = {
    ensure_installed = {'help', 'lua', 'python', 'markdown', 'vim' },
    sync_install = false,
    auto_install = false,
    highlight = highlight,
    incremental_selection = incremental_selection
}

treesitter.setup(conf)
