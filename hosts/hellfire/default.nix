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
        IPMasquerade = "both";
        Bridge = config.services.tailscale.interfaceName;
      };
    };
  };

  networking.firewall.interfaces.end0 = {
    allowedUDPPorts = [67];
  };

  # do not touch #
  system.stateVersion = "24.05";
}
