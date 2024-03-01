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
                  require("luasnip").lsp_expand(args.body)
               end,
            },

            completion = {
               completeopt = "menu,menuone,noinsert",
            },

            mapping = cmp.mapping.preset.insert({
               ["<C-f>"] = cmp.mapping.select_next_item(),
               ["<C-b>"] = cmp.mapping.select_prev_item(),
               ["<C-Space>"] = cmp.mapping.complete({}),
               ["<CR>"] = cmp.mapping.confirm({
                  behavior = cmp.ConfirmBehavior.Replace,
                  select = true,
               }),

               ["<Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                     cmp.select_next_item()
                  elseif luasnip.expand_or_locally_jumpable() then
                     luasnip.expand_or_jump()
                  else
                     fallback()
                  end
               end, { "i", "s" }),
               ["<S-Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                     cmp.select_prev_item()
                  elseif luasnip.locally_jumpable(-1) then
                     luasnip.jump(-1)
                  else
                     fallback()
                  end
               end, { "i", "s" }),
            }),

            sources = {
               { name = "nvim_lsp" },
               { name = "luasnip" },
               { name = "path" },
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
