{ config, pkgs, ...}:
with pkgs.lib;
{
  config.system.autoUpgrade = mkDefault {
    flake = "github:itslychee/dotfiles";
    enable = true;
    dates = "1h";
  };
}
