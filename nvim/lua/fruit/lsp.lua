local api = vim.api
local lspconfig = require "lspconfig"
local k = vim.keymap.set

local LSPs = {
  "ccls",
  "nil_ls",
  "gopls",
  "pyright",
  "rust_analyzer",
  "ruff_lsp",
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
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    local opts = { buffer = ev.buf }
    k("n", "<space>D", vim.lsp.buf.type_definition, opts)
    k("n", "gD", vim.lsp.buf.declaration, opts)
    k("n", "gd", vim.lsp.buf.definition, opts)
    k("n", "gr", vim.lsp.buf.references, opts)
    k("n", ";", vim.lsp.buf.hover, opts)
    k("n", "gi", vim.lsp.buf.implementation, opts)
    k("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    -- Workspace
    k("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    k("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    k("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    k("n", "<space>rn", vim.lsp.buf.rename, opts)
    k({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
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

k("n", "<space>e", vim.diagnostic.open_float)
k("n", "[d", vim.diagnostic.goto_prev)
k("n", "]d", vim.diagnostic.goto_next)
k("n", "<space>q", vim.diagnostic.setloclist)
