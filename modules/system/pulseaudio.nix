{ lib, config, pkgs, ...}:
with lib;
{
  config = {
    hardware.pulseaudio.enable = mkDefault true;
    hardware.pulseaudio.support32Bit = mkDefault true;
    hardware.pulseaudio.extraConfig = mkDefault "unload-module module-suspend-on-idle";
    nixpkgs.config.pulseaudio = mkDefault true;
  };
}

