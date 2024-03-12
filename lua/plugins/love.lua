return {
   "S1M0N38/love2d.nvim",
   cmd = "LoveRun",
   config = function()
      require("love2d").setup({
         --  path_to_love_bin = "/usr/bin/love",
         path_to_love_library = vim.fn.globpath(vim.o.runtimepath, "love2d/library"),
         restart_on_save = false,
      })
   end,
}
