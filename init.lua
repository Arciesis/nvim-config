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

-- see https://neovim.io/doc/user/options.html
-- global options
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- all options (not all actually but the more important imo)
vim.opt.backup = false
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 1
vim.opt.foldmethod = "manual"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.hidden = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.mouse = "nv"
vim.opt.pumheight = 5
vim.opt.showmode = false
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.timeoutlen = 250
vim.opt.undofile = true
vim.opt.updatetime = 100
vim.opt.writebackup = false
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.signcolumn = "yes"
vim.opt.wrap = true
vim.opt.textwidth = 80
vim.opt.linebreak = true;
vim.opt.scrolloff = 5
vim.opt.showcmd = true
vim.opt.ruler = true
vim.opt.laststatus = 3
vim.opt.autoindent = true
vim.opt.syntax = "off"
vim.opt.termguicolors = true

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

-- Telescope mappings
vim.keymap.set("n", "<leader><leader>", [[<CMD>Telescope find_files<CR>]])
vim.keymap.set("n", "<leader>fb", [[<CMD>Telescope buffers<CR>]])
vim.keymap.set("n", "<leader>fe", [[<CMD>Telescope live_grep<CR>]])
vim.keymap.set("n", "<leader>fh", [[<CMD>Telescope help_tags<CR>]])
vim.keymap.set("n", "<leader>fq", [[<CMD>Telescope quickfix<CR>]])
vim.keymap.set("n", "<leader>fd", [[<CMD>Telescope diagnostics<CR>]])
vim.keymap.set("n", "<leader>ft", [[<CMD>Telescope todo<CR>]])

-- window keymaps
vim.keymap.set("n", "<C-h>", [[<Cmd>wincmd h<CR>]])
vim.keymap.set("n", "<A-j>", [[<Cmd>wincmd j<CR>]])
vim.keymap.set("n", "<A-k>", [[<Cmd>wincmd k<CR>]])
vim.keymap.set("n", "<C-l>", [[<Cmd>wincmd l<CR>]])

-- lazyygit
vim.keymap.set("n", "<leader>g", [[<CMD>LazyGit<CR>]])

-- creation on an autocmd to set the keymaps related to a lsp with wichkey
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
   group = vim.api.nvim_create_augroup('UserLspConfig', {}),
   callback = function(ev)
      -- Enable completion triggered by <c-x><c-o>
      vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

      -- Buffer local mappings.
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      local opts = { buffer = ev.buf }
      --  set_lsp_buffer_keymaps(opts)
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = opts.buffer, desc = "Go to declaration" })
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = opts.buffer, desc = "Go to definition" })
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = opts.buffer, desc = "Doc hover" })
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = opts.buffer, desc = "Go to implementation" })
      -- vim.keymap.set('n', '<c-k>', vim.lsp.buf.signature_help, { buffer = opts.buffer, desc = "Signature hover" })
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = opts.buffer, desc = "Rename" })
      vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { buffer = opts.buffer, desc = "Code action" })
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = opts.buffer, desc = "Go to references" })
      vim.keymap.set('n', '<leader>cf', function()
         vim.lsp.buf.format { async = true }
      end, { buffer = opts.buffer, desc = "Format" })
   end,
})
