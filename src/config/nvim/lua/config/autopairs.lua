local M = {}

function M.setup()
    local npairs = require "nvim-autopairs"
    npairs.setup {
        check_ts = true,
    }
end

return M
