local api = vim.api
local lspconfig = require "lspconfig"
local k = vim.keymap.set

local LSPs = {
  "rust_analyzer",
  "ccls",
  "nil_ls",
  "gopls",
  "pyright",
  "ruff_lsp",
  "eslint",
}

for _, server in ipairs(LSPs) do
  lspconfig[server].setup {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
  }
end

-- LSP setup
api.nvim_create_autocmd("LspAttach", {
  group = api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    vim.bo[ev.buf].formatexpr = "v:lua.vim.lsp.formatexpr"
    if client.supports_method "textDocument/completion" then
      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    end
    if client.supports_method "textDocument/definition" then
      vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
    end

    local opts = { buffer = ev.buf }
    k("n", "<leader>D", vim.lsp.buf.type_definition, opts)
    k("n", "gD", vim.lsp.buf.declaration, opts)
    k("n", "gd", vim.lsp.buf.definition, opts)
    k("n", "gr", vim.lsp.buf.references, opts)
    k("n", ";", vim.lsp.buf.hover, opts)
    k("n", "gi", vim.lsp.buf.implementation, opts)
    k("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    -- Workspace
  end,
})

-- Autocompletion
local cmp = require "cmp"
local mappin = cmp.mapping
cmp.setup {
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  mapping = mappin.preset.insert {
    ["<C-k>"] = mappin.select_prev_item(), -- previous suggestion
    ["<C-j>"] = mappin.select_next_item(), -- next suggestion
    ["<C-b>"] = mappin.scroll_docs(-4),
    ["<C-f>"] = mappin.scroll_docs(4),
    ["<C-Space>"] = mappin.complete(), -- show completion suggestions
    ["<C-c>"] = mappin.abort(), -- close completion window
    ["<CR>"] = mappin.confirm { select = false },
  },
  -- sources for autocompletion
  sources = cmp.config.sources {
    { name = "nvim_lsp" },
    { name = "async_path" },
    { name = "buffer" },
  },
}

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "async_path" },
  }, {
    { name = "cmdline" },
  }),
})

k("n", "<leader>e", vim.diagnostic.open_float)
k("n", "<leader>q", vim.diagnostic.setloclist)
k("n", "[d", vim.diagnostic.goto_prev)
k("n", "]d", vim.diagnostic.goto_next)

require("typescript-tools").setup {
  cmd = {
    "typescript-language-server",
    "--stdio",
  },
  settings = {
    tsserver_file_preferences = {
      includeInlayParameterNameHints = "all",
      includeInlayFunctionParameterTypeHints = true,
      includeInlayEnumMemberValueHints = true,
      includeCompletionsForModuleExports = true,
      quotePreference = "auto",
    },
    tsserver_format_options = {
      allowIncompleteCompletions = false,
      allowRenameOfImportPath = false,
    },
  },
}
