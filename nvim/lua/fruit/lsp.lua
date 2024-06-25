local api = vim.api
local lspconfig = require "lspconfig"
local k = vim.keymap.set

local LSPs = {
  "ccls",
  "nil_ls",
  "gopls",
  "pyright",
  "ruff_lsp",
  "eslint",
}
local caps = require("cmp_nvim_lsp").default_capabilities()
for _, server in ipairs(LSPs) do
  lspconfig[server].setup {
    capabilities = caps,
  }
end

lspconfig["rust_analyzer"].setup {
  capabilities = caps,
  settings = {
    ["rust_analyzer"] = {
      diagnostics = {
        enable = true,
        experimental = {
          enable = true,
        },
      },
    },
  },
}

-- LSP setup
api.nvim_create_autocmd("LspAttach", {
  group = api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local bufnr = ev.buf

    vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr"
    if client.supports_method "textDocument/completion" then
      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    end
    if client.supports_method "textDocument/definition" then
      vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
    end

    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

    local opts = { buffer = ev.buf }
    k("n", "<leader>D", vim.lsp.buf.type_definition, opts)
    k("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    k("n", "<leader>rn", vim.lsp.buf.rename, opts)
    k("n", "gd", vim.lsp.buf.declaration, opts)
    k("n", "gD", vim.lsp.buf.definition, opts)
    k("n", "gr", vim.lsp.buf.references, opts)
    k("n", "gi", vim.lsp.buf.implementation, opts)

    -- Diagnostics
    k("n", "<leader>;", vim.diagnostic.setloclist, opts)
    k("n", "<leader>e", vim.diagnostic.goto_prev, opts)
    k("n", "<leader>i", vim.diagnostic.goto_next, opts)

    -- K triggers this by default
    -- k("n", "gh", vim.lsp.buf.hover, opts)
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
    ["<CR>"] = mappin.confirm { select = true },
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
  sources = cmp.config.sources {
    { name = "async_path" },
    { name = "cmdline" },
  },
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
