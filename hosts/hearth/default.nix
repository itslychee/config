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
    fonts.enable = true;
    services = {
      openssh.enable = true;
      kmscon.enable = false;
      pipewire.enable = true;
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

  # do not touch ever! #
  system.stateVersion = "24.05";
}
