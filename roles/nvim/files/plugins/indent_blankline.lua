local function config_factory()
    require('ibl').setup({
        scope = {
            show_start = false,
            show_end = false
        }
    })
end

return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = config_factory
}
