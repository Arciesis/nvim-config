return {
    "nvim-treesitter/nvim-treesitter",
    opts = {
        ensure_installed = {
            "c",
            "lua",
            "vim",
            "vimcode",
            "query",
        },
        sync_install = true,
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
    },
}
