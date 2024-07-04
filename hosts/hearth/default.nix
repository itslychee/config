{
  pkgs,
  config,
  ...
}: {
  boot = {
    kernelParams = ["irqpoll"];
    kernelPackages = pkgs.linuxKernel.packages.linux_6_9;
    loader.systemd-boot.enable = true;
    binfmt.emulatedSystems = ["aarch64-linux"];
  };

  hey = {
    hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOaAxiB8BtVJC+3WM/ydH+8CRaINbE+7X3aO1l/0cJhV";
    caps = {
      graphical = true;
      headless = true;
    };
    users.lychee = {
      state = "24.05";
      groups = ["docker"];
      wms.sway.enable = true;
    };
  };

  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      libreoffice
      nix-tree
      nixpkgs-review
      ;
  };

  hardware = {
    bluetooth.enable = true;
    keyboard.qmk.enable = true;
  };

  services.fstrim.enable = true;

  programs = {
    nix-index.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
  };

  environment.sessionVariables.NIX_INDEX_DATABASE = "/var/lib/nix-index-db";
  # do not touch ever! #
  system.stateVersion = "24.05";
}
