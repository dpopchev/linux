local M = {}

function M.setup(lspconfig, capabilities)
    lspconfig.jedi_language_server.setup({
        capabilities=capabilities,
        init_options = { workspace = { environmentPath = vim.g.python3_host_prog } }
    })
end

return M
