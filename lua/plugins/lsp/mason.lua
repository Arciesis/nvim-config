local options = {
    ensure_installed = {
        "lua-language-server",
    },

    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        },
    },
    max_concurrent_installers = 6
}

return options
