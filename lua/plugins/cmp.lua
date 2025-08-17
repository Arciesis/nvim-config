return {
   {
      "hrsh7th/nvim-cmp",
      dependencies = {
         "neovim/nvim-lspconfig",
         "hrsh7th/cmp-nvim-lsp",
         "hrsh7th/cmp-buffer",
         "hrsh7th/cmp-path",
         "hrsh7th/cmp-cmdline",
      },

      config = function(_, _)
         local cmp = require("cmp")
         cmp.setup({

            completion = {
               completeopt = "menu,menuone,fuzzy,noinsert",
            },

            mapping = cmp.mapping.preset.insert({
               ["<C-k"] = cmp.mapping.select_next_item(),
               ["<C-j>"] = cmp.mapping.select_prev_item(),
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
                     path = "[Path]",
                     buffer = "[Buffer]",
                  })[entry.source.name]
                  return vim_item
               end,
            },

            sources = {
               {name = "nvim_lsp"},
               {name = "path"},
            }
         })
      end,
   },

   {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = true
   },
}
