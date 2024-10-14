{ pkgs, ... }:
{
  boot = {
    kernelParams = [ "irqpoll" ];
    loader.systemd-boot.enable = true;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  hey = {
    hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOaAxiB8BtVJC+3WM/ydH+8CRaINbE+7X3aO1l/0cJhV";
    users.lychee = {
      groups = [
        "docker"
        "adbusers"
      ];
    };
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      nix-tree
      nixpkgs-review
      winetricks
      vesktop
      android-studio
      ;
    inherit (pkgs.wineWowPackages) stable;
    inherit (pkgs.jetbrains) idea-community;
  };
  programs.adb.enable = true;

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

  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  networking.firewall.trustedInterfaces = [ "virbr0" ];
  # hey.remote.use = true;

  system.stateVersion = "24.05";
}
