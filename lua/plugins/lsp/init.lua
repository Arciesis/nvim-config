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
      "williamboman/mason-lspconfig.nvim",
      dependencies = {
         "williamboman/mason.nvim",
      },

      config = function(_, _)
         require("mason-lspconfig").setup({
            ensure_installed = {"lua_ls", "rust_analyzer"},
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
         require("lspconfig").lua_ls.setup(opts)
         require("lspconfig").ccls.setup({
            init_options = {
               compilationDatabaseDirectory = "build",
               index ={
                  threads = 0
               },
               single_file_support = true,
            },
            clang = {
               excludeArgs = {"-frouding-math"},
            },
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
