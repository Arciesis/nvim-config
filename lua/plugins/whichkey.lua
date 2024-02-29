-- TODO: need to check for dual mappin between git and commented
--  local harpoon = require("harpoon")
-- basic telescope configuration
--  local conf = require("telescope.config").values
--  local function toggle_telescope(harpoon_files)
    --  local file_paths = {}
    --  for _, item in ipairs(harpoon_files.items) do
        --  table.insert(file_paths, item.value)
    --  end

    --  require("telescope.pickers").new({}, {
        --  prompt_title = "Harpoon",
        --  finder = require("telescope.finders").new_table({
            --  results = file_paths,
        --  }),
        --  previewer = conf.file_previewer({}),
        --  sorter = conf.generic_sorter({}),
    --  }):find()
--  end


return {
   "folke/which-key.nvim",
   dependencies = {
      {"ThePrimeagen/harpoon", branch = "harpoon2"},
      "nvim-telescope/telescope.nvim",
   },
   event = "VeryLazy",
   opts = function()
      local wk = require("which-key")
      -- we will create the following mappings:
      --  * <leader>ff find files
      --  * <leader>fr show recent files
      --  * <leader>fb Foobar
      -- we'll document:
      --  * <leader>fn new file
      --  * <leader>fe edit file
      -- and hide <leader>1
      return wk.register({
         ["1"] = "which_key_ignore",
         -- File related
         ["<leader>"] = {
            f = {
               name = "File",
               f = {"<cmd>Telescope find_files<CR>", "Find file"},
               b = {"<cmd>Telescope buffers<CR>", "Buffers"},
               c = {"<cmd>Telescope command_history last_sortused=true<CR>", "Command History"},
               g = {"<cmd>Telescope git_files<cr>", "Find Files (git-files)" },
               r = {"<cmd>Telescope oldfiles<CR>", "Recent" },
               n = {"<cmd>enew<CR>", "New file"}
            },

            c = {
                name = "Comment",
                a = {"<cmd>Neogen generate noremap=true silent=true<CR>", "Annotations"}, -- FIXME: need to be fixed, maybe it will be with luaLS
                --  c = {"<cmd>Comment<CR>", "Comment 1 line"},
            },
            -- Git related
            g = {
                name = "Git",
                g = {"<cmd>LazyGit<CR>", "LazyGit"}, -- if its good then all the below code can be remove
                c = {"<cmd>Telescope git_commits<CR>", "commits" },
                s = {"<cmd>Telescope git_status<CR>", "status" },
                b = {"<cmd>Telescope git_branches<CR>", "branches checkout"},
            },
            -- word or string related
            w = {
                name = "word",
                f = {"<cmd>Telescope live_grep<CR>", "Find egrep"},
                t = {"<cmd>Telescope tags<CR>", "Find tags"}, -- I don't know how to use it exept the fact that for now I have to use ctags -R fisrt
            },
            -- Toggle related
            t = {
                name = "Toggle",
                q = {"<cmd>Telescope quickfix<CR>", "Quickfix"},
                t = {"<cmd>Telescope treesitter<CR>", "Doc preview"},
                f = {"<cmd>ToggleTerm size=50 dir=git_dir direction=float<CR>", "Float terminal"},
                r = {"<cmd>ToggleTerm size=50 dir=git_dir direction=vertical<CR>", "Right terminal"},
            },
            s = {
                name = "Show",
                h = {"<cmd>Telescope highlights<CR>", "Highlights"},
                a = {"<cmd>Telescope autocomands<CR>", "Autocomands"},
            },
            l = {
                name = "LSP",
                -- @TODO: When At least one lsp is configured implement this
                q = {"<cmd>Telescope quickfixhistory<CR>", "Quickfix history"},
                l = {"<cmd>Telescope lsp_document_symbols<CR>", "Lint buffer"},
                d = {"<cmd>Telescope diagnostics bufnr=0<CR>", "Diagnostics"},
            },

            d = {
               name = "DocsView",
               t = {"<cmd>DocsViewToggle<CR>", "Toggle"},
               u = {"<cmd>DocsViewUpdate<CR>", "Update"},
            },

            ["a"] = {function() require("harpoon"):list():append() end, "Add to harpoon", noremap=false},
         },

         ["<c-e>"] = {function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, "Toggle harpoon", noremap=true},
         ["<c-p>"] = {function() require("harpoon"):list():prev()end, "Previous harpoon"},
         ["<c-n>"] = {function() require("harpoon"):list():next()end, "Next harpoon"},
         ["<c-d>"] = {function() require("harpoon"):list():clear()end, "Delete harpoon"},
      })
   end,
}
