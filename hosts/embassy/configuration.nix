{ config, lib, pkgs, ...}:
{
  imports = [
    (import ../../mixins/networking.nix { hostName = "embassy"; })
    (import ../../mixins/openssh.nix { allowedUsers = [ "lychee"]; })
    ../../mixins/hardware.nix
    ../../mixins/security.nix
    ../../mixins/systemd-boot.nix
    ../../mixins/pipewire.nix
    ../../mixins/fonts.nix
  ];
  
  # To preserve Windows time, as a registry edit on that side would probably
  # be very unstable because, y'know, Windows.
  time.hardwareClockInLocalTime = true;
  time.timeZone = "US/Central";
  users.users = {
    lychee = {
      isNormalUser = true;
      extraGroups = [ "wheel" "storage" "networkmanager" "adbusers" ];
      openssh.authorizedKeys.keyFiles = [ ../../keys.pub ];
    };
  };
  # System wide programs
  programs.dconf.enable = true;
  programs.adb.enable = true;
  # Enable SSH agent
  programs.ssh.startAgent = true;
  programs.ssh.agentTimeout = "20m";

  services.udisks2.enable = true;

  # 1TB storage for games and music
  fileSystems."/storage" = {
    device = "/dev/disk/by-label/Storage";
    fsType = "ntfs";
  };
  # System packages
  environment.systemPackages = with pkgs; [ neovim ];
}
