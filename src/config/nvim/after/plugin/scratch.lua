vim.g.scratch_autohide = "&hidden"
vim.g.scratch_insert_autohide = 0
vim.g.scratch_filetype = 'markdown'
vim.g.scratch_horizontal = 0
vim.g.scratch_top = 0
vim.g.scratch_height = 60
vim.g.scratch_persistence_file = '.scratch.vim'

vim.g.scratch_no_mappings = 1
vim.cmd [[ nnoremap <leader>gss :ScratchPreview<cr> ]]
vim.cmd [[ nmap <leader>gsi <plug>(scratch-insert-reuse) ]]
vim.cmd [[ nmap <leader>gsC <plug>(scratch-insert-clear) ]]
vim.cmd [[ xmap <leader>gsi <plug>(scratch-selection-reuse) ]]
vim.cmd [[ xmap <leader>gsI <plug>(scratch-selection-clear) ]]
