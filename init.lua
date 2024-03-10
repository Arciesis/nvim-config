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


-- TODO: setup the ui for dapui with something I like
-- TODO: setup the dap (dgb) for embedded devices using arm-none-eabi as gdb arguments (How to detect file ?)
-- TODO: setup inlay hints
-- TODO: Add cpplint to the stack

vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		vim.opt_local.shiftwidth = 3
		vim.opt_local.tabstop = 3
	end
})

--  require("lua-config")
