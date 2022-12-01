{ config, pkgs, ...}:
with pkgs.lib;
{
  config.nix = {
    settings.auto-optimise-store = mkDefault true;
    gc = {
      persistent = mkDefault true;
      automatic = mkDefault true;
      options = mkDefault "-d --delete-older-than 10d";
      dates = mkDefault "5d";
    };
    optimise = {
      automatic = mkDefault true;
      dates = mkDefault [ "6d" ];
    };
    package = mkDefault pkgs.nixFlakes;
    extraOptions = mkDefault ''
      experimental-features = nix-command flakes
    '';
  };
}
