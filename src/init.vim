call plug#begin()
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
Plug 'kien/ctrlp.vim'
Plug 'jasoncodes/ctrlp-modified.vim'
Plug 'Yggdroot/indentLine'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'itchyny/lightline.vim'
Plug 'kylechui/nvim-surround'
Plug 'mtth/scratch.vim'
Plug 'tpope/vim-sensible'
Plug 'sainnhe/sonokai'
Plug 'tpope/vim-surround'
Plug 'itchyny/vim-gitbranch'
Plug 'airblade/vim-gitgutter'
Plug 'azabiong/vim-highlighter'
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
Plug 'hrsh7th/nvim-cmp'
Plug 'lukas-reineke/cmp-under-comparator'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'haringsrob/nvim_context_vt'
Plug 'f3fora/cmp-spell'
Plug 'nvim-lua/plenary.nvim'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'nvim-neotest/neotest'
Plug 'nvim-neotest/neotest-python'
Plug 'lewis6991/spellsitter.nvim'
Plug 'rhysd/conflict-marker.vim'
Plug 'Konfekt/vim-wsl-copy-paste'
Plug 'kana/vim-textobj-user'
Plug 'beloglazov/vim-textobj-quotes'
Plug 'ray-x/lsp_signature.nvim'
call plug#end()

source $HOME/.vimrc
autocmd! TermOpen * setlocal nospell nonumber norelativenumber
" dangling akward workaround
" set spell!
" set spell!

" Default values
" let g:conflict_marker_begin = '^<<<<<<< \@='
" let g:conflict_marker_common_ancestors = '^||||||| .*$'
" let g:conflict_marker_separator = '^=======$'
" let g:conflict_marker_end   = '^>>>>>>> \@='
" let g:conflict_marker_enable_highlight = 0
" let g:conflict_marker_highlight_group = 'Error'
" [/]x to jump around
" let g:conflict_marker_enable_mappings = 0
" to keep use:
" - ct: theirs
" - co: ours
" - cn: none
" - cb: both

nnoremap <leader>nv <cmd>lua require("neotest").run.run({extra_args={'-vvv', '--showlocals'}})<cr>
nnoremap <leader>nd <cmd>lua require("neotest").run.run({extra_args={'--pdb'}})<cr>
nnoremap <leader>nD <cmd>lua require("neotest").run.stop()<cr>
nnoremap <leader>na <cmd>lua require("neotest").run.attach()<cr>
nnoremap <leader>no <cmd>lua require("neotest").output.open({ enter = true })<CR>
nnoremap <leader>nn <cmd>lua require("neotest").run.run()<cr>
nnoremap <leader>nN <cmd>lua require("neotest").run.run(vim.fn.expand("%"))<cr>
nnoremap [n <cmd>lua require("neotest").jump.prev({ status = "failed" })<CR>
nnoremap ]n <cmd>lua require("neotest").jump.next({ status = "failed" })<CR>

let g:loaded_python3_provider = 1
if !empty(expand(glob('.venv/bin/python')))
    let g:python3_host_prog = fnamemodify(expand('%:p:h'), ':p') .. '.venv/bin/python'
else
    let g:python3_host_prog = 'python3'
endif

lua << EOF
require('which-key').setup({})
require('nvim-treesitter.configs').setup{
    ensure_installed = { "python" },
    auto_install = false,
    highlight={
        enable=true,
        additional_vim_regex_highlighting = false,
        },
    incremental_selection = {enable=false},
    indent = {enable=false},
}

-- Set up nvim-cmp.
local cmp = require 'cmp'
cmp.setup({
    snippet = {
        expand = function(args)
        -- For `vsnip`, uncomment the following.
        -- vim.fn["vsnip#anonymous"](args.body)
        -- For `luasnip`, uncomment the following.
        -- require('luasnip').lsp_expand(args.body)
        -- For snippy, uncomment the following.
        -- require('snippy').expand_snippet(args.body)
        -- For `ultisnips`
        -- vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
  formatting = {
      format = function(entry, vim_item)
          -- Kind icons
          vim_item.kind = string.format("%s", vim_item.kind) --Concatonate the icons with name of the item-kind
          vim_item.menu = ({
          nvim_lsp = "[LSP]",
          spell = "[Spellings]",
          buffer = "[Buffer]",
--          ultisnips = "[Snip]",
          treesitter = "[Treesitter]",
--          calc = "[Calculator]",
--          nvim_lua = "[Lua]",
--          path = "[Path]",
          nvim_lsp_signature_help = "[Signature]",
          cmdline = "[Vim Command]"
          })[entry.source.name]
          return vim_item
      end,
      },
  mapping = {
    ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
    ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
    ['<C-M-k>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-M-j>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
--    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  },
  completion = {
      keyword_length = 3,
  },
  matching = {
      disallow_fuzzy_matching = false,
  },
  sources = cmp.config.sources(
  {
      { name = 'nvim_lsp' },
      -- For ultisnips users
      -- { name = 'ultisnips' },
      -- For vsnip users, uncomment the following.
      -- { name = 'vsnip' },
      -- For luasnip users, uncomment the following.
      -- { name = 'luasnip' },
      -- For snippy users, uncomment the following.
      -- { name = 'snippy' },
  },
  {
      { name = 'buffer' },
  },
  {
      { name = 'nvim_lsp_signature_help' },
  },
  {
      { name = 'path' },
  },
  {
      { name = 'spell' },
  }),
    sorting = {
            comparators = {
                cmp.config.compare.order,
                cmp.config.compare.offset,
                cmp.config.compare.exact,
                cmp.config.compare.score,
                require "cmp-under-comparator".under,
                cmp.config.compare.kind,
                cmp.config.compare.sort_text,
                cmp.config.compare.length,
            },
        },
})

cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
    { name = 'path'  },
    { name = 'cmdline'  },
    })
})

cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer'  },
    }
})

require('nvim-lsp-installer').setup({})
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '<leader>l[', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', '<leader>l]', vim.diagnostic.goto_next, opts)
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
require('lspconfig')['jedi_language_server'].setup({
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
    root_dir = require("lspconfig/util").root_pattern(".git"),
    init_options = {
            workspace = {
                extraPaths = {},
                environmentPath = vim.g.python3_host_prog
            }
        }
})

require('lspconfig')['marksman'].setup({})

require("neotest").setup({
icons = {
    failed = "F",
    passed = "P",
    running = "R",
    skipped = "S",
    unknown = "U"
    },
adapters = {
    require("neotest-python")({
        runner = "pytest",
        python = vim.g.python3_host_prog,
        args = {'-q', '-rfE'}
    })
    }
})

local group = vim.api.nvim_create_augroup("NeotestConfig", {})
vim.api.nvim_create_autocmd("FileType", {
pattern = "neotest-output,neotest-attach",
group = group,
callback = function(opts)
  vim.keymap.set("n", "q", function()
    pcall(vim.api.nvim_win_close, 0, true)
  end, {
    buffer = opts.buf,
  })
end,
})


require('nvim_context_vt').setup({
  min_rows = 1,
  disable_virtual_lines=true,
})

-- local envs = {}
-- envs['PYTHONPATH'] = '$PYTHONPATH:./lib:./src:./tests'
-- local neotest_run_test = function()
--     require("neotest").run.run()
-- end
require('spellsitter').setup({})
require("nvim-surround").setup({})
require('lsp_signature').setup({hint_prefix='[ARG]', padding='', toggle_key='<C-k>'})
EOF
