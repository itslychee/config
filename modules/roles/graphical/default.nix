{
  inputs,
  pkgs,
  ...
}:
{

  deployment.tags = [ "graphical" ];
  hey.roles.graphical = true;

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
    inputs.wire.packages.${pkgs.system}.default
    wl-clipboard
    mpv
    remmina
  ];
}
