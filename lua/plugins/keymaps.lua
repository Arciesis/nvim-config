local keymaps = {
   "folke/which-key.nvim",
   dependencies = {
      { "ThePrimeagen/harpoon", branch = "harpoon2" },
      "nvim-telescope/telescope.nvim",
   },
   event = "VeryLazy",
   opts = function()
      local wk = require("which-key")
      return wk.register({
         ["1"] = "which_key_ignore",
         -- General
         ["<leader>"] = {
            -- File related
            f = {
               name = "File",
               f = { "<cmd>Telescope find_files<CR>", "Find file" },
               b = { "<cmd>Telescope buffers<CR>", "Buffers" },
               c = { "<cmd>Telescope command_history last_sortused=true<CR>", "Command History" },
               g = { "<cmd>Telescope git_files<cr>", "Find Files (git-files)" },
               r = { "<cmd>Telescope oldfiles<CR>", "Recent" },
               n = { "<cmd>new<CR>", "New file" },
               w = { "<cmd>Telescope live_grep<CR>", "Find egrep" },
            },

            -- Annotations and comments related
            -- TODO Add a comment method here instead of gcc maybe or reafcto that thing
            --  c = {
            --  name = "Comment",
            --  a = {"<cmd>Neogen<CR>", "Annotations"},
            --  --  c = {"<cmd>Comment<CR>", "Comment 1 line"},
            --  },
            -- Git related
            g = {
               name = "Git",
               g = { "<cmd>LazyGit<CR>", "LazyGit" },
               --  c = {"<cmd>Telescope git_commits<CR>", "commits" },
               --  s = {"<cmd>Telescope git_status<CR>", "status" },
               --  b = {"<cmd>Telescope git_branches<CR>", "branches checkout"},
            },
            -- Toggle related
            -- FIXME: reafcto that thing maybe not do a toggle but each plugin that require a toggle need to have a t mapping
            t = {
               name = "Toggle",
               q = { "<cmd>Telescope quickfix<CR>", "Quickfix" },
               t = { "<cmd>Telescope treesitter<CR>", "Doc preview" },
               f = { "<cmd>ToggleTerm size=50 dir=git_dir direction=float<CR>", "Float terminal" },
               r = { "<cmd>ToggleTerm size=50 dir=git_dir direction=vertical<CR>", "Right terminal" },
            },
            s = {
               name = "Show",
               h = { "<cmd>Telescope highlights<CR>", "Highlights" },   -- I think it's useless
               a = { "<cmd>Telescope autocomands<CR>", "Autocomands" }, -- I think its useless too
            },
            l = {
               name = "LSP",
               -- @TODO: When At least one lsp is configured implement this
               h = { "<cmd>Telescope quickfixhistory<CR>", "Quickfix history" },
               l = { "<cmd>Telescope lsp_document_symbols<CR>", "Lint buffer" },               -- Might be useful but I'm not sure
               e = { function() vim.diagnostic.open_float({}) end, "Open diagnostic window" }, -- is it really useful ???
               q = { function() vim.diagnostic.setloclist({}) end, "don't know" },
            },

            d = {
               name = "DocsView",
               t = { "<cmd>DocsViewToggle<CR>", "Toggle" },
               u = { "<cmd>DocsViewUpdate<CR>", "Update" },
            },

            ["a"] = { function() require("harpoon"):list():append() end, "Add to harpoon", noremap = false },
         },

         -- Trouble related
         t = {
            name = "Trouble",
            x = {function() require("trouble").toggle() end, "Toggle"},
            w = {function() require("trouble").toggle("workspace_diagnostics") end, "workspace diag"},
            d = {function() require("trouble").toggle("document_diagnostics") end, "Document diag"},
            q = {function() require("trouble").toggle("quickfix") end, "Quickfix"},
            l = {function() require("trouble").toggle("localist") end, "loclist"},
         },
         ["gR"] = {function() require("trouble").toggle("lsp_references") end, "Lsp reference"},

         -- Harpoon related
         ["<c-e>"] = { function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, "Toggle harpoon", noremap = true },
         ["<c-p>"] = { function() require("harpoon"):list():prev() end, "Previous harpoon" },
         ["<c-n>"] = { function() require("harpoon"):list():next() end, "Next harpoon" },
         ["<c-d>"] = { function() require("harpoon"):list():clear() end, "Delete harpoon" },
      })
   end,
}

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

vim.api.nvim_create_autocmd("TermOpen", {
   pattern = [[term://*]],
   callback = function(evt)
      local opts = { buffer = evt.buf }
      vim.keymap.set('t', '<esc>', "exit<CR>", opts)
      vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
   end

})

return keymaps
