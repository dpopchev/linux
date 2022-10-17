call plug#begin()
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
Plug 'kien/ctrlp.vim'
Plug 'jasoncodes/ctrlp-modified.vim'
Plug 'Yggdroot/indentLine'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-repeat'
Plug 'mtth/scratch.vim'
Plug 'tpope/vim-sensible'
Plug 'sainnhe/sonokai'
Plug 'tpope/vim-surround'
Plug 'itchyny/vim-gitbranch'
Plug 'airblade/vim-gitgutter'
Plug 'azabiong/vim-highlighter'
Plug 'sheerun/vim-polyglot'
Plug 'jpalardy/vim-slime'
Plug 'justinmk/vim-sneak'
Plug 'lifepillar/vim-solarized8'
Plug 'nelstrom/vim-visual-star-search'
Plug 'folke/which-key.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-spell'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'haringsrob/nvim_context_vt'
call plug#end()

source $HOME/.vimrc

lua << EOF
require('which-key').setup{}
require('nvim-treesitter.configs').setup{
    ensure_installed = { "lua", "vim", "python", "perl", "markdown" },
    auto_install = true,
    highlight={
        enable=true,
        additional_vim_regex_highlighting = false,
        },
    incremental_selection = {enable=false},
    indent = {enable=false},
}

-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
    vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
  end,
},
window = {
  -- completion = cmp.config.window.bordered(),
  -- documentation = cmp.config.window.bordered(),
},
mapping = cmp.mapping.preset.insert({
  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping.abort(),
  ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
}),
sources = cmp.config.sources({
  { name = 'nvim_lsp' },
  { name = 'vsnip' }, -- For vsnip users.
  -- { name = 'luasnip' }, -- For luasnip users.
  -- { name = 'ultisnips' }, -- For ultisnips users.
  -- { name = 'snippy' }, -- For snippy users.
}, {
  { name = 'buffer' },
})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
sources = cmp.config.sources({
  { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
}, {
  { name = 'buffer' },
})
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
mapping = cmp.mapping.preset.cmdline(),
sources = {
  { name = 'buffer' }
}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
mapping = cmp.mapping.preset.cmdline(),
sources = cmp.config.sources({
  { name = 'path' }
}, {
  { name = 'cmdline' }
})
})

require('nvim-lsp-installer').setup{}
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '<leader>[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', '<leader>]d', vim.diagnostic.goto_next, opts)
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', '<leader>ls', vim.lsp.buf.document_symbol, opts)
  vim.keymap.set('n', '<leader>lD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', '<leader>ld', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', '<leader>lk', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<leader>lI', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<leader>lh', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>lc', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<leader>lu', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>lwa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>lwr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>lwl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>lf', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}
require('lspconfig')['jedi_language_server'].setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
    root_dir = require("lspconfig/util").root_pattern(".git"),
    init_options = {
            workspace = {
                extraPaths = {'./lib'}
            }
        }
}
EOF
