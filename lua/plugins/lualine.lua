return {
   'nvim-lualine/lualine.nvim',
   dependencies = { 'nvim-tree/nvim-web-devicons' },
   lazy = false,
   opts = {
      options = {
         theme = "molokai",
         sections = {
            lualine_c = {
               "filename",
               file_status = true,
               newfile_status = false,
               path = 1,
               sorting_target = 40,
               symbols = {
                  modified = '[+]',      -- Text to show when the file is modified.
                  readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
                  unnamed = '[No Name]', -- Text to show for unnamed buffers.
                  newfile = '[New]',     -- Text to show for newly created file before first write
               }
            },
         },
      },
   },
}
