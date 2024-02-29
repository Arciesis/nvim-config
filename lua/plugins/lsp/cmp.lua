local cmp_config = {
   "hrsh7th/nvim-cmp",

   dependencies = {
   "hrsh7th/cmp-nvim-lsp",
   "hrsh7th/cmp-buffer",
   "hrsh7th/cmp-path",
   "newovim/nvim-lspconfig",
   "hrsh7th/cmp-vsnip",
   "hrsh7th/vim-vsnip",
   },

   opts = {
      snippet = {
         expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
         end
      },

      window = {
         completion = cmp.config.window.bordered(),
         documentation = cmp.config.window.bordered(),
      },
   },
}

return cmp_config
