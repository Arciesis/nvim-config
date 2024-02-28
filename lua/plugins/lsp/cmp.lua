local cmp = require("cmp")

local options = {
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        end,
    },

    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    --  mapping = cmp.mapping.preset.insert({
        --  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        --  ['<C-f>'] = cmp.mapping.scroll_docs(4),
        --  ['<C-Space>'] = cmp.mapping.complete(),
        --  ['<C-e>'] = cmp.mapping.abort(),
        --  ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    --  }),
    --  TODO: make the mapping with which key if possible
    --
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' }, -- For vsnip users.
    }, {
        { name = 'buffer' },
    })

    capabilities = function()
        return require("cmp_nvim_lsp").default_capabilities()
    end,
}

return options
