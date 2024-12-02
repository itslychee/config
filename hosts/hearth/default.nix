{ pkgs, ... }:
{
  boot = {
    kernelParams = [ "irqpoll" ];
    loader.systemd-boot.enable = true;
    binfmt.emulatedSystems = [
      "aarch64-linux"
    ];
  };

  hey = {
    graphical.games = true;
    hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOaAxiB8BtVJC+3WM/ydH+8CRaINbE+7X3aO1l/0cJhV";
    users.lychee = {
      groups = [
        "docker"
        "adbusers"
      ];
    };
  };

  programs.wireshark.enable = true;

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      nix-tree
      vesktop
      nixpkgs-review
      winetricks
      # android-studio
      act
      ;
  };
  programs.adb.enable = true;
  virtualisation.docker.enable = true;

  hardware = {
    bluetooth.enable = true;
    keyboard.qmk.enable = true;
  };

  networking.networkmanager.enable = true;

  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = true;
  };
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.fstrim.enable = true;

  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  # hey.remote.use = true;

}
