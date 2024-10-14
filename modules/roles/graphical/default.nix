{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (inputs) spicetify-nix;
  spkgs = spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = lib.fileset.toList (lib.fileset.difference ./. ./default.nix) ++ [
    spicetify-nix.nixosModules.default
  ];

  programs.spicetify = {
    enable = true;
    theme = spkgs.themes.bloom;
    colorScheme = "Coffee";
    enabledExtensions = builtins.attrValues {
      inherit (spkgs.extensions)
        adblock
        playlistIcons
        fullAlbumDate
        hidePodcasts
        trashbin
        shuffle
        autoSkipVideo
        ;
    };
  };

  deployment.tags = [ "graphical" ];
  hey.roles.graphical = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };
  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true;
  };

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };

  environment.systemPackages = [
    pkgs.firefox
    pkgs.colmena
    pkgs.wl-clipboard
    pkgs.swappy
    pkgs.mpv
    pkgs.celeste64
    inputs.attic.packages.${pkgs.system}.attic
  ];
}
