local function set_python3_host_prog()
    local python = '.venv/bin/python'
    local is_present = os.execute('test -e ' .. python)
    if (is_present == 0) then
        vim.g.python3_host_prog = python
    else
        vim.g.python3_host_prog = 'python3'
    end
end

set_python3_host_prog()

vim.cmd('source ~/.vimrc')

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

require("plugins_setup")
