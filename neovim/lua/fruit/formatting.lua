require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = { { "ruff_fix", "ruff_format"}},
    -- Use a sub-list to run only the first available formatter
    javascript = { { "prettierd", "prettier" } },
    nix = { "alejandra" },
    golang = {{"goimports", "gofmt"}},
  },
  format_on_save = {
          -- These options will be passed to conform.format()
          timeout_ms = 500,
          lsp_fallback = true,
  },
}) 


vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})
