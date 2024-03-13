{
  pkgs,
  lib,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot = {
    kernelParams = ["irqpoll"];
    loader.systemd-boot.enable = true;
    binfmt.emulatedSystems = ["aarch64-linux"];
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  hey = {
    net.home = true;
    graphical.enable = true;
    users.lychee = {
      enable = true;
      wms.sway.enable = true;
      packages = [
        pkgs.firefox
        pkgs.xdg-utils
        pkgs.qbittorrent
        (pkgs.discord-canary.override {
          withVencord = true;
          withOpenASAR = true;
        })
      ];
    };
  };
  networking = {
    firewall = {
      allowedTCPPorts = [1113];
      allowedUDPPorts = [1113];
    };

  };

  hardware = {
      bluetooth.enable = true;
      keyboard.qmk.enable = true;
      opengl.extraPackages = [ pkgs.amdvlk ];
  };
  environment.systemPackages = [
    (pkgs.lutris.override {extraPkgs = p: [p.winetricks p.wineWowPackages.waylandFull];})
    pkgs.gnome3.adwaita-icon-theme
    pkgs.bluez-tools
  ];

  # https://github.com/lwfinger/rtw88/issues/61
  # "Fix" the kernel log spam for "h2c command failed" or whatever
  environment.etc."modprobe.d/rtw88_8821ce.conf".text = ''
    options rtw88_core disable_lps_deep=y
    options rtw88_pci disable_msi=y disable_aspm=y
    options rtw_core disable_lps_deep=y
    options rtw_pci disable_msi=y disable_aspm=y
  '';

  # nix-index
  environment.sessionVariables.NIX_INDEX_DATABASE = "/var/lib/nix-index-db";
  programs.nix-index.enable = true;

  # do not touch ever! #
  system.stateVersion = "24.05";
}
