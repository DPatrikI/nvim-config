local M = {}

function M.setup(_, bufnr)
  local map = function(lhs, rhs)          -- helper
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true })
  end

  map("gd",  vim.lsp.buf.definition)      -- jump (current win)
  map("gD",  function()                   -- jump in vertical split
    vim.cmd("vsplit")
    vim.lsp.buf.definition()
  end)
  map("gi",  vim.lsp.buf.implementation)
  map("gr",  vim.lsp.buf.references)
  map("K",   vim.lsp.buf.hover)
end

return M
