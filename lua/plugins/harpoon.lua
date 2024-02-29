return {
   "ThePrimeagen/harpoon",
   branch = "harpoon2",
   dependencies = {"nvim-telescope/telescope.nvim" ,"nvim-lua/plenary.nvim" },
   opts = {},
   config = function()
      require("harpoon").setup({
         settings = {
            save_on_toggle = true,
            save_on_ui_close = true,
         },
      })
   end,
}



--  local harpoon = require("harpoon")
--  harpoon.setup()
