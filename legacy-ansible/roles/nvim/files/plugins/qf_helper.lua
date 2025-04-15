local function setup()
    -- use <C-N> and <C-P> for next/prev.
    vim.keymap.set("n", "gmn", "<CMD>QNext<CR>", { desc = "Next quickfix/loclist item" })
    vim.keymap.set("n", "gmp", "<CMD>QPrev<CR>", { desc = "Prev quickfix/loclist item" })
    -- toggle the quickfix open/closed without jumping to it
    vim.keymap.set("n", "gmo", "<CMD>QFToggle!<CR>", { desc = "Toggle quickfix" })
    vim.keymap.set("n", "gmO", "<CMD>Cclear<CR>", { desc = "Clear quickfix entries" })
    vim.keymap.set("n", "gml", "<CMD>LLToggle<CR>", { desc = "Toggle loclist" })
    vim.keymap.set("n", "gmL", "<CMD>Lclear<CR>", { desc = "Clear loclist entries" })
    vim.keymap.set("n", "gmd", "<CMD>Reject<CR>", { desc = "Reject items, remove rest" })
    vim.keymap.set("n", "gmD", "<CMD>Keep<CR>", { desc = "Keep items, remove rest" })

    require('qf_helper').setup()
end

return {
    'stevearc/qf_helper.nvim',
    lazy = false,
    config = setup
}
