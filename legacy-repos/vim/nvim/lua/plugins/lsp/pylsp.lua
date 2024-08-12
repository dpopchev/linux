local M = {}

function M.setup(lspconfig, capabilities)
    lspconfig.pylsp.setup({
        capabilities = capabilities,
        settings = {
            pylsp = {
                plugins = {
                    -- formatter options
                    black = { enabled = true },
                    autopep8 = { enabled = false },
                    yapf = { enabled = false },
                    -- linter options
                    pylint = { enabled = true, executable = "pylint" },
                    ruff = { enabled = false },
                    pyflakes = { enabled = false },
                    pycodestyle = { enabled = false },
                    -- type checker
                    pylsp_mypy = {
                        enabled = true,
                        overrides = { "--python-executable", py_path, true },
                        report_progress = true,
                        live_mode = false
                    },
                    -- auto-completion options
                    jedi_completion = { fuzzy = true },
                    -- import sorting
                    isort = { enabled = true },
                },
            },
        },
        flags = {
            debounce_text_changes = 200,
        },
    })

end

return M
