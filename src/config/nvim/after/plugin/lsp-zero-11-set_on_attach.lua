local lsp = require('lsp-zero')
local whichkey = require "which-key"

local function on_attach(client, bufnr)
    -- Enable completion triggered by <C-X><C-O>
    -- See `:help omnifunc` and `:help ins-completion` for more information.
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Use LSP as the handler for formatexpr.
    -- See `:help formatexpr` for more information.
    vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()")

    local opts = { noremap = true, silent = false, buffer = bufnr }
    local keymap = vim.keymap.set

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    keymap("n", "K", vim.lsp.buf.hover, opts)
    keymap("n", "[d", vim.diagnostic.goto_prev, opts)
    keymap("n", "]d", vim.diagnostic.goto_next, opts)
    keymap("n", "[e", function() vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR}) end, opts)
    keymap("n", "]e", function() vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR}) end, opts)

    local keymap_l = {
        l = {
            name = "Code",
            r = { vim.lsp.buf.rename, "Rename" },
            a = { vim.lsp.buf.code_action, "Code Action" },
            d = { vim.diagnostic.open_float, "Line Diagnostics" },
            i = { '<cmd>LspInfo<cr>', "Lsp Info" },
            q = { vim.diagnostic.setloclist, "Diagnostics Local list" },
            u = { vim.lsp.buf.references, "List symbol usage/references"},
        },
    }

    if client.server_capabilities.documentFormattingProvider then
        keymap_l.l.f = { vim.lsp.buf.formatting, "Format Document" }
    end

    local keymap_g = {
        name = "Goto",
        d = { vim.lsp.buf.definition, "Definition" },
        D = { vim.lsp.buf.declaration, "Declaration" },
        s = { vim.lsp.buf.signature_help, "Signature Help" },
        I = { vim.lsp.buf.implementation, "Goto Implementation" },
        t = { vim.lsp.buf.type_definition, "Goto Type Definition" },
    }
    whichkey.register(keymap_l, { buffer = bufnr, prefix = "<leader>" })
    whichkey.register(keymap_g, { buffer = bufnr, prefix = "g" })
end

lsp.set_preferences({set_lsp_keymaps = false})

lsp.on_attach(on_attach)
