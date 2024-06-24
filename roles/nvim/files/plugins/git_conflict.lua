return {
    'akinsho/git-conflict.nvim',
    version = "*",
    config = {
        disable_diagnostics = true,
        highlights = { -- They must have background color, otherwise the default color will be used
            incoming = 'DiffAdd',
            current = 'DiffChange',
        },
        default_mappings = {
            next = ']x',
            prev = '[x',
        },
    }
}
