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
                ensure_installed = {"lua_ls"},
            })
        end,


        event = "User FilePost",
        --  config = function()
            --  require("lspconfig")
        --  end,

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
    -- TODO: configure nvim-cmp
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/vim-vsnip",
            "hrsh7th/cmp-vsnip",
        },

        config = function(_, opts)
            require("cmp").setup(opts)
        end
    }
}

return lsp_plugins
