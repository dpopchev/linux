local MASON = {
    "williamboman/mason.nvim",
}

local function set_python3_host_prog()
    local python = '.venv/bin/python'
    local is_present = os.execute('test -e ' .. python)
    if (is_present == 0) then
        vim.g.python3_host_prog = python
    else
        vim.g.python3_host_prog = 'python3'
    end
end

-- local LANGUAGE_SERVERS = {'lua_ls', 'jedi_language_server'}
local LANGUAGE_SERVERS = {'lua_ls', 'pyright'}
-- local LANGUAGE_SERVERS = {'lua_ls', 'pylsp'}

local function setup()
    require("mason").setup()
    require("mason-lspconfig").setup({ensure_installed = LANGUAGE_SERVERS})

    local lspconfig = require('lspconfig')
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    set_python3_host_prog()

    for _, server in ipairs(LANGUAGE_SERVERS) do
        require('plugins.lsp.'..server).setup(lspconfig, capabilities)
    end

    require('plugins.lsp.config').make_lspconfig()
    require('plugins.lsp.completion').make_cmpconfig()
end

local MASON_LSPCONFIG = {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { MASON,
        require('plugins.lsp.config').lazy(),
        require('plugins.lsp.completion').lazy()
    },
    -- lazy vim will run the function pointing into `config` when loading the module
    config = setup
}

return MASON_LSPCONFIG
