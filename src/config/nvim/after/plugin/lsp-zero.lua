vim.opt.signcolumn = 'yes' -- Reserve space for diagnostic icons

local lsp = require('lsp-zero')

lsp.preset('recommended')
lsp.set_preferences( {
    sign_icons = {
        error = 'X',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.ensure_installed({
  'sumneko_lua',
  'jedi_language_server'
})

lsp.nvim_workspace()

lsp.setup()
