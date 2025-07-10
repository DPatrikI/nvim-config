vim.g.mapleader = " "
vim.opt.rtp:prepend("~/.local/share/nvim/lazy/lazy.nvim")

require("lazy").setup({
	-- LSP manager
	{ "williamboman/mason.nvim",           config = true },
	{ "williamboman/mason-lspconfig.nvim", config = true },

	{ "folke/persistence.nvim",
		event = "BufReadPre",
		config = function ()
			require("persistence").setup()
		end,
	},
	-- Native LSP config
	{ "neovim/nvim-lspconfig" },

	{
		"habamax/vim-godot",
		ft = { "gd", "gdscript" },
	},

	-- Autocompletion engine
	{ "hrsh7th/nvim-cmp" },

	-- Treesitter for syntax highlighting
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

	-- Fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- Git integration
	{ "lewis6991/gitsigns.nvim" },

	-- File Tree
	{ "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" }, config = true },

	-- Theme

	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				theme = "wave", -- "wave", "dragon", or "lotus"
				background = {
					dark = "wave", -- theme for dark mode
					light = "lotus", -- theme for light mode
				},
				transparent = false,
			})

			vim.cmd("colorscheme kanagawa")
		end,
	},

	-- Autocomplete
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- LSP-powered items
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip", -- snippet engine
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args) require("luasnip").lsp_expand(args.body) end,
				},
				mapping = cmp.mapping.preset.insert({ -- tab/CR behave like VS Code
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				},
			})
		end,
	}
})

require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<c-d>"] = require("telescope.actions").delete_buffer,
			},
			n = {
				["<c-d>"] = require("telescope.actions").delete_buffer,
			},
		},
	},
})

local lspconfig    = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.gdscript.setup({
	name         = "godot",
	cmd          = vim.lsp.rpc.connect("127.0.0.1", 6005), -- Unix/Mac; on Windows keep your ncat fallback
	filetypes    = { "gd", "gdscript", "gdshader" },
	root_dir     = lspconfig.util.root_pattern("project.godot", ".git"),
	capabilities = capabilities,
	on_attach    = function(_, bufnr)
		local map = function(lhs, rhs) vim.keymap.set("n", lhs, rhs, { buffer = bufnr }) end
		map("gd", vim.lsp.buf.definition) -- jump to definition
		map("gD", function ()
			vim.cmd("vsplit")
			vim.lsp.buf.definition()
		end)
		-- map("gD", vim.lsp.buf.declaration)
		map("gi", vim.lsp.buf.implementation)
		map("gr", vim.lsp.buf.references)
		map("K", vim.lsp.buf.hover)
	end,
})
-- Optional: Make sure Neovim sees `.gd` as GDScript
vim.filetype.add({
	extension = {
		gd = "gdscript",
	},
})
