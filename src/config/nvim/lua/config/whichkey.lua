local M = {}

function M.setup()
    local whichkey = require "which-key"
    local conf = {}
    local opts = {}
    local mappings = {}

    whichkey.setup(conf)
    whichkey.register(mappings, opts)
end

return M
