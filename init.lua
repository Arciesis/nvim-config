vim.pack.add({
    { src = 'https://github.com/tanvirtin/monokai.nvim',              name = 'monokai' },
    { src = 'https://github.com/neovim/nvim-lspconfig',               name = 'lspconfig' },
    { src = 'https://github.com/mason-org/mason.nvim',                name = 'mason',       version = 'v2.2.1' },
    { src = 'https://github.com/lukas-reineke/indent-blankline.nvim', name = 'blankline' },
    { src = 'https://github.com/folke/todo-comments.nvim',            name = 'todos' },
    { src = 'https://github.com://kdheepak/lazygit.nvim',             name = 'lazygit' },
    { src = 'https://github.com/nvim-lualine/lualine.nvim',           name = 'lualine' },
    { src = 'https://github.com/lewis6991/gitsigns.nvim',             name = 'gitsigns' },
    { src = 'https://github.com/nvim-lua/plenary.nvim',               name = 'plenary' },
    { src = 'https://github.com/nvim-tree/nvim-web-devicons',         name = 'web-devicons' },
    { src = 'https://github.com/nvim-telescope/telescope.nvim',       name = 'telescope',   version = 'f7c673b8e46e8f233ff581d3624a517d33a7e264' },
    { src = 'https://github.com/saghen/blink.cmp',                    name = 'blink',       version = 'v1.10.2' },
    { src = 'https://github.com/kylechui/nvim-surround' },
    { src = 'https://github.com/j-hui/fidget.nvim' },
    { src = 'https://github.com/folke/flash.nvim',                    name = 'flash',       version = 'v2.1.0' },
    { src = 'https://github.com/folke/which-key.nvim',                name = 'wk',          version = 'v3.17.0' },
})


local options = require('lua.options')
local km = require('lua.keymaps')

local truc = os.clock()

local todos = require('todo-comments').setup({})
local monokai = require('monokai').setup(require('monokai').soda)
local lspconfig = require('lspconfig')
local mason = require('mason').setup()

--@TODO: map C-jk to down,up not C-pn
local telescope = require('telescope').setup({
    defaults = {
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
            },
        },
    },
})


local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}
local hooks = require('ibl.hooks')
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

vim.g.rainbow_delimiters = { highlight = highlight }
hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

local blankline = require('ibl').setup({
    indent = { highlight = highlight }
})
local lualine = require('lualine').setup({
    options = {
        theme = "horizon",
    },
    sections = {
        lualine_c = {
            -- project_root,
            { "filename", file_status = true, newfile_status = true, path = 1 },
        },
    },
})

vim.lsp.config['lua_ls'] = {
    cmd = { 'lua-language-server' },
    -- Filetypes to automatically attach to.
    filetypes = { 'lua' },
    -- Sets the "workspace" to the directory where any of these files is found.
    -- Files that share a root directory will reuse the LSP server connection.
    -- Nested lists indicate equal priority, see |vim.lsp.Config|.
    root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
    -- Specific settings to send to the server. The schema is server-defined.
    -- Example: https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            }
        }
    }
}

require('blink.cmp').setup({
    completion = {
        ghost_text = { enabled = true },
        list = {
            selection = {
                preselect = true,
                auto_insert = false,
            },
        },
    },
    keymap = {
        preset = 'none',
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },

        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

        ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },
})

require('flash').toggle()
require('flash').setup({
    modes = {
        char = {
            jump_labels = true,
        },
    },
})

vim.lsp.enable('lua_ls')
vim.lsp.enable('rust-analyzer')
vim.lsp.enable('zls')
vim.lsp.enable('clangd')
