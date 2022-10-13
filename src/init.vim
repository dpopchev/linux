call plug#begin()
" Make sure you use single quotes
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
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting
colorscheme sonokai
let g:python3_host_prog = '/tool/pandora64/bin/python3.7'

lua	require('nvim-treesitter.configs').setup{highlight={enable=true}}
lua require('nvim-lsp-installer').setup{}
lua require('lspconfig').jedi_language_server.setup{}
