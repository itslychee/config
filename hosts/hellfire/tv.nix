{
  pkgs,
  lib,
  ...
}: {
  hey.caps.graphical = true;
  programs.wireshark.enable = lib.mkForce false;
  hey.programs.neovim.enable = false;

  # Disable lychee, she does not exist here!!
  hey.users.lychee.enable = lib.mkForce false;
  hey.users.viewer = {
    enable = true;
    groups = ["video" "audio" "input"];
  };

  services.xserver = {
    enable = true;
    displayManager.lightdm = {
      enable = true;
      extraSeatDefaults = ''
        autologin-user=viewer
        autologin-user-timeout=0
        autologin-session=kodi
      '';
    };
    desktopManager.kodi = {
      enable = true;
      package = pkgs.kodi-gbm;
    };
  };
}
