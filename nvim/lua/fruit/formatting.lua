require("conform").setup {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { { "ruff_fix", "ruff_format" } },
    nix = { "alejandra" },
    golang = { { "goimports", "gofmt" } },
    ["*"] = { "injected" },
    ["_"] = { "trim_whitespace" },
  },
  format_after_save = {
    timeout_ms = 500,
    lsp_fallback = true,
    quiet = true,
  },
}

vim.keymap.set("n", "<leader>o", function()
  require("conform").format {
    lsp_fallback = true,
    quiet = true,
  }
end, {
  noremap = true,
  silent = true,
  buffer = bufnr,
  desc = "Format document",
})
