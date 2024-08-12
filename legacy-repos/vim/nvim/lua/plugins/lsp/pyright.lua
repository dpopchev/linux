local M = {}

function M.setup(lspconfig, capabilities)
    local setup = { capabilities = capabilities }
    setup['settings'] = {python = {pythonPath = vim.g.python3_host_prog}}
    lspconfig.pyright.setup(setup)
end

return M
