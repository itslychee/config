{pkgs, ...}: {
  boot = {
    kernelParams = ["irqpoll"];
    kernelPackages = pkgs.linuxKernel.packages.linux_6_9;
    loader.systemd-boot.enable = true;
    binfmt.emulatedSystems = ["aarch64-linux"];
  };

  services.syncthing.enable = true;

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
    inherit (pkgs) libreoffice nix-tree nixpkgs-review;
  };

  hardware = {
    bluetooth.enable = true;
    keyboard.qmk.enable = true;
  };

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  services.fstrim.enable = true;
  # do not touch ever! #
  system.stateVersion = "24.05";
}
