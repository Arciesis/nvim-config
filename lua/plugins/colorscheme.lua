return {
	"tanvirtin/monokai.nvim",
   lazy = false,
   prority = 1000,
	config = function()
      require("monokai").setup({palette = require("monokai").soda})
	end
}
