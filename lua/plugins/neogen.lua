return {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function(_, _)
       require("neogen").setup({})
    end
    -- Uncomment next line if you want to follow only stable versions
}
