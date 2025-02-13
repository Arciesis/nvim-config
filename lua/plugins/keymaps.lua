local keymaps = {
   "folke/which-key.nvim",
   dependencies = {
      { "ThePrimeagen/harpoon",         branch = "harpoon2" },
      { "nvim-telescope/telescope.nvim" },
   },
   event = "VeryLazy",
   opts = function()
      local wk = require("which-key")
      return wk.add({
         { "<leader>",         group = "Most used" },
         { "<leader><leader>", "<cmd>Telescope find_files<CR>",           desc = "Find File",          mode = "n" },

         { "<leader>f",        group = "File" },
         { "<leader>fb",       "<cmd>Telescope buffers<CR>",              desc = "TBuffers" },
         { "<leader>fg",       "<cmd>Telescope git_files<cr>",            desc = "TGit Files" },
         { "<leader>fr",       "<cmd>Telescope oldfiles<CR>",             desc = "Recent" },
         { "<leader>fe",       "<cmd>Telescope live_grep<CR>",            desc = "Find egrep" },

         { "<leader>g",        "<cmd>LazyGit<CR>",                        desc = "LayziGit" },

         { "<leader>l",        group = "LSP" },
         { "<leader>lq",       "<cmd>Telescope quickfixhistory<CR>",      desc = "QuickFix History" },
         { "<leader>ll",       "<cmd>Telescope lsp_document_symbols<CR>", desc = "Lint current Buffer" },
         {
            "<leader>ld",
            function()
               vim.diagnosstic.open_float({})
            end,
            desc = "Line's Diagnostics"
         },

         { "<leader>v",  group = "Löve" },
         { "<leader>vr", "<cmd>LoveRun<CR>",      desc = "Run Löve" },
         { "<leader>vs", "<cmd>LoveStop<CR>",     desc = "Stop Löve" },

         { "<leader>d",  group = "Document" },
         { "<leader>dt", "<cmd>TodoTrouble<CR>",  desc = "Todos" },
         {
            "<leader>dd",
            function()
               require("trouble").toggle("document_diagnostic")
            end,
            desc = "Diagnostics"
         },
         {
            "<leader>dq",
            function()
               require("trouble").toggle("quickfix")
            end,
            desc = "QuickFix"
         },
         {"<leader>dv", "<cmd>DocsViewToggle<CR>", desc = "View Docs" },

         {
            "<leader>a",
            function()
               require("harpoon"):list():add()
            end,
            desc = "Add Harpoon"
         }
      })
   end
}



-- name = "Debugger",
-- a = { function() require("osv").run_this({ port = 8086 }) end, "Lua Debugger" },
-- b = { function() require("dap").toggle_breakpoint() end, "Breakpoint toggle" },
-- c = { function() require("dap").continue() end, "Continue exec/Launch" },
-- i = { function() require("dap").step_into() end, "Step into" },
-- o = { function() require("dap").step_over() end, "Step over" },
-- k = { function() require("dap").step_out() end, "Step out" },
-- t = { function() require("dapui").toggle() end, "Toggle UI" },
-- r = { function() require("dap").repl_open() end, "Repl Open" },
-- l = { function() require("dap").run_last() end, "Run last" },
-- h = { function() require("dap.ui.widgets").hover() end, "Hover" },
-- p = { function() require("dap.ui.widgets").preview() end, "Preview" },
-- u = {
--    function()
--       _G.dapRunConfigWithArgs()
--    end,
--    "Run args",
-- },
-- f = {
--    function()
--       local widgets = require("dap.ui.widgets")
--       widgets.centerer_float(widgets.frames)
--    end,
--    "Floating frame",
-- },
--
-- s = {
--    function()
--       local widgets = require("dap.ui.widgets")
--       widgets.centered_float(widgets.scopes)
--    end,
--    "Floating scope"
-- },
-- q = { function() require("dapui").toggle() end, "Quit" },

-- Trouble related


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
      vim.keymap.set('n', '<c-k>', vim.lsp.buf.signature_help, { buffer = opts.buffer, desc = "Signature hover" })
      vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder,
         { buffer = opts.buffer, desc = "Add workspace" })
      vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder,
         { buffer = opts.buffer, desc = "Remove workspace" })
      vim.keymap.set('n', '<leader>wl', function()
         print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, { buffer = opts.buffer, desc = "List workspaces" })
      vim.keymap.set('n', '<leader>k', vim.lsp.buf.type_definition, { buffer = opts.buffer, desc = "Type definition" })
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = opts.buffer, desc = "Rename" })
      vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { buffer = opts.buffer, desc = "Code action" })
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = opts.buffer, desc = "Go to references" })
      vim.keymap.set('n', '<leader>cf', function()
         vim.lsp.buf.format { async = true }
      end, { buffer = opts.buffer, desc = "Format" })
   end,
})

-- Harpoon related
-- ["<c-e>"] = { function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, "Toggle harpoon", noremap = true },
-- ["<c-p>"] = { function() require("harpoon"):list():prev() end, "Previous harpoon" },
-- ["<c-n>"] = { function() require("harpoon"):list():next() end, "Next harpoon" },
-- ["<c-d>"] = { function() require("harpoon"):list():clear() end, "Delete harpoon" },

-- window keymaps
vim.keymap.set("n", "<C-h>", [[<Cmd>wincmd h<CR>]])
vim.keymap.set("n", "<C-j>", [[<Cmd>wincmd j<CR>]])
vim.keymap.set("n", "<C-k>", [[<Cmd>wincmd k<CR>]])
vim.keymap.set("n", "<C-l>", [[<Cmd>wincmd l<CR>]])

-- TODO: redo => modify these mappings
vim.keymap.set("n", "+", [[<Cmd>vertical resize -2<CR>]], { noremap = true })
vim.keymap.set("n", "-", [[<Cmd>vertical resize +2<CR>]], { noremap = true })
vim.keymap.set("n", "*", [[<Cmd>horizontal resize +2<CR>]], { noremap = true })
vim.keymap.set("n", "-", [[<Cmd>horizontal resize -2<CR>]], { noremap = true })


return keymaps
