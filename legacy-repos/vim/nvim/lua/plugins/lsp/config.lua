local M = {}

local GLOBAL_MAPPINGS = {
    {"<leader>lp", vim.diagnostic.open_float, desc='Line Diagnostics'},
    {"[d", vim.diagnostic.goto_prev, desc="Goto previous LSP diagnostic message"},
    {"[D", function() vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR}) end, desc='Goto previous LSP error'},
    {"]d", vim.diagnostic.goto_next, desc="Goto next LSP diagnostic message"},
    {"]D", function() vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR}) end, desc='Goto next LSP error'},
    {"<leader>lq", vim.diagnostic.setloclist, desc='Diagnostic local list'},
}

local function make_setmap(mode, bufnr)
    return function (map, action, desc)
        local opts = {buffer = bufnr, desc = desc, silent = false, noremap=true}
        vim.keymap.set(mode, map, vim.lsp.buf[action], opts)
    end
end

local function make_buffer_mappings(event)
    vim.bo[event.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    vim.bo[event.buf].formatexpr = 'v:lua.vim.lsp.formatexpr'
    local setmap = make_setmap('n', event.buf)
    setmap('gD', 'declaration', 'LSP jump declaration')
    setmap('gd', 'definition', 'LSP jump definition')
    setmap('<leader>ld', 'type_definition', 'LSP jump type definition')
    setmap('K', 'hover', 'LSP hover')
    setmap('<leader>K', 'signature_help', 'LSP signature help')
    setmap('<leader>lD', 'implementation', 'LSP jump implementation')
    setmap('<leader>lwa', 'add_workspace_folder', 'LSP add folder to workspace')
    setmap('<leader>lwd', 'remove_workspace_folder', 'LSP remove folder to workspace')
    vim.keymap.set('n', '<leader>lwl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, {buffer = event.buf, desc = 'LSP list workspace folders', silent = false, noremap=true})
    setmap('<leader>lr', 'rename', 'LSP rename')
    vim.keymap.set({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action,{buffer = event.buf, desc = 'LSP code action ', silent = false, noremap=true})
    vim.keymap.set({ 'n', 'v' }, '<leader>lA', function() vim.lsp.buf.code_action({apply=true}) end,{buffer = event.buf, desc = 'LSP code action apply', silent = false, noremap=true})
    setmap('<leader>lu', 'references', 'LSP symbol usage/references')
    vim.keymap.set({ 'n', 'v' }, '<leader>lf', function()
        vim.lsp.buf.format { async = true }
    end, { buffer = event.buf, desc = 'LSP format', silent = false, noremap = true })
end

local VIM_DIAGNOSTIC_CONFIG = {
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
}

local function setup_diagnostic_sign(name, text, numhl)
    numhl = numhl or ''
    vim.fn.sign_define(name, {
        texthl = name,
        text = text,
        numhl = numhl
    })
end

local DIAGNOSTIC_SINGS = {
    DiagnosticSignError= 'X',
    DiagnosticSignWarn= 'W',
    DiagnosticSignHint= 'H',
    DiagnosticSignInfo= 'I',
}

local function set_diagnostic_sings()
    for name, text in pairs(DIAGNOSTIC_SINGS) do
        setup_diagnostic_sign(name, text)
    end
end

local LSP_ATTACH_AU = {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = make_buffer_mappings
}

function M.make_lspconfig()
    vim.lsp.set_log_level('warn')
    set_diagnostic_sings()
    vim.diagnostic.config(VIM_DIAGNOSTIC_CONFIG)
    vim.api.nvim_create_autocmd('LspAttach', LSP_ATTACH_AU)
end

function M.lazy()
    return {
        "neovim/nvim-lspconfig",
        keys = GLOBAL_MAPPINGS,
    }
end

return M
