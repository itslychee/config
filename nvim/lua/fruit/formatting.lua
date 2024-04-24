require("conform").setup {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { { "ruff_fix", "ruff_format" } },
    nix = { "alejandra" },
    golang = { { "goimports", "gofmt" } },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format { bufnr = args.buf }
  end,
})

vim.keymap.set("n", "<space>f", function()
  require("conform").format()
end, { noremap = true, silent = true, buffer = bufnr, desc = "Format document" })
