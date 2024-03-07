{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [./hardware-configuration.nix];

  age.secrets.wifi.file = "${inputs.self}/secrets/wifi.age";
  boot = {
    kernelParams = ["irqpoll"];
    loader.systemd-boot.enable = true;
    binfmt.emulatedSystems = ["aarch64-linux"];
  };

  services = lib.genAttrs ["sonarr" "radarr" "jellyfin"] (name: {
    enable = true;
    openFirewall = true;
  });

  hey = {
    graphical.enable = true;
    services = {
      openssh.enable = true;
      kmscon.enable = false;
    };

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
    networkmanager = {
      enable = true;
      ensureProfiles = {
        environmentFiles = [config.age.secrets.wifi.path];
        profiles.homeWifi = {
          connection.type = "wifi";
          connection.id = "$SSID";
          wifi.ssid = "$SSID";
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$PASSWORD";
          };
        };
      };
    };
  };

  hardware.opengl.extraPackages = [pkgs.amdvlk];
  hardware.bluetooth.enable = true;
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
