{
  inputs,
  pkgs,
  lib,
  ...
}:
{

  deployment.tags = [ "graphical" ];
  hey.roles.graphical = true;
  imports = lib.fileset.toList (lib.fileset.difference ./. ./default.nix);

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
  services.pcscd.enable = true;

  environment.systemPackages = with pkgs; [
    inputs.colmena.packages.${pkgs.system}.colmena
    wl-clipboard
    mpv
    remmina
  ];
}
