local NEOTEST_PYTHON = {
    args = { '-ra', '--quiet' },
    runner = 'pytest',
    python = vim.g.python3_host_prog
}

local function keymap(mapping, action, desc)
    return { mapping, action, desc = desc, silent = false, noremap = true }
end

local NEOTEST_MAPPINGS = {
    keymap('<leader>nn', function() vim.cmd('lua require("neotest").run.run()') end, 'Neotest run closest test'),
    keymap('<leader>nd', function() vim.cmd('lua require("neotest").run.run({extra_args={"--pdb"}})') end,
        'Neotest run closest test with pdb'),
    keymap('<leader>nv', function() vim.cmd('lua require("neotest").run.run({extra_args={"-vvv", "--showlocals"}})') end,
        'Neotest run closest test in verbose'),
    keymap('<leader>nN', function() vim.cmd('lua require("neotest").run.run(vim.fn.expand("%"))') end,
        'Neotest run test file'),
    keymap('<leader>nc', function() vim.cmd('lua require("neotest").run.stop()') end, 'Neotest cancel running test'),
    keymap('<leader>na', function() vim.cmd('lua require("neotest").run.attach()') end, 'Neotest attach running test'),
    -- keymap('<leader>no', function() vim.cmd('lua require("neotest").output.open({enter=true, auto_close=true})') end, 'Neotest output open'),
    keymap('<leader>no', function() vim.cmd('lua require("neotest").output_panel.toggle()') end,
        'Neotest otuput panel toggle'),
    keymap('[n', function() vim.cmd('lua require("neotest").jump.prev({ status = "failed" })') end,
        'Neotest jump to prev failed test'),
    keymap(']n', function() vim.cmd('lua require("neotest").jump.next({ status = "failed" })') end,
        'Neotest jump to next failed test'),
}

local NEOTEST_SETUP = {
    icons = {
        failed = 'F',
        passed = 'P',
        running = 'R',
        skipped = 'S',
        unknown = 'U'
    },
    output = {
        enabled = true,
        enter = true,
        auto_close = true,
        open_on_run = false
    },
    quickfix = {
        enabled = false,
        open = false,
    }
}

local function make_neotest_config()
    NEOTEST_SETUP['adapters'] = { require('neotest-python')(NEOTEST_PYTHON) }
    require('neotest').setup(NEOTEST_SETUP)
end

return {
    "nvim-neotest/neotest",
    keys = NEOTEST_MAPPINGS,
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        { "nvim-neotest/neotest-python", config = function() require('neotest-python')(NEOTEST_PYTHON) end },
    },
    ft = { 'python' },
    config = make_neotest_config
}
