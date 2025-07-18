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
vim.opt.tabstop = 2        -- number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 2     -- number of spaces to use for each step of (auto)indent
vim.opt.expandtab = false  -- convert tabs to spaces
vim.opt.smartindent = true -- smart autoindenting when starting a new line

local on_attach = require("lsp.on_attach").setup

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		on_attach(nil, ev.buf) -- client is ev.data.client_id if you need it
	end,
})

local group = vim.api.nvim_create_augroup("ForceLineNumbersEverywhere", { clear = true })

-- Whenever a window becomes active (or a terminal opens) turn numbers back on.
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "TermOpen", "CmdwinEnter" }, {
	group = group,
	callback = function() -- no args needed
		vim.wo.number         = true
		vim.wo.relativenumber = true
	end,
})

-- Optional: if any script/plugin toggles the options later, flip them back.
vim.api.nvim_create_autocmd("OptionSet", {
	group = group,
	pattern = { "number", "relativenumber" },
	callback = function()
		-- guard against endless recursion by changing only when off
		if not vim.wo.number then vim.wo.number = true end
		if not vim.wo.relativenumber then vim.wo.relativenumber = true end
	end,
})
