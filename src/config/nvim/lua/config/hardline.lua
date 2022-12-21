local M = {}

function M.setup()
    local hardline = require "hardline"
    local conf = {
        bufferline = true,
        bufferline_settings = {
            show_index = true
        }
    }

    hardline.setup(conf)
end

return M
