# Shared nixos module among ALL hosts
{ pkgs, config, ... }:
{
  config = {
    boot.tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
      tmpfsSize = "30%";
    };
    nixpkgs.config.allowUnfree = true;
    nix = {
      settings.auto-optimise-store = true;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      gc = {
        persistent = true;
        automatic = true;
        options = "-d --delete-older-than 10d";
        dates = "daily";
      };
      optimise = {
        automatic = true;
        dates = [ "1:00" ];
      };
    };
  };
}
