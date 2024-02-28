local utils = require("../..utils")

local root_files = {
    ".luarc.json",
    ".stylua.toml",
    "sele.toml",
    "selene.yml",
}

return {
    config = {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_dir = function(fname)
            local root = utils.root_pattern(unpack(root_files))(fname)
            if root and root ~= vim.env.HOME then
                return root
            end
            root = utils.root_pattern 'lua/'(fname)
            if root then
                return root
            end
            return utils.find_git_ancestor(fname)
        end,
        single_file_support = true,
        log_level = vim.lsp.protocol.MessageType.Warning,
        default_config = {
            root_dir = [[root_pattern(".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git")]],
        },
    },
}
