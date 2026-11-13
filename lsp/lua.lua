local root_markers1 = {
    '.emmyrc.json',
    '.luarc.json',
    '.luarc.jsonc',
}

return {
    cmd = { 'true' },
    root_markers = root_markers1,
    settings = {
        Lua = {
            runtime = {
                -- Doriax likely uses LuaJIT or standard Lua 5.1/5.3; adjust if necessary
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Tell the LSP not to complain about Doriax's injected global variables
                globals = {
                    'vim',
                --     'Engine',
                --     'Input',
                --     'Vector3',
                --     'Vector2',
                --     'Object',
                --     'RegisterEngineEvent'
                },
            },
            workspace = {
                -- Tell lua_ls where to find the Doriax Engine Lua definitions
                library = {
                    vim.env.VIMRUNTIME,
                    vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
                },
                -- Stop lua_ls from prompting you to configure an exact environment
                checkThirdParty = false,
            },
        },
    },
}
