local keys = {
    {
        '<leader>f',
        function()
            require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
    },
}

local function get_under_venv(command)
    local venv_path = vim.g.python3_host_prog:gsub("[^/\\]*$", "")
    return venv_path .. command
end

local opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        return {
            timeout_ms = 500,
            lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
    end,
    formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'autopep8', 'isort', },
        bash = { 'shfmt' },
        sh = { 'shfmt' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        -- javascript = { { "prettierd", "prettier" } },
    },
    formatters = {
        autopep8 = { command = get_under_venv('autopep8') },
        isort = { command = get_under_venv('isort') }
    }
}

-- Autoformat
return {
    'stevearc/conform.nvim',
    lazy = false,
    keys = keys,
    opts = opts,
}
