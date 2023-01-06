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
local output = {
    enabled = true,
    enter = true,
    auto_close = true,
    open_on_run = false
}

local quickfix = {
    enabled = false,
    open = false
}

neotest.setup( {
    adapters = adapters,
    icons = icons,
    output = output,
    quickfix = quickfix
})

local map = function(m, lhs, rhs)
    local opts = {noremap = true, silent = false}
    vim.keymap.set(m, lhs, rhs, opts)
end

map('n', '<leader>nn', function() vim.cmd('lua require("neotest").run.run()') end)
map('n', '<leader>nd', function() vim.cmd('lua require("neotest").run.run({extra_args={"--pdb"}})') end)
map('n', '<leader>nv', function() vim.cmd('lua require("neotest").run.run({extra_args={"-vvv", "--showlocals"}})') end)
map('n', '<leader>nN', function() vim.cmd('lua require("neotest").run.run(vim.fn.expand("%"))') end)
map('n', '<leader>nc', function() vim.cmd('lua require("neotest").run.stop()') end)
map('n', '<leader>na', function() vim.cmd('lua require("neotest").run.attach()') end)
map('n', '<leader>no', function() vim.cmd('lua require("neotest").output.open({enter=true, auto_close=true})') end)
map('n', '<leader>nO', function() vim.cmd('lua require("neotest").output_panel.toggle()') end)
map('n', '[n', function() vim.cmd('lua require("neotest").jump.prev({ status = "failed" })') end)
map('n', ']n', function() vim.cmd('lua require("neotest").jump.next({ status = "failed" })') end)
