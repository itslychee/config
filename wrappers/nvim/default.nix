{
  pkgs,
  lib,
  ...
}: {
  wrappers.nvim = let
    neovim = pkgs.neovimUtils.makeNeovimConfig {
      wrapRc = false;
      # See env.MYVIMRC for explanation
      vimAlias = true;
      viAlias = true;
      customRc = builtins.readFile ./vimrc;
      plugins =
        map (plugin: {
          inherit plugin;
          config = null;
          optional = false;
        }) (builtins.attrValues {
          inherit
            (pkgs.vimPlugins)
            git-conflict-nvim
            nvim-web-devicons
            kanagawa-nvim
            telescope-nvim
            nvim-lspconfig
            ;
          treesitter = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
        });
    };
  in {
    basePackage = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped neovim;
    # This feels like a cleaner approach as I can override
    # the configuration with flags.
    flags = [
      "-u"
      ./vimrc
    ];
    pathAdd = builtins.attrValues {
      inherit
        (pkgs)
        git
        ripgrep
        ;
    };
  };
}
