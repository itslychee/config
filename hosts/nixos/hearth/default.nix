{pkgs, ...}: {
  boot = {
    kernelParams = ["irqpoll"];
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
    };
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) libreoffice nix-tree nixpkgs-review;
  };

  hardware = {
    bluetooth.enable = true;
    keyboard.qmk.enable = true;
  };

  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };

  programs.steam.enable = true;

  services.fstrim.enable = true;
  # do not touch ever! #
  system.stateVersion = "24.05";
}
