local M = {}

function M.setup()
    local treesitter = require 'nvim-treesitter.configs'
    local highlight = {
        enable = true,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    }
    local textobj_select = {
        enable = true,

        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,

        keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        },
        selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V", -- linewise
            ["@class.outer"] = "<c-v>", -- blockwise
        },
    }
    local textobj_move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
        },
        goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
        },
        goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
        },
        goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
        },
    }

    local textobj_lsp = {
        enable = true,
        border = "none",
        peek_definition_code = {
            ["<leader>pf"] = "@function.outer",
            ["<leader>pc"] = "@class.outer",
        },
    }

    local conf = {
        ensure_installed = {'help', 'lua', 'python', 'vim'},
        auto_install = false,
        highlight = highlight,
        textobjects = {
            select = textobj_select,
            move = textobj_move,
            lsp_introp = textobj_lsp
        }
    }

    treesitter.setup(conf)
end

return M
