-- ─── LSP: smarter ‘gd’ ────────────────────────────────────────────────
local util     = vim.lsp.util
local handler  = vim.lsp.handlers["textDocument/definition"]

---@param locations lsp.Location[]|lsp.LocationLink[]
local function dedup(locations)
  local seen, uniq = {}, {}
  for _, loc in ipairs(locations) do
    -- normalise to URI + line + character so symlinks / relative paths match
    local uri   = loc.uri or loc.targetUri
    local range = loc.range or loc.targetSelectionRange
    local key   = table.concat({ uri, range.start.line, range.start.character }, ":")
    if not seen[key] then
      seen[key], uniq[#uniq + 1] = true, loc
    end
  end
  return uniq
end

vim.lsp.handlers["textDocument/definition"] = function(err, result, ctx, cfg)
  if err or not result or vim.tbl_isempty(result) then return end
  local locs = type(result) == "table" and result or { result }
  locs       = dedup(locs)

  if #locs == 1 then                  -- jump directly
    util.jump_to_location(locs[1], cfg, true)        -- true = reuse window
  else                                -- keep Neovim’s default for multiples
    handler(err, locs, ctx, cfg)
  end
end
