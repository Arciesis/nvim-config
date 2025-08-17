return {
   'nvim-lualine/lualine.nvim',
   dependencies = { 'nvim-tree/nvim-web-devicons' },
   lazy = false,
   priority = 1,
   config = function(_, _)
      require("lualine").setup({
         options = {
            theme = "horizon",
         },
         sections = {
            lualine_c = {
               -- project_root,
               { "filename", file_status = true, newfile_status = true, path = 1 },
            },
         },
      })
   end
}
