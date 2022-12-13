{ pkgs, lib, config, ...}:
with lib;
{
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
    desktopManager.plasma5.excludePackages = with pkgs.libsForQt5; [
      plasma-browser-integration
      print-manager
      konsole
      elisa
      khelpcenter
    ];

  };

}
