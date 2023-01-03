local neotest = require("neotest")
local npytest = require("neotest-python")

local function get_npytest_conf()
    local runner = 'pytest'
    local args = {'-ra', '--quiet'}
    local python = vim.g.python3_host_prog
    return {
        args = args,
        runner = runner,
        python = python
    }
end

local npytest_conf = get_npytest_conf()
local npytest_adapter = npytest(npytest_conf)
local adapters = { npytest_adapter }
local icons = {
    failed = 'F',
    passed = 'P',
    running = 'R',
    skipped = 'S',
    unknown = 'U'
}

neotest.setup( {
    adapters = adapters,
    icons = icons
})

local map = function(m, lhs, rhs)
    local opts = {noremap = true, silent = false}
    vim.keymap.set(m, lhs, rhs, opts)
end

map('n', '<leader>nn', '<cmd> lua require("neotest").run.run()<cr>')
map('n', '<leader>nd', '<cmd> lua require("neotest").run.run({extra_args={"--pdb"}})<cr>')
map('n', '<leader>nN', '<cmd> lua require("neotest").run.run(vim.fn.expand("%"))<cr>')
map('n', '<leader>nc', '<cmd> lua require("neotest").run.stop()<cr>')
map('n', '<leader>na', '<cmd> lua require("neotest").run.attach()<cr>')
map('n', '<leader>ns', '<cmd> lua require("neotest").output.open({enter=false})<cr>')
map('n', '<leader>nS', '<cmd> lua require("neotest").output_panel.toggle()<cr>')
map('n', ']n', '<cmd>lua require("neotest").jump.next({ status = "failed" })<CR>')
map('n', '[n', '<cmd>lua require("neotest").jump.prev({ status = "failed" })<CR>')
