local cmd = vim.cmd
local o = vim.opt
local api = vim.api
local k = vim.keymap.set
local ts = require("telescope.builtin")
local lspconfig = require("lspconfig")

cmd.colorscheme "kanagawa"

o.splitbelow = true
o.number = true
o.relativenumber = true
o.expandtab = true
o.cursorline = true
o.splitright = true
o.splitbelow = true
o.cmdheight = 1
o.smartindent = true
o.termguicolors = true
o.backup = true
o.backupdir = "/tmp";
o.cindent = true
o.shiftwidth = 4
o.completeopt = "menu,menuone,noselect"
vim.g.mapleader = ","

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local LSPs = { 'ccls', 'nil_ls', 'gopls', 'pyright', 'ruff_lsp', 'rust_analyzer' }
for _, server in ipairs(LSPs) do
    lspconfig[server].setup {
        capabilities = capabilities,
    }
end

api.nvim_create_autocmd('TermOpen', {
    pattern = "*",
    callback = function()
        local opt = vim.opt_local
        opt.relativenumber = false
        opt.number = false
        vim.cmd [[ startinsert ]]
    end,
})

api.nvim_create_autocmd('LspAttach', {
  group = api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local opts = { buffer = ev.buf }
    k('n', '<space>D', vim.lsp.buf.type_definition, opts)
    k('n', 'gD', vim.lsp.buf.declaration, opts)
    k('n', 'gd', vim.lsp.buf.definition, opts)
    k('n', 'gr', vim.lsp.buf.references, opts)
    k('n', 'K', vim.lsp.buf.hover, opts)
    k('n', 'gi', vim.lsp.buf.implementation, opts)
    k('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    -- Workspace
    k('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    k('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    k('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
    k('n', '<space>rn', vim.lsp.buf.rename, opts)
    k({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    -- Formatting
    k('n', '<space>f', function() vim.lsp.buf.format { async = true } end, opts)
  end,
})


local cmp = require('cmp')
local mappin = cmp.mapping
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = mappin.preset.insert({
    ["<C-k>"] = mappin.select_prev_item(), -- previous suggestion
    ["<C-j>"] = mappin.select_next_item(), -- next suggestion
    ["<C-b>"] = mappin.scroll_docs(-4),
    ["<C-f>"] = mappin.scroll_docs(4),
    ["<C-Space>"] = mappin.complete(), -- show completion suggestions
    ["<C-c>"] = mappin.abort(), -- close completion window
    ["<CR>"] = mappin.confirm({ select = false }),
  }),
  -- sources for autocompletion
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "buffer" }, 
    { name = "path" },
  }),
})

-- git conflict handler!!
require 'git-conflict'.setup({
    default_mappings = {
        ours = 'o',
        theirs = 't',
        none = "0",
        both = "b",
        next = "n",
        prev = "p",
    },
})

-- keymaps
k("n", "-", require("mini.files").open)
k("n", "<leader>f", ts.find_files)
k("n", "<leader>g", ts.git_files)
k("n", "<leader>G", ts.live_grep)
k("n", "<leader>b", ts.buffers)
k('t', '<ESC>', "<C-\\><C-n>")
k('n', '<space>e', vim.diagnostic.open_float)
k('n', '[d', vim.diagnostic.goto_prev)
k('n', ']d', vim.diagnostic.goto_next)
k('n', '<space>q', vim.diagnostic.setloclist)


require 'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
      enable = true,
  },
}

vim.filetype.add { filename = {
    [".envrc"] = "bash",
}}
