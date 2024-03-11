local lsp_plugins = {
   -- Mason init
   {
      "williamboman/mason.nvim",

      opts = function()
         require("mason")
      end,

      -- config and some stuff goes here
      config = function(_, opts)
         require("mason").setup(opts)
      end,
   },

   {
      "folke/neodev.nvim",
      opts = {},

   },

   {
      "williamboman/mason-lspconfig.nvim",
      dependencies = {
         "williamboman/mason.nvim",
      },

      config = function(_, _)
         require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls", "rust_analyzer", "clangd" },
         })
         require("lspconfig")
      end,
   },

   {
      "nvim-lspconfig",
      dependencies = {
         "williamboman/mason.nvim",
         "williamboman/mason-lspconfig",
      },

      config = function(_, opts)
         local on_attach = function(client, bufnr)
            if client.server_capabilities.inlayHintProvider then
               vim.lsp.inlay_hint.enable(bufnr, true)
            end
         end

         local lspconfig = require("lspconfig")

         lspconfig.lua_ls.setup({
            on_attach = on_attach,
            init_options = opts,
            settings = {
               Lua = {
                  completion = {
                     callSnippet = "Replace",

                  },
               },
            },
         })

         lspconfig.clangd.setup({
            init_options = {
               compilationDatabaseDirectory = "build",
               index = {
                  threads = 0
               },
               single_file_support = true,
            },
            on_attach = on_attach,
         })

         lspconfig.rust_analyzer.setup({
            on_attach = on_attach,
         })
      end,

   },

}

--  If you want insert `(` after select function or method item
--  local cmp_autopairs = require("nvim-autopairs.completions.cmp")
--  local cmp = require("cmp")
--  cmp.event:on(
--  "confirm_done",
--  cmp_autopairs.on_confirm_done()
--  )

return lsp_plugins
