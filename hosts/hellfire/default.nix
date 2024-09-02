{
  config,
  modulesPath,
  lib,
  ...
}: {
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
  ];
  deployment = {
    allowLocalDeployment = lib.mkForce false;
    buildOnTarget = lib.mkForce false;
  };

  fileSystems."/".options = ["noatime"];

  boot = {
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    initrd.availableKernelModules = ["xhci_pci" "usbhid" "usb_storage"];
    blacklistedKernelModules = ["bluetooth"];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  sdImage = {
    imageBaseName = config.networking.hostName;
    compressImage = false;
  };
  # A server does not need this to be on anyways
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  # remove this when u get  stability
  services.openssh.openFirewall = true;

  hey = {
    hostKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDmFBbxUjTO+yjrJOe4FnJtp0vojVy2xQ5thgaNsJxAF"
    ];
  };

  systemd.network = {
    enable = true;
    networks.bridge = {
      enable = true;
      matchConfig.Name = "end0";
      networkConfig = {
        Address = "10.0.1.1/24";
      };
    };
  };

  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;
    settings = {
      interface = "end0";
      server = ["1.1.1.1" "1.0.0.1"];
    };
  };

  networking.firewall.interfaces.end0 = {
    allowedUDPPorts = [67];
  };

  # do not touch #
  system.stateVersion = "24.05";
}
