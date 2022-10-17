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
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'williamboman/nvim-lsp-installer'
Plug 'neovim/nvim-lspconfig'
Plug 'haringsrob/nvim_context_vt'
call plug#end()

source $HOME/.vimrc

lua << EOF
require('which-key').setup{}
require('nvim-treesitter.configs').setup{
    highlight={
        enable=true,
        additional_vim_regex_highlighting = true
        },
    indent = {enable=true},
    incremental_selection = {enable = true}
}
require('nvim-lsp-installer').setup{}
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>ge', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', '<leader>ga', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', '<leader>gK', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<leader>gk', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>gwa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>gwr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>gwl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<leader>gt', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>gr', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>gc', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<leader>gu', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>gf', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}
require('lspconfig')['jedi_language_server'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}
EOF
