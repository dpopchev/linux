local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local lspconfig = require('lspconfig')
local whichkey = require("which-key")
local cmp = require("cmp")
local luasnip = require('luasnip')

local function get_cmp_conf()
    local select_opts = {behavior = cmp.SelectBehavior.Replace, }

    -- see https://github.com/VonHeikemen/lsp-zero.nvim/wiki/Under-the-hood
    local mapping = cmp.mapping.preset.insert({
        -- scroll up and down in the completion documentation
        ['<C-f>'] = cmp.mapping.scroll_docs(5),
        ['<C-u>'] = cmp.mapping.scroll_docs(-5),
        -- go to next placeholder in the snippet
        ['<C-d>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, {'i', 's'}),
        -- go to previous placeholder in the snippet
        ['<C-b>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, {'i', 's'}),
        -- toggle completion
        ['<C-e>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.close()
                fallback()
            else
                cmp.complete()
            end
        end),
        -- confirm selection
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-o>'] = cmp.mapping.complete(),
        -- navigate items on the list
        ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
        ['<C-n>'] = cmp.mapping.select_next_item(select_opts),
    })

    -- local completeopt = {'longest', 'menuone'}
    local completeopt = {'menu', 'menuone', 'noselect'}
    vim.opt.completeopt = completeopt
    local completion = {completeopt = table.concat(completeopt, ',')}

    local snippet ={
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    }

    local sources = cmp.config.sources({
        { name = 'nvim_lsp', },
        { name = 'luasnip' },
        { name = 'buffer' },
    })

    local window = {
        documentation = vim.tbl_deep_extend( 'force',
        cmp.config.window.bordered(),
        { max_height = 15, max_width = 60, }
        )
    }

    local formatting = {
        fields = {'abbr', 'menu', 'kind'},
        format = function(entry, item)
            local short_name = {
                nvim_lsp = 'LSP',
                nvim_lua = 'nvim'
            }

            local menu_name = short_name[entry.source.name] or entry.source.name

            item.menu = string.format('[%s]', menu_name)
            return item
        end,
    }

    local sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            require "cmp-under-comparator".under,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    }

    local matching = { disallow_fuzzy_matching = false }

    local conf = {
        mapping = mapping,
        completion = completion,
        snippet = snippet,
        sources = sources,
        window = window,
        formatting = formatting,
        sorting = sorting,
        matching = matching
    }

    return conf
end

local function set_lsp_settings()
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
    map("n", "<leader>K", vim.lsp.buf.signature_help)

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
            a = { function() vim.lsp.buf.code_action({apply=true}) end, "Code Action" },
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
    map("v", '<leader>la', function() vim.lsp.buf.code_action() end)
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
    vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")

    lsp_keymaps(client, bufnr)

    buf_command(bufnr, 'LspFormat', function()
        vim.lsp.buf.format()
    end, {desc = 'Format buffer with language server'})
end

local function get_common_server_settings()

    luasnip.config.set_config({
        region_check_events = 'InsertEnter',
        delete_check_events = 'InsertLeave'
    })

    require('luasnip.loaders.from_vscode').lazy_load()

    local cmp_conf = get_cmp_conf()
    cmp.setup(cmp_conf)

    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    return {
        on_attach = lsp_attach,
        capabilities = capabilities,
        root_dir = require("lspconfig/util").root_pattern(".git")
    }
end

local function get_sumneko_settings()
    local common = get_common_server_settings()
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
                },
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    }
    common['settings'] = settings
    return common
end

local function get_jedi_language_server_settings()
    local common = get_common_server_settings()
    common['init_options'] = { workspace = { environmentPath = vim.g.python3_host_prog } }
    return common
end

local function collect_server_settings()
    return {
        lua_ls = get_sumneko_settings(),
        jedi_language_server = get_jedi_language_server_settings()
    }
end

local function get_servers()
    local servers = {}
    local server_settings = collect_server_settings()
    for server, _ in pairs(server_settings) do
        table.insert(servers, server)
    end
    return servers
end

set_lsp_settings()

mason.setup({})
mason_lspconfig.setup({
    ensure_installed = get_servers()
})

local server_settings = collect_server_settings()

mason_lspconfig.setup_handlers({
    function(server_name)
        lspconfig[server_name].setup(server_settings[server_name])
    end
})
