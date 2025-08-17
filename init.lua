local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
   local lazyrepo = "https://github.com/folke/lazy.nvim.git"
   local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
   if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
         { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
         { out,                            "WarningMsg" },
         { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
   end
end
vim.opt.rtp:prepend(lazypath)

require("options")
require("keymaps")
require("lazy").setup("plugins")
require("telescope").load_extension("fzf")
require("monokai")

vim.keymap.set('n', '<Leader>db', function() require("debug.disasm").show({ name = 'main' }) end,
   { noremap = true, silent = true, desc = "Disasm Debugger" })

vim.api.nvim_create_autocmd("FileType", {
   pattern = "lua",
   callback = function()
      vim.opt_local.shiftwidth = 3
      vim.opt_local.tabstop = 3
   end
})

vim.lsp.enable('zls')
vim.lsp.enable('c')
vim.lsp.enable('lua')
vim.lsp.enable('cpp')
vim.lsp.enable('pylsp')
vim.lsp.enable('yaml')
vim.lsp.enable('css')
vim.lsp.enable('clangd')
