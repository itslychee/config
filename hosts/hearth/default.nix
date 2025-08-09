{
  pkgs,
  inputs,
  config,
  ...
}:
{
  boot = {
    initrd.systemd.enable = true;
    loader.systemd-boot.enable = true;
    binfmt.emulatedSystems = [
      "aarch64-linux"
    ];
  };

  # boot = {
  #   # Driver issue (possibly linux-firmware issue)
  #   # https://bbs.archlinux.org/viewtopic.php?id=302000
  #   # https://gitlab.freedesktop.org/drm/amd/-/issues/3863
  #   #
  #   kernelParams = [
  #     "apic=verbose"
  #     "pcie_port_pm=off"
  #   ];
  #   blacklistedKernelModules = [ "rtw88_pci" ];
  #   kernel.sysctl."processor.max_cstate" = 1;
  # };

  hey = {
    graphical.games = true;
    hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILweHVDtBHYZg7ju64cHW7iEcEtaoGwYhYS1Fw1F6LsL";
    users.lychee = {
      groups = [
        "docker"
        "adbusers"
      ];
    };
  };

  services.fwupd.enable = true;
  programs.wireshark.enable = true;

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      nix-tree
      nixpkgs-review
      blender
      freecad
      act
      kicad
      naps2
      gimp
      libreoffice

      ;
  };
  programs.adb.enable = true;
  virtualisation.docker.enable = true;
  services.printing = {
    enable = true;
    startWhenNeeded = false;
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
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

  # services.xserver = {
  #   enable = true;
  #   displayManager.gdm.enable = true;
  #   desktopManager.gnome.enable = true;
  # };

  # NOTE: Leave this, this seems to fix the issues with the current set kernel such as but not limited to:
  # - Stuttering app performance
  # - Elite Dangerous doesn't want to run
  # - Bad audio
  # boot.kernelPackages =
  #   inputs.nixpkgs-24-11.legacyPackages.${config.nixpkgs.hostPlatform.system}.linuxPackages_latest;

  services.fstrim.enable = true;

  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  # hey.remote.use = true;

}
