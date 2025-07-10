vim.keymap.set({ "n", "v" }, "<leader>w", ":w<CR>")
vim.keymap.set({ "n", "v" }, "<leader>qq", ":q<CR>")
vim.keymap.set({ "n", "v" }, "<leader>vc", ":e ~/.config/nvim/lua/config.lua<CR>")
vim.keymap.set({ "n", "v" }, "<leader>vk", ":e ~/.config/nvim/lua/keymaps.lua<CR>")
vim.keymap.set({ "n", "v" }, "<leader>vi", ":e ~/.config/nvim/init.lua<CR>")
vim.keymap.set({ "n", "v" }, "<leader>vv", ":e ~/.config/nvim<CR>")

vim.keymap.set({ "n", "v", "i" }, "<D-c>", '"+y')
vim.keymap.set({ "n", "v", "i" }, "<D-v>", '"+p')
vim.keymap.set({ "n" }, "<leader>fp", ":Telescope find_files<CR>")
vim.keymap.set({ "n" }, "<leader>ff", ":Telescope live_grep<CR>")

-- NvimTree
vim.keymap.set({ "n" }, "<leader>ee", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>eg", function()
  require("nvim-tree.api").tree.find_file({ open = true, focus = true })
end, { desc = "Reveal current file in NvimTree" })

vim.keymap.set("n", "<leader>ii", function()
	vim.lsp.buf.format({ async = true })
end)

-- Terminal
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])
vim.keymap.set('n', '<leader>tt', 'terminal<CR>')
vim.keymap.set('n', '<leader>tv', ':vsplit<CR><C-w>l | :terminal<CR>')
-- These set the local working directory to be the same as the one it is being opened from
vim.keymap.set("n", "<leader>Tt", function()
  local dir = vim.fn.expand("%:p:h") -- get current file's directory
  vim.cmd("lcd " .. dir)
  vim.cmd("terminal")
end, { desc = "Terminal (cwd = current file)" })

vim.keymap.set("n", "<leader>Tv", function()
  local dir = vim.fn.expand("%:p:h")
  vim.cmd("vsplit")
  vim.cmd("wincmd l")         -- move to the new split
  vim.cmd("lcd " .. dir)      -- set local dir in the new window
  vim.cmd("terminal")
end, { desc = "Vertical Terminal (cwd = current file)" })

-- BUFFERS
-- List all buffers via Telescope
vim.keymap.set("n", "<leader>bl", ":Telescope buffers<CR>")
-- Next / previous buffer
vim.keymap.set("n", "<leader>bn", ":bnext<CR>")
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>")
-- Delete (close) current buffer
vim.keymap.set("n", "<leader>bd", ":bd!<CR>")
-- Delete all but current
vim.keymap.set("n", "<leader>bD", ":%bd|e#|bd#<CR>")

vim.keymap.set("n", "<leader>qs", require("persistence").load, { desc = "Restore Session" })
vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end,
	{ desc = "Restore Last Session" })
vim.keymap.set("n", "<leader>qd", require("persistence").stop, { desc = "Don't Save Current Session" })

-- WINDOWS
-- Split windows
vim.keymap.set("n", "<leader>ws", ":split<CR><C-w>j")
vim.keymap.set("n", "<leader>wv", ":vsplit<CR><C-w>l")
-- Close window
vim.keymap.set("n", "<leader>wd", ":close<CR>")
-- Equalize window sizes
vim.keymap.set("n", "<leader>w=", "<C-w>=w")
-- Navigate between windows
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

vim.keymap.set("n", "<leader>gd", function()
	local word = vim.fn.expand("<cword>")
	require("telescope.builtin").grep_string({
		search = word,
		attach_mappings = function(_, map)
			map("i", "<CR>", function(prompt_bufnr)
				local actions = require("telescope.actions")
				local action_state = require("telescope.actions.state")
				local entry = action_state.get_selected_entry()
				actions.close(prompt_bufnr)
				if entry then
					vim.cmd("edit " .. entry.filename)
					vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.col })
				end
			end)
			return true
		end,
	})
end, { desc = "Jump to first match for word under cursor" })
