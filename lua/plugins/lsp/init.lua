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
                ensure_installed = {"lua_ls", "rust_analyzer", "clangd"},
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
        end,

    },

    -- cmp init
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/luasnip",
            "saadparwaiz1/cmp_luasnip",
        },

        config = function(_, _)
           local cmp = require("cmp")
           local luasnip = require("luasnip")
           require("luasnip.loaders.from_vscode").lazy_load()
           luasnip.config.setup({})

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
                 ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                 ["<C-f>"] = cmp.mapping.scroll_docs(4),
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
           --  cmp.setup(opts)
           --  opts.window = {
           --  --  completion = cmp.config.window.bordered(),
           --  documentation = {
           --  border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
           --  },
           --  }

           --  opts.mapping = cmp.mapping.preset.insert({
              --  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              --  ['<C-f>'] = cmp.mapping.scroll_docs(4),
              --  ["<c-'>"] = cmp.mapping.complete(),
              --  ["<c-a>"] = cmp.mapping.abort(),
              --  ["<CR>"] = cmp.mapping.confirm({select = true}),
           --  })

           --  opts.formatting = {
              --  fields = { "kind", "abbr", "menu" },
              --  format = function(entry, vim_item)
                 --  -- Kind icons
                 --  --  vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
                 --  -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
                 --  vim_item.menu = ({
                    --  nvim_lsp = "[LSP]",
                    --  luasnip = "[Snippet]",
                    --  buffer = "[Buffer]",
                    --  path = "[Path]",
                 --  })[entry.source.name]
                 --  return vim_item
              --  end,
           --  }

           --  opts.sources = cmp.config.sources({
              --  {name = "nvim_lsp"},
              --  {name = "luasnip"},
              --  {name = "buffer"},
              --  {name = "buffer"},
           --  })

           --  cmp.setup.filetype("gitcommit", {
              --  sources = cmp.config.sources({
                 --  {name = "git"},
              --  }, {
                 --  {name = "buffer"},
              --  })
           --  })

            --  cmp.setup.cmdline({"/", "?"},{
               --  mapping = cmp.mapping.preset.cmdline(),
               --  sources = {{name = "buffer"}},
            --  })

            --  cmp.setup.cmdline(":", {
               --  mapping = cmp.mapping.preset.cmdline(),
               --  sources = cmp.config.sources({
                  --  {name = "path"},
               --  }, {
                  --  {name = "cmdline"},
               --  })
            --  })


           --  local capabilities = require("cmp_nvim_lsp").default_capabilities()
           --  require("lspconfig")["lua_ls"].setup({
              --  capabilities = capabilities
           --  })

           --  require("lspconfig")["clangd"].setup({
              --  capabilities = capabilities
           --  })

           --  require("lspconfig")["rust_analyzer"].setup({
              --  capabilities = capabilities
           --  })
        end
     }
  }

return lsp_plugins
