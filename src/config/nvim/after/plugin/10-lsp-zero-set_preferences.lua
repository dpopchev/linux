local lsp = require('lsp-zero')

-- plugins setups for neovim configuration lua development
lsp.nvim_workspace()

lsp.set_preferences( {
    sign_icons = {
        error = 'X',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})
