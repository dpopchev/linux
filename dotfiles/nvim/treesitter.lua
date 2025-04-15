local ensure_installed = {
    "bash",
    "json",
    "make",
    "python",
    "vim",
    "vimdoc",
    "lua",
    "luadoc",
    "diff",
    "yaml",
    "diff",
    "markdown",
    "markdown_inline",
}

local highlight = {
    enable = true,
    -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
    --  If you are experiencing weird indenting issues, add the language to
    --  the list of additional_vim_regex_highlighting and disabled languages for indent.
    additional_vim_regex_highlighting = { "ruby" },
}

local indent = {
    enable = true,
    disable = { "ruby" },
}

local incremental_selection = {
    enable = true,
    keymaps = {
        init_selection = "gnn",
        node_incremental = "gn]",
        node_decremental = "gn[",
        scope_incremental = false,
    },
}

return { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs", -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
        ensure_installed = ensure_installed,
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = highlight,
        indent = indent,
        incremental_selection = incremental_selection,
    },
    dependencies = { "nvim-treesitter/nvim-treesitter-context" },
}
