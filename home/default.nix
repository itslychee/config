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
    neofetch
  ] ++ optionals config.services.mpd.enable [ mpc-cli ]
  ++ optionals (!flags.headless or false) [ spotify ]
  ++ optionals (flags.headless or true) [
  ];
    

}
