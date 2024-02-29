
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
        end
     },

     {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true
        -- use opts = {} for passing setup options
        -- this is equalent to setup({}) function
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
