{
  pkgs,
  inputs,
  config,
  ...
}:
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
      nixpkgs-review
      winetricks
      libreoffice
      # android-studio
      act
      ;
    discord = (
      pkgs.discord.override {
        withVencord = true;
        withOpenASAR = true;
      }
    );
  };
  programs.adb.enable = true;
  virtualisation.docker.enable = true;
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

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
  # NOTE: Leave this, this seems to fix the issues with the current set kernel such as but not limited to:
  # - Stuttering app performance
  # - Elite Dangerous doesn't want to run
  # - Bad audio
  boot.kernelPackages =
    inputs.nixpkgs-24-05.legacyPackages.${config.nixpkgs.hostPlatform.system}.linuxPackages_latest;

  services.fstrim.enable = true;

  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  # hey.remote.use = true;

}
