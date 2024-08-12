local M = {}

local CMPSOURCES = {
    { name = 'nvim_lsp',               keyword_length = 3 },
    { name = 'nvim_lsp_signature_help' },
    { name = 'buffer',                 keyword_length = 2 },
    { name = 'path' },
    { name = 'nvim_lua',               keyword_length = 2 },
}

local function select_icon(entry, item)
    local menu_icon = {
        nvim_lsp = 'LSP',
        buffer = 'BUF',
        path = 'PTH'
    }
    item.menu = menu_icon[entry.source.name]
    return item
end

function M.make_cmpconfig()
    -- vim.opt.completeopt = {'longest', 'menuone'}
    -- vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

    -- completeopt is used to manage code suggestions
    -- menuone: show popup even when there is only one suggestion
    -- noinsert: Only insert text when selection is confirmed
    -- noselect: force us to select one from the suggestions
    vim.opt.completeopt = {'menuone', 'noselect', 'noinsert', 'preview'}
    -- shortmess is used to avoid excessive messages
    vim.opt.shortmess = vim.opt.shortmess + { c = true}

    local cmp = require('cmp')
    local select_behavior = { behavior = cmp.SelectBehavior.Replace, select = true }
    local confirm_behavior = { behavior = cmp.ConfirmBehavior.Replace, select = true }

    local mapping = {
        -- scroll up and down in the completion documentation
        ['<C-f>'] = cmp.mapping.scroll_docs(5),
        ['<C-u>'] = cmp.mapping.scroll_docs(-5),
        -- toggle completion
        ['<C-e>'] = cmp.mapping.close(),
        -- confirm selection
        ['<C-y>'] = cmp.mapping.confirm(confirm_behavior),
        ['<C-o>'] = cmp.mapping.complete(),
        -- navigate items on the list
        ['<C-p>'] = cmp.mapping.select_prev_item(select_behavior),
        ['<C-n>'] = cmp.mapping.select_next_item(select_behavior),
    }

    local window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered()
    }

    local formatting = {
        fields = { 'menu', 'abbr', 'kind' },
        format = select_icon,
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

    cmp.setup({
        snippet = { expand = function() end },
        sources = CMPSOURCES,
        mapping = mapping,
        window = window,
        formatting = formatting,
        sorting = sorting,
        matching = { disallow_fuzzy_matching = false }
    })
end

function M.lazy()
    return {
        {
            "hrsh7th/nvim-cmp",
        },
        {
            "hrsh7th/cmp-nvim-lsp",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp-signature-help",
                "hrsh7th/cmp-nvim-lua",
                'hrsh7th/cmp-path',
                'hrsh7th/cmp-buffer',
                'lukas-reineke/cmp-under-comparator'
            },
        },
    }
end

return M
