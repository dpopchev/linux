require('git-conflict').setup({
    disable_diagnostics = true,
    highlights = {
        current = 'DiffChange',
        incoming = 'DiffAdd',
    }
})
