{
  neovimUtils,
  vimUtils,
  vimPlugins,
  wrapNeovimUnstable,
  lib,
  neovim-unwrapped,
  ripgrep,
  nil,
  stylua,
  gotools,
  alejandra,
  grammars ? vimPlugins.nvim-treesitter.withAllGrammars,
}: let
  nvim-config = neovimUtils.makeNeovimConfig {
    plugins = [
      (vimUtils.buildVimPlugin {
        name = "fruit-nvim-config";
        dependencies = builtins.attrValues {
          inherit
            (vimPlugins)
            cmp-async-path
            cmp-buffer
            cmp-cmdline
            cmp-nvim-lsp
            conform-nvim
            git-conflict-nvim
            kanagawa-nvim
            lualine-nvim
            mini-nvim
            luasnip
            nvim-cmp
            nvim-lspconfig
            nvim-web-devicons
            typescript-tools-nvim
            nvim-ts-context-commentstring
            ;
          inherit grammars;
        };
        src = ../nvim;
      })
    ];
    wrapRc = false;
  };
in
  (wrapNeovimUnstable neovim-unwrapped nvim-config).overrideAttrs (old: {
    generatedWrapperArgs =
      old.generatedWrapperArgs
      or []
      ++ [
        "--suffix"
        "PATH"
        ":"
        (lib.makeBinPath [
          ripgrep
          nil
          stylua
          gotools
          alejandra
        ])
      ];
  })
