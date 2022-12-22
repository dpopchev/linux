local M = {}

function M.setup()
    local hardline = require "hardline"
    local conf = {
        bufferline = true,
        bufferline_settings = {
            show_index = false
        }
    }

    hardline.setup(conf)
end

return M
