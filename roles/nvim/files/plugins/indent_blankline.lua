local function config_factory()
    require('ibl').setup()
end

return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = config_factory
}
