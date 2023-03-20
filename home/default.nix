{ config, pkgs, flags, inputs, ...}:
with pkgs.lib;
{
  imports = [
    (import ../mixins/home/crypt.nix {})
    ./programs.nix
    ./services.nix
    ./graphical.nix
    ./firefox.nix
    ./waybar.nix
  ];
  home.sessionVariables = {
    EDITOR = "${pkgs.neovim}/bin/nvim";
  };
  home.packages = with pkgs; [
    # System info tool
    neofetch
    # Rust implementation of the age program for encryption
    rage
  ]
  # MPD applications
  ++ optionals config.services.mpd.enable [ mpc-cli ]
  # Non-headless specific packages (desktop)
  ++ optionals (!flags.headless or false) [ spotify ]
  # Headless specific packages (server) 
  ++ optionals (flags.headless or false) [];
}
