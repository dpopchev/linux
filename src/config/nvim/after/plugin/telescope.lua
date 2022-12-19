local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>pS', builtin.live_grep, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

local actions = require('telescope.actions')
require("telescope").setup({
	defaults = {
		mappings = {
			i = { ["<C-e>"] = actions.close, }
		}
	}
})
