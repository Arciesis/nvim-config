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
