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

         local on_attach = function(client, _)
            if client.server_capabilities.inlayHintProvider then
                              vim.lsp.buf.set_inlay_hints({
                  show_parameter_hints = true,
                  parameter_hints_prefix = "",
                  other_hints_prefix = "",
                  right_align = false,
                  max_len_align = false,
                  max_len_align_padding = 1,
                  max_len_align_prefix = "",
               })
            end
         end

         require("lspconfig").lua_ls.setup({
            on_attach = on_attach,
            init_options = opts,
         })

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
