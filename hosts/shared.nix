# Shared nixos module among ALL hosts
{ pkgs, config, ... }:
{
  boot.tmp.useTmpfs = true;
  boot.tmp.cleanOnBoot = true;
  boot.tmp.tmpfsSize = "30%";
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      auto-optimise-store = true;
      trusted-users = ["@wheel" "root" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc.persistent = true;
    gc.automatic = true;
    gc.options = "-d --delete-older-than 10d";
    gc.dates = "2d";
    optimise.automatic = true;
    optimise.dates = [ "weekly" ];
    channel.enable = false;
  };
  
}
