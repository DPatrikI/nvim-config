vim.g.mapleader = " "
vim.opt.rtp:prepend("~/.local/share/nvim/lazy/lazy.nvim")

require("lazy").setup({
	-- LSP manager
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate", -- keeps registry fresh
		config = true,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = { "vtsls" }, --  ← installs the JS/TS LS
			automatic_installation = false,
		},
	},

	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		config = function()
			require("persistence").setup()
		end,
	},
	-- Native LSP config
	{ "neovim/nvim-lspconfig" },

	{
		"habamax/vim-godot",
		ft = { "gd", "gdscript" },
	},

	-- ── Treesitter for syntax highlighting ──────────────────────────────
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				-- parsers you actually use
				ensure_installed = { "lua", "typescript", "javascript", "tsx", "html", "css", "gdscript", "gdshader", "json", "yaml", "markdown" },
				highlight        = { enable = true },
				indent           = { enable = true },
			})
		end,
	},
	-- Sticky context for Treesitter
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("plugins.treesitter-context")()
		end,
	},

	-- Fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-telescope/telescope-live-grep-args.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
	},

	-- Git integration
	{ "lewis6991/gitsigns.nvim" },


	-- Comment : gcc -> single line, gc in visual -> selection
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({
				toggler = {
					line = "gc", -- replace "gcc" with "gc"
					block = "gb", -- block comment
				},
				opleader = {
					line = "gc", -- use gc in visual mode
					block = "gb",
				},
				-- Optional: if you want to disable `gcc` entirely
				mappings = {
					basic = true, -- enables gc, gb
					extra = false, -- disables gco, gcO, gcA
				},
			})
		end,
	},

	-- File Tree
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				view = {
					width = 70,
					number = true,
					relativenumber = true,
				},
				--      update_focused_file = {
				-- enable = true,
				-- update_root = false, -- optional: set to true if you want to change root dir
				-- ignore_list = {},
				--      },
				--      actions = {
				-- change_dir = {
				--   enable = true,
				--   global = false,
				--   restrict_above_cwd = false,
				-- },
				--      },
			})
		end,
	},

	-- Theme

	-- Example: tokyonight
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme tokyonight-moon]])
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
	},

	-- Autopairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},

	{
		"github/copilot.vim",
		event = "InsertEnter",
	},
	{
		"RRethy/vim-illuminate",
		config = function()
			require("illuminate").configure({
				delay = 200, -- ms before highlighting
				large_file_cutoff = 2000,
				under_cursor = true,
				filetypes_denylist = { "NvimTree", "TelescopePrompt" },
			})
		end
	}
})

local actions = require("telescope.actions")
local lga_actions = require("telescope-live-grep-args.actions")

require("telescope").setup({
  defaults = {
    path_display = { "smart" },

    -- Persistent search history across sessions
    history = {
      path = vim.fn.stdpath("data") .. "/telescope_history.sqlite3",
      limit = 200,
    },

    mappings = {
      i = {
        ["<c-d>"] = actions.delete_buffer,     -- keep your original
        ["<c-n>"] = actions.cycle_history_next, -- move to next history entry
        ["<c-p>"] = actions.cycle_history_prev, -- move to previous history entry
      },
      n = {
        ["<c-d>"] = actions.delete_buffer,     -- keep your original
        ["<c-n>"] = actions.cycle_history_next,
        ["<c-p>"] = actions.cycle_history_prev,
      },
    },
  },

  extensions = {
    live_grep_args = {
      auto_quoting = true, -- allows spaces in the prompt
      mappings = {
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt_and_add_glob,
        },
      },
    },
  },
})

require("telescope").load_extension("live_grep_args")

local lspconfig                             = require("lspconfig")
vim.lsp.handlers["textDocument/definition"] =
    vim.lsp.with(vim.lsp.handlers["textDocument/definition"], { reuse_win = true })
local capabilities                          = require("cmp_nvim_lsp").default_capabilities()


-- GDScript
lspconfig.gdscript.setup({
	name         = "godot",
	cmd          = vim.lsp.rpc.connect("127.0.0.1", 6005), -- Unix/Mac; on Windows keep your ncat fallback
	filetypes    = { "gd", "gdscript", "gdshader" },
	root_dir     = lspconfig.util.root_pattern("project.godot", ".git"),
	capabilities = capabilities,
	on_attach    = function(_, bufnr)
		local map = function(lhs, rhs) vim.keymap.set("n", lhs, rhs, { buffer = bufnr }) end
		map("gd", vim.lsp.buf.definition) -- jump to definition
		map("gD", function()
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

-- TypeScript
-- shared on_attach (reuse your Godot key-maps)
local on_attach = function(_, bufnr)
  local map = function(lhs, rhs) vim.keymap.set("n", lhs, rhs, { buffer = bufnr }) end

  local function to_buf_and_pos(win, uri, pos)
    local bufnr = vim.uri_to_bufnr(uri)
    if not vim.api.nvim_buf_is_loaded(bufnr) then vim.fn.bufload(bufnr) end
    vim.api.nvim_set_current_win(win)
    vim.api.nvim_win_set_buf(win, bufnr)
    -- LSP positions are 0-based
    vim.api.nvim_win_set_cursor(win, { pos.line + 1, pos.character })
    -- open folds at cursor
    vim.cmd("normal! zv")
    -- force cursor line to be the top line, regardless of any centering plugins
    local view = vim.fn.winsaveview()
    view.topline = vim.api.nvim_win_get_cursor(win)[1]
    vim.fn.winrestview(view)
  end

  local function jump_definition(opts)
    local vsplit = opts and opts.vsplit
    local curwin = vim.api.nvim_get_current_win()
    local target_win = curwin
    if vsplit then
      vim.cmd("vsplit")
      target_win = vim.api.nvim_get_current_win()
    end

    local params = vim.lsp.util.make_position_params()
    vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result)
      if err then return end
      if not result or (type(result) == "table" and vim.tbl_isempty(result)) then return end

      -- If multiple results, open quickfix like the default behavior and stop.
      local results = result
      if not vim.tbl_islist(results) then results = { results } end
      if #results > 1 then
        local items = vim.lsp.util.locations_to_items(results, 0)
        if items and #items > 0 then
          vim.fn.setqflist({}, " ", { items = items, title = "LSP Definitions" })
          vim.cmd("copen")
        end
        return
      end

      -- Single location or locationLink
      local loc = results[1]
      if loc.targetUri then
        -- LocationLink
        to_buf_and_pos(target_win, loc.targetUri, loc.targetSelectionRange.start or loc.targetRange.start)
      else
        -- Location
        to_buf_and_pos(target_win, loc.uri, loc.range.start)
      end
    end)
  end

  map("gd", function() jump_definition() end)
  map("gD", function() jump_definition({ vsplit = true }) end)

  map("gi", vim.lsp.buf.implementation)
  map("gr", vim.lsp.buf.references)
  map("K",  vim.lsp.buf.hover)
end
