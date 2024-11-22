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

  deployment.tags = [ "graphical" ];
  hey.roles.graphical = true;

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
  programs.wireshark.package = pkgs.wireshark-qt;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
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

  environment.systemPackages = with pkgs; [
    firefox
    colmena
    wl-clipboard
    swappy
    mpv
    celeste64
    attic-client
    remmina
  ];
}
