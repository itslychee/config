{
  pkgs,
  config,
  ...
}: {
  boot = {
    kernelParams = ["irqpoll"];
    loader.systemd-boot.enable = true;
    binfmt.emulatedSystems = ["aarch64-linux"];
  };

  hey = {
    caps = {
      graphical = true;
      headless = true;
    };
    net.home = true;
    users.lychee = {
      state = "24.05";
      sshKeys = config.hey.keys.users.lychee.local_ssh;
      wms.sway = {
        enable = true;
        outputs.HDMI-A-1 = {
          mode = "1920x1080@144.001Hz";
          adaptive_sync = "on";
        };
      };
    };
  };
  networking.firewall = {
    allowedTCPPorts = [1113];
    allowedUDPPorts = [1113];
  };

  hardware = {
    bluetooth.enable = true;
    keyboard.qmk.enable = true;
  };
  environment.systemPackages = [pkgs.bluez-tools pkgs.okular];

  # SSD trimming
  services.fstrim.enable = true;

  # nix-index
  environment.sessionVariables.NIX_INDEX_DATABASE = "/var/lib/nix-index-db";
  programs.nix-index.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # do not touch ever! #
  system.stateVersion = "24.05";
}
