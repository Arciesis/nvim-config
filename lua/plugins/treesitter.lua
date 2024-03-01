return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
        ensure_installed = {
            "c",
            "cpp",
            "lua",
            "vim",
            "vimcode",
            "query",
            "rust",
            "arduino",
            "cmake",
            "comment",
        },
        sync_install = true,
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
    },
}
