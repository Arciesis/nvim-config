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
            ensure_installed = { "lua_ls", "rust_analyzer", "clangd", "zls", "arduino_language_server" },
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
               vim.lsp.inlay_hint.enable(true)
            end
         end


         local lspconfig = require("lspconfig")

         lspconfig.lua_ls.setup({
            on_attach = on_attach,
            init_options = opts,
            settings = {
               Lua = {
                  runtime = {
                     version = "Lua 5.3"
                  },
                  completion = {
                     callSnippet = "Both",
                  },
                  workspace = {
                     library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                        [vim.fn.expand("${3rd}/love2d/library")] = true,
                        [vim.fn.expand("~/.asdf/installs/lua/5.1.5/luarocks/bin/busted")] = true,
                        -- comment hter line bvelow if your not working on
                        -- Lynked ArcsDpsMeter
                        [vim.fn.expand("~/.steam/steam/steamapps/common/Lynked Banner of the Spark/Saturn/Binaries/Win64/Mods/shared/types")] = true,
                     },
                  },
                  hint = {
                     enable = true,
                  },
                  maxPreload = 100000,
                  preloadFileSize = 100000,
               },
            },
         })

         lspconfig.pylsp.setup({})

         lspconfig.bashls.setup({})
         --  lspconfig.cssls.setup({})
         --  lspconfig.css_variables.setup({})

         -- arduino config
         lspconfig.arduino_language_server.setup({
            on_new_config = function(config, _)
               config.capabilities.textDocument.semanticTokens = vim.NIL
               config.capabilities.workspace.semanticTokens = vim.NIL
            end,
            cmd = {
               "arduino-language-server",
               "-clangd",      "/bin/clangd",
               "-cli",         "/home/arciesis/bin/arduino-cli",
               "-cli-config", "/home/arciesis/.arduino15/arduino-cli.yaml",
            },
            on_attach = on_attach,

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

         lspconfig.zls.setup({
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
