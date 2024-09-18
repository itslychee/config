{
  pkgs,
  lib,
  ...
}: {
  imports = lib.fileset.toList (lib.fileset.difference ./. ./default.nix);

  deployment.tags = ["graphical"];
  hey.roles.graphical = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-qt;
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
  ];
}
