local ensure_installed = {
    'bash',
    'json',
    'make',
    'python',
    'vim', 'vimdoc',
    'lua', 'luadoc',
    'diff',
    'yaml',
    'diff',
    'markdown', 'markdown_inline',
}

local highlight ={
    enable = true,
    -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
    --  If you are experiencing weird indenting issues, add the language to
    --  the list of additional_vim_regex_highlighting and disabled languages for indent.
    -- additional_vim_regex_highlighting = { 'ruby' },
}

local indent ={
    enable = true,
    -- disable = { 'ruby' }
}

local incremental_selection ={
    enable = true,
    keymaps = {
        init_selection = "gnn",
        node_incremental = "gn]",
        node_decremental = "gn[",
        scope_incremental = false,
    },
}

local opts = {
    ensure_installed = ensure_installed,
    auto_install = true,
    highlight = highlight ,
    indent = indent,
    sync_install = false,
    incremental_selection = incremental_selection,
}

local function config_factory(_, opts)
    -- Prefer git instead of curl in order to improve connectivity in some environments
    require('nvim-treesitter.install').prefer_git = true
    require('nvim-treesitter.configs').setup(opts)
end

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = opts,
    config = config_factory,
}

-- {'nvim-treesitter/nvim-treesitter-context', }
