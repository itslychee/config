{ config, pkgs, modulesPath, ...}:
{
  hardware.cpu.amd.updateMicrocode = true;
  boot = {
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = with pkgs; [ rtw88-firmware ];
    kernelParams = [ "irqpoll" ];
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "sd_mod" "sr_mod" ];
    loader.efi.canTouchEfiVariables = true;
    loader.timeout = 20;
    loader.systemd-boot = {
      enable = true;
      editor = false;
      consoleMode = "max";
    };
  };
  time.timeZone = "US/Central";
  time.hardwareClockInLocalTime = true;

  swapDevices = [ { device = "/dev/disk/by-label/Swap"; } ];
  fileSystems = {
    "/" = { 
      device = "/dev/disk/by-label/NixOS"; fsType = "ext4";
    };
    "/boot" = { 
      device = "/dev/disk/by-label/Boot";  fsType = "vfat"; 
    };
    "/storage" = { 
      device = "/dev/disk/by-label/Storage"; fsType = "ntfs";
    };
  };

  shell.fish = true;
  system.sound = true;
  graphical = {
    fonts.enable = true;
    fonts.defaults = true;
    enable = true;
  };
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # SSH Agent
  programs.ssh = {
    startAgent = true;
    agentTimeout = "1h";
  };


  services.gnome.at-spi2-core.enable = true;
  # SSH 
  servers.ssh.enable = true;
  servers.ssh.allowedUsers = [ "lychee" ];
  # Users
  users.users.lychee = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "storage" "networkmanager" "adbusers" ];
  };
}
