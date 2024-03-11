return {
    "winston0410/commented.nvim",
    config = function() 
       require("commented").setup({
          comment_padding = " ",
          prefer_block_comment = false,
          set_keybindings = true,
          ex_mode_cmd = "Comment",
          keybindings = {nl = "gcc"},
       })
    end
}
