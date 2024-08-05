local api = vim.api
local lspconfig = require "lspconfig"
local k = vim.keymap.set

local LSPs = {
  "ccls",
  "nil_ls",
  "gopls",
  "pyright",
  "typst_lsp",
  "ruff_lsp",
  "eslint",
  "rust_analyzer",
}
local caps = require("cmp_nvim_lsp").default_capabilities()
for _, server in ipairs(LSPs) do
  lspconfig[server].setup {
    capabilities = caps,
  }
end

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

    function lsp(kmType, keymap, func, description)
      k("n", keymap, func, {
        buffer = ev.buf,
        desc = "[" .. kmType .. "] " .. description,
      })
    end
    lsp("LSP", "<leader>D", vim.lsp.buf.type_definition, "Type Definition")
    lsp("LSP", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
    lsp("LSP", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    lsp("LSP", "gd", vim.lsp.buf.declaration, "Goto declaration")
    lsp("LSP", "gD", vim.lsp.buf.definition, "Goto definition")
    lsp("LSP", "gr", vim.lsp.buf.references, "See references")
    lsp("LSP", "gi", vim.lsp.buf.implementation, "Goto implementation")

    -- Diagnostics
    lsp("Diagnostics", "<leader>s", vim.diagnostic.setloclist, "Overview")
    lsp("Diagnostics", "<leader>a", vim.diagnostic.open_float, "Expand error")
    lsp("Diagnostics", "<leader>e", vim.diagnostic.goto_prev, "Go to previous error")
    lsp("Diagnostics", "<leader>i", vim.diagnostic.goto_next, "Go to next error")

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
