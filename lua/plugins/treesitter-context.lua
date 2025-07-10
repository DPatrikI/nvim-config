return function()
  require("treesitter-context").setup({
    enable = true,
    max_lines = 3,
    trim_scope = "outer",
    mode = "cursor",
    zindex = 20,
  })
end
