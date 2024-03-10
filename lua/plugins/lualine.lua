local project_root = {
  function()
    return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
  end,
  icon = "",
  cond = hide_in_width,
  separator = ' ',
}

return {
   'nvim-lualine/lualine.nvim',
   dependencies = { 'nvim-tree/nvim-web-devicons' },
   lazy = false,
   config = function(_, _)
      require("lualine").setup({
         options = {
            theme = "molokai",
         },
         sections = {
            lualine_c = {
               project_root,
               { "filename", file_status=true, newfile_status=true, path=1, },
            },
         },
      })
   end
}
