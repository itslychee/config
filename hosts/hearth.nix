{
  config,
  pkgs,
  modulesPath,
  ...
}: {
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  hardware.cpu.amd.updateMicrocode = true;
  
  virtualisation.libvirtd.enable = true;
  environment.systemPackages = with pkgs; [ 
    virt-manager
    zathura
  ];
  boot = {
    kernelModules = ["kvm-amd"];
    kernelParams = ["irqpoll"];
    initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "sd_mod" "sr_mod"];
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

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NixOS";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/Boot";
      fsType = "vfat";
    };
    "/storage" = {
      device = "/dev/disk/by-label/Storage";
      fsType = "ntfs";
    };
  };

  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
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

  hardware.keyboard.qmk.enable = true;

  # SSH
  servers.ssh.enable = true;
  servers.ssh.allowedUsers = ["lychee"];
  # Users
  users.users.lychee = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ["libvirtd" "wheel" "storage" "networkmanager" "adbusers"];
  };
}
