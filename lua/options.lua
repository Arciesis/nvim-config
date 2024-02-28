-- see https://neovim.io/doc/user/options.html

-- global options
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- all options (not all actually but the more important imo)
vim.opt.backup = false
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 1
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.hidden = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.mouse = "v"
vim.opt.pumheight = 25
vim.opt.showmode = true
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.timeoutlen = 250
vim.opt.undofile = true
vim.opt.updatetime = 100
vim.opt.writebackup = false
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.signcolumn = "yes"
vim.opt.wrap = true
vim.opt.scrolloff = 25
vim.opt.sidescrolloff = 16
vim.opt.showcmd = true
vim.opt.ruler = true
vim.opt.laststatus = 3
vim.opt.autoindent = true
