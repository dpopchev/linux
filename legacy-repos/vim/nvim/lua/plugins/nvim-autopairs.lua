return {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {
        check_ts = true,
        enable_afterquote = true,
        enable_bracket_in_quote = false,
        map_c_h = true,
        map_c_w = true
    } -- this is equalent to setup({}) function
}
