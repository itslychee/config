{ config, lib, pkgs, ...}:
{
  imports = [
    (import ../../mixins/openssh.nix { allowedUsers = [ "lychee"]; })
    ../../mixins/hardware.nix
    ../../mixins/security.nix
    ../../mixins/systemd-boot.nix
    ../../mixins/pipewire.nix
    ../../mixins/fonts.nix
  ];
  networking = {
    hostName = "embassy";
    firewall.enable = true;
    networkmanager.enable = true;
    networkmanager.enableFccUnlock = true;
  };

  time.hardwareClockInLocalTime = true;
  time.timeZone = "US/Central";

  # Users
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
  environment.systemPackages = with pkgs; [ neovim scrcpy ];
}
