local M = {}

function M.setup()
    vim.g.qs_max_chars = 100
    vim.g.qs_buftype_blacklist = ['terminal', 'nofile']
end

return M
