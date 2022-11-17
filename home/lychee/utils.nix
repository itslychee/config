{ config, pkgs, ...}:
{
  programs = { 
   gpg.enable = true;
   bash.enable = true;
   direnv = {
     enable = true;
     nix-direnv.enable = true;
     stdlib = ''
        : ''${XDG_CACHE_HOME:=$HOME/.cache}
        declare -A direnv_layout_dirs
        direnv_layout_dir() {
            echo "''${direnv_layout_dirs[$PWD]:=$(
              local path="''${PWD//[^a-zA-Z0-9]/-}"  
              echo "$XDG_CACHE_HOME/direnv/layouts/''${path:1}"
            )}"
        }
     '';
   };
   htop = {
      enable = true;
      settings = {
        color_scheme = 5;
        tree_view = 1;
        tree_view_always_by_pid = 1;
        enable_mouse = 1;
        degree_fahrenheit = 1;
        delay = 10;
      };
    };
    git = rec {
      enable = true;
      userName = "Lychee";
      userEmail = "itslychee@protonmail.com";
      signing = {
        signByDefault = true;
        key = userEmail; 
      };
      delta = {
        enable = true;
        options = {
          line-numbers = true;
        };
      };
      extraConfig = {
        core.editor = config.home.sessionVariables.EDITOR or "${pkgs.nvim}/bin/nvim";
      };
    };
    ssh = {
      enable = true;
      compression = true;
      matchBlocks = {
        "Raspberry Pi" = {
          host = "pi";
          hostname = "192.168.0.2";
          user = "pi";
        };
      };
    };

  };
}
