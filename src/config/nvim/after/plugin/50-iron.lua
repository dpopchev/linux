local iron = require("iron.core")
local view = require("iron.view")

iron.setup {
    config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,
        -- Your repl definitions come here
        repl_definition = {
            sh = {
                -- Can be a table or a function that
                -- returns a table (see below)
                command = {"zsh"}
            },
            python = {
                command = {vim.g.python3_host_prog, '-m', 'IPython', '--colors', 'Linux', }
            }
        },
        -- How the repl window will be displayed
        -- See below for more information
        repl_open_cmd = view.split.vertical("50%"),
    },
    -- Iron doesn't set keymaps by default anymore.
    -- You can set them here or manually add keymaps to the functions in iron.core
    keymaps = {
        send_motion = "<leader>re",
        visual_send = "<leader>re",
        send_file = "<leader>rE",
        send_line = "<leader>rl",
        send_mark = "<leader>rme",
        mark_motion = "<leader>rmm",
        mark_visual = "<leader>rmm",
        remove_mark = "<leader>rmd",
        cr = "<leader>r<cr>",
        interrupt = "<leader>rs",
        exit = "<leader>rq",
        clear = "<leader>rc",
    },
    -- If the highlight is on, you can change how it looks
    -- For the available options, check nvim_set_hl
    highlight = {
        italic = true
    },
    ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
}

-- iron also has a list of commands, see :h iron-commands for all available commands
vim.keymap.set('n', '<leader>rr', '<cmd>IronRepl<cr>')
vim.keymap.set('n', '<leader>rR', '<cmd>IronRestart<cr>')
vim.keymap.set('n', '<leader>rf', '<cmd>IronFocus<cr>')
vim.keymap.set('n', '<leader>rh', '<cmd>IronHide<cr>')