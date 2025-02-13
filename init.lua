local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
   local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("options")
require("utils")

require("lazy").setup("plugins")
require("telescope").load_extension("fzf")

-- TODO: setup the ui for dapui with something I like
-- TODO: setup the dap (dgb) for embedded devices using arm-none-eabi as gdb arguments (How to detect file ?)

vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		vim.opt_local.shiftwidth = 3
		vim.opt_local.tabstop = 3
	end
})

vim.api.nvim_create_autocmd("FileType", {
   pattern = "c",
   callback = function()
      vim.opt_local.shiftwidth = 4
      vim.opt_local.tabstop = 4
   end
})


vim.g.zig_fmt_parse_errors = 0
