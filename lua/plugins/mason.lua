return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()

      require("mason-tool-installer").setup({
        ensure_installed = {
          "bash-language-server",        -- bashls
          "css-lsp",                     -- cssls
          "dockerfile-language-server",  -- dockerls
          "eslint-lsp",                  -- eslint
          "gdtoolkit",
          "html-lsp",                    -- html
          "json-lsp",                    -- jsonls
          "lua-language-server",         -- lua_ls
          "marksman",
          "prettierd",
          "pyright",
          "trivy",
          "typos-lsp",                   -- typos_lsp
          "yaml-language-server",        -- yamlls
        },
      })
    end,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer",
    dependencies = { "williamboman/mason.nvim" },
  },
}
