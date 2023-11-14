{ config, pkgs, modulesPath, ...}:
#
# Main desktop setup, I intend to keep this simple as possible
# as I prefer to keep my packages in my user environment.
#
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.kernelModules = [ "kvm-amd" ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "sd_mod" "sr_mod" ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
    consoleMode = "max";
  };
  boot.loader.timeout = 20;
  time.timeZone = "US/Central";
  time.hardwareClockInLocalTime = true;

  swapDevices = [ { device = "/dev/disk/by-label/Swap"; } ];
  fileSystems = {
    "/"     = { device = "/dev/disk/by-label/NixOS"; fsType = "ext4"; };
    "/boot" = { device = "/dev/disk/by-label/Boot"; fsType = "vfat"; };
    "/storage" = { device = "/dev/disk/by-label/Storage"; fsType = "ntfs"; };
  };
  hardware.cpu.amd.updateMicrocode = true;

  shell.zsh = true;
  system.sound = true;
  graphical.fonts.enable = true;
  graphical.fonts.defaults = true;
  graphical.enable = true;
  programs.dconf.enable = true;
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  servers.ssh.enable = true;
  servers.ssh.allowedUsers = [ "lychee" ];
  users.users.lychee = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "storage" "networkmanager" "adbusers" ];
  };
  environment.systemPackages = with pkgs; [ scrcpy ];
}
