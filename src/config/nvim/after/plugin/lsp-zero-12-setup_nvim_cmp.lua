local lsp = require('lsp-zero')
local cmp = require('cmp')

local function get_mappings()
    local mappings = lsp.defaults.cmp_mappings({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
    })

    mappings['<Tab>'] = nil
    mappings['<S-Tab>'] = nil

    return mappings
end

local function get_sources()
    local sources = {
        {name = 'buffer', keyword_length = 3}, -- cmp-buffer, data from buffers
        {name = 'nvim_lsp', keyword_length = 3}, -- cmp-nvim-lsp, data send by LSP
        {name = 'path'}, -- cmp-path, based on filesystem
        {name= 'spell'}, -- cmp-spell, spell suggestions
        {name = 'luasnip', keyword_length = 2}, -- cmp_luasnip, snippet suggestions
    }
    return sources
end

local mappings = get_mappings()
local sources = get_sources()

lsp.setup_nvim_cmp({
    mapping = mappings,
    sources = sources
})
