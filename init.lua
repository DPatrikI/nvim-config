-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.opt.termguicolors = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lsp.handlers")
require("config")
require("lazy").setup("plugins")
require("keymaps")

vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 250
vim.opt.signcolumn = 'yes'
vim.opt.scrolloff = 10
vim.opt.hlsearch = false

local on_attach = require("lsp.on_attach").setup

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    on_attach(nil, ev.buf)     -- client is ev.data.client_id if you need it
  end,
})
