{
  pkgs,
  inputs,
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

  virtualisation.libvirtd.qemu.swtpm.enable = true;

  services.fwupd.enable = true;
  programs.wireshark.enable = true;

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs.kdePackages) konsole;
    inherit (pkgs)
      nix-tree
      virt-viewer
      virt-manager
      tigervnc
      inetutils
      android-tools
      nixpkgs-review
      blender
      freecad
      act
      kicad
      naps2
      gimp
      libreoffice
      minicom
      vesktop
      ;
    inherit (inputs.unstable.legacyPackages.x86_64-linux) gns3-gui;
  };
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
  services.gns3-server =
    let
      inherit (inputs.unstable.legacyPackages.x86_64-linux)
        gns3-server
        dynamips
        vpcs
        ubridge
        ;
    in
    {
      enable = true;
      package = gns3-server;
      dynamips.enable = true;
      dynamips.package = dynamips;
      vpcs.enable = true;
      vpcs.package = vpcs;
      ubridge.enable = true;
      ubridge.package = ubridge;
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

  services.fstrim.enable = true;

  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  # hey.remote.use = true;

}
