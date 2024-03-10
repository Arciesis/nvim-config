return {
   {
      "sourcegraph/sg.nvim",
      dependencies = {
         "nvim-lua/plenary.nvim",
         "nvim-telescope/telescope.nvim",
      },

      config = function (_, _)
         require("sg").setup({
            --  on_attach = on_attach()
         })
      end

   },
}
