{
  pkgs,
  lib,
  ...
}: {
  hey.caps.graphical = true;
  programs.wireshark.enable = lib.mkForce false;
  services.xserver = {
    enable = true;
    desktopManager.kodi = {
      package = pkgs.kodi-wayland;
      enable = true;
    };

    displayManager = {
      defaultSession = "kodi";
      lightdm = {
        enable = true;
        autoLogin.timeout = 1;
      };
    };
  };
}
