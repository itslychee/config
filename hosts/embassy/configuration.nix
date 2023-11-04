{ config, lib, pkgs, ...}:
{
  # Mixins
  imports = [
    (import ../../mixins/openssh.nix { allowedUsers = [ "lychee"]; })
    ../../mixins/hardware.nix
    ../../mixins/security.nix
    ../../mixins/systemd-boot.nix
    ../../mixins/pipewire.nix
    ../../mixins/fonts.nix
  ];
  time.hardwareClockInLocalTime = true;
  time.timeZone = "US/Central";
  boot.kernelParams = [ "irqpoll" ];
  networking = {
    hostName = "embassy";
    firewall.enable = true;
    networkmanager.enable = true;
    networkmanager.enableFccUnlock = true;
  };

  users.users.lychee = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "storage" "networkmanager" "adbusers" ];
    openssh.authorizedKeys.keyFiles = [ ../../keys.pub ];
  };

  users.users.remote-builder = {
    homeMode = "500";
    description = "Nix remote builder";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM9I9jEia435ZUBT85/l3zg4HgSgKOty/29foPmIkV/O pi@nixos"
    ];
    createHome = true;
    extraGroups = [ "nologin" ];
    isNormalUser = true;
    openssh.authorizedKeys.keyFiles = [ ../../keys.pub ];
  };


  # System wide programs
  programs.dconf.enable = true;
  programs.adb.enable = true;
  # Enable SSH agent
  programs.ssh.startAgent = true;
  programs.ssh.agentTimeout = "1h";

  # Zsh config
  environment.pathsToLink = [ "/share/zsh" ];
  programs.zsh.enable = true;
  # Services
  services.udisks2.enable = true;

  # Swaylock privileges
  security.pam.services.swaylock.text = ''
    auth include login
  '';

  # Internal storage devices
  fileSystems."/storage" = {
    device = "/dev/disk/by-label/Storage";
    fsType = "ntfs";
  };
  # System packages
  environment.systemPackages = with pkgs; [ neovim scrcpy ];
}
