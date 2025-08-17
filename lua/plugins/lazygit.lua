return {
   "kdheepak/lazygit.nvim",
   -- optional for floating window border decoration
   dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim"
   },

   config = function()
      require("telescope").load_extension("lazygit")
   end,
}
