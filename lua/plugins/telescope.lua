return {
   "nvim-telescope/telescope.nvim",
   branch = "0.1.x",
   dependencies = {
      "nvim-lua/plenary.nvim",
      "BurntSushi/ripgrep",
      {
         {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
            --  enabled = vim.fn.executable("make") == 1,
         },

         "nvim-treesitter/nvim-treesitter",
         "nvim-tree/nvim-web-devicons",
         "folke/which-key.nvim",
      },
   },

   opts = {
      extensions = {
         fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
         },
      },
   },
}
