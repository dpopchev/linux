local M = {}

local SETTINGS = {
    Lua = {
        diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { 'vim' },
        },
        workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
            enable = false,
        },
    },
}

function M.setup(lspconfig, capabilities)
    lspconfig.lua_ls.setup({capabilities=capabilities, settings = SETTINGS})
end

return M
