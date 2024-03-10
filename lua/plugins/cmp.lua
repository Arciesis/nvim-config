return {
   {
      "hrsh7th/nvim-cmp",
      dependencies = {
         "neovim/nvim-lspconfig",
         "hrsh7th/cmp-nvim-lsp",
         "hrsh7th/cmp-buffer",
         "hrsh7th/cmp-path",
         "hrsh7th/cmp-cmdline",
         "L3MON4D3/LuaSnip",
         "saadparwaiz1/cmp_luasnip",
      },

      config = function(_, _)
         local cmp = require("cmp")
         local luasnip = require("luasnip")
         require("luasnip.loaders.from_vscode").lazy_load()
         require("luasnip").config.setup({})

         cmp.setup({
            snippet = {
               expand = function(args)
                  luasnip.lsp_expand(args.body)
               end,
            },

            completion = {
               completeopt = "menu,menuone,noinsert",
            },

            mapping = cmp.mapping.preset.insert({
               ["<C-n>"] = cmp.mapping.select_next_item(),
               ["<C-p>"] = cmp.mapping.select_prev_item(),
               ["<C-Space>"] = cmp.mapping.complete({}),
               ["<CR>"] = cmp.mapping.confirm({
                  behavior = cmp.ConfirmBehavior.Replace,
                  select = true,
               }),
            }),

            formatting = {
               format = function(entry, vim_item)
                  vim_item.kind = string.format("%s %s", vim_item.kind, entry.source.name)
                  vim_item.menu = ({
                     nvim_lsp = "[LSP]",
                     luasnip = "[LuaSnip]",
                     path = "[Path]",
                     buffer = "[Buffer]",
                     cmdline = "[Cmdline]",
                     cody = "[Cody]",
                  })[entry.source.name]
                  return vim_item
               end,
            },

            sources = {
               {name = "cody"},
               {name = "nvim_lsp"},
               {name = "ccls"},
               {name = "luasnip"},
               {name = "path"},
               {name = "cmdline"},
            }
         })
      end,
   },

   {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = true
      -- use opts = {} for passing setup options
      -- this is equalent to setup({}) function
   },
}
