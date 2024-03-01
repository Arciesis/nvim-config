local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
   vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
   })
end
vim.opt.rtp:prepend(lazypath)

require("options")
require("utils")

require("lazy").setup("plugins")
require("telescope").load_extension("fzf")


-- TODO: setup dap for c/cpp, check nvim-dap, nvim-dap-ui  plus a c/cpp dap

vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		vim.opt_local.shiftwidth = 3
		vim.opt_local.tabstop = 3
	end
})
