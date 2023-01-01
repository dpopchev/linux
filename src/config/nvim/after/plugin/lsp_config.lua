local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local lspconfig = require('lspconfig')
local whichkey = require("which-key")
local cmp = require("cmp")

local function get_cmp_conf()
    local conf = {
        mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-3),
            ['<C-f>'] = cmp.mapping.scroll_docs(3),
            ['<C-o>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        }),
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body)
            end,
        },
        sources = cmp.config.sources({
            { name = 'nvim_lsp', },
            { name = 'luasnip' },
        }, {
            { name = 'buffer' },
        }),
    }
    return conf
end

local function lsp_settings()
    local sign = function(opts)
        vim.fn.sign_define(opts.name, {
            texthl = opts.name,
            text = opts.text,
            numhl = ''
        })
    end

    sign({name = 'DiagnosticSignError', text = 'X'})
    sign({name = 'DiagnosticSignWarn', text = 'W'})
    sign({name = 'DiagnosticSignHint', text = 'H'})
    sign({name = 'DiagnosticSignInfo', text = 'I'})

    vim.diagnostic.config({
        virtual_text = true,
        signs = false,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = 'minimal',
            border = 'rounded',
            source = 'always',
            header = '',
            prefix = '',
        },
    })

    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover, { border = 'rounded', }
    )

    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help, { border = 'rounded', }
    )

    local command = vim.api.nvim_create_user_command

    command('LspWorkspaceAdd', function()
        vim.lsp.buf.add_workspace_folder()
    end, {desc = 'Add folder to workspace'})

    command('LspWorkspaceList', function()
        vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, {desc = 'List workspace folders'})

    command('LspWorkspaceRemove', function()
        vim.lsp.buf.remove_workspace_folder()
    end, {desc = 'Remove folder from workspace'})
end

local function lsp_keymaps(client, bufnr)
    local map = function(m, lhs, rhs)
        local opts = {noremap = true, silent = false, buffer = bufnr}
        vim.keymap.set(m, lhs, rhs, opts)
    end

    map("n", "K", vim.lsp.buf.hover)

    local keymap_g = {
        name = "Goto",
        d = { vim.lsp.buf.definition, "Definition" },
        D = { vim.lsp.buf.declaration, "Declaration" },
        s = { vim.lsp.buf.signature_help, "Signature Help" },
        I = { vim.lsp.buf.implementation, "Goto Implementation" },
        t = { vim.lsp.buf.type_definition, "Goto Type Definition" },
    }
    whichkey.register(keymap_g, { buffer = bufnr, prefix = "g" })

    local keymap_l = {
        l = {
            name = "Code",
            r = { vim.lsp.buf.rename, "Rename" },
            a = { vim.lsp.buf.code_action, "Code Action" },
            A = { vim.lsp.buf.range_code_action, "Range Code Action" },
            d = { vim.diagnostic.open_float, "Line Diagnostics" },
            i = { '<cmd>LspInfo<cr>', "Lsp Info" },
            q = { vim.diagnostic.setloclist, "Diagnostics Local list" },
            u = { vim.lsp.buf.references, "List symbol usage/references"},
        },
    }

    if client.server_capabilities.documentFormattingProvider then
        keymap_l.l.f = { vim.lsp.buf.formatting, "Format Document" }
    end

    whichkey.register(keymap_l, { buffer = bufnr, prefix = "<leader>" })

    map('n', 'gl', vim.diagnostic.open_float)
    map("n", "[d", vim.diagnostic.goto_prev)
    map("n", "]d", vim.diagnostic.goto_next)
    map("n", "[D", function() vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR}) end)
    map("n", "]D", function() vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR}) end)
end

local function lsp_attach(client, bufnr)
    local buf_command = vim.api.nvim_buf_create_user_command

    -- Enable completion triggered by <C-X><C-O>
    -- See `:help omnifunc` and `:help ins-completion` for more information.
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Use LSP as the handler for formatexpr.
    -- See `:help formatexpr` for more information.
    vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()")

    lsp_keymaps(client, bufnr)

    buf_command(bufnr, 'LspFormat', function()
        vim.lsp.buf.format()
    end, {desc = 'Format buffer with language server'})
end

local function get_sumneko_settings()
    local settings = {
        Lua = {
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                    vim.api.nvim_get_runtime_file("", true),
                    [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                    [vim.fn.stdpath "config" .. "/lua"] = true,
                },
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    }
    return settings
end

local function collect_server_settings()
    return {
        sumneko_lua = get_sumneko_settings(),
        jedi_language_server = {}
    }
end

local function get_servers()
    local _servers = {}
    for server, _ in pairs(collect_server_settings()) do
        table.insert(_servers, server)
    end
    return _servers
end

lsp_settings()

mason.setup({})
mason_lspconfig.setup({
    ensure_installed = get_servers()
})

local server_settings = collect_server_settings()
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("luasnip.loaders.from_vscode").lazy_load()
cmp.setup(get_cmp_conf())

mason_lspconfig.setup_handlers({
    function(server_name)
        lspconfig[server_name].setup({
            on_attach = lsp_attach,
            settings = server_settings[server_name],
            capabilities = capabilities
        })
    end
})
