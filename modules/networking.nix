{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hey.net;
  inherit (lib) mkIf mkMerge mkEnableOption mkOption mkForce;
  inherit (lib.types) bool;
in {
  options.hey.net = {
    openssh = mkOption {
      type = bool;
      default = config.hey.caps.headless;
    };
    fail2ban = mkOption {
      type = bool;
      default = config.hey.caps.headless;
    };
    home = mkEnableOption "Home networking";
  };
  config = mkMerge [
    (mkIf cfg.home {
      age.secrets.wifi.file = ../secrets/wifi.age;

      # https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1658731959
      systemd.services.NetworkManager-wait-online.serviceConfig = {
        ExecStart = ["" "${pkgs.networkmanager}/bin/nm-online -q"];
      };
      networking.networkmanager = {
        unmanaged = [config.services.tailscale.interfaceName];
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
    })
    {
      services = {
        tailscale.enable = true;
        fail2ban = {
          enable = cfg.fail2ban;
          maxretry = 5;
          ignoreIP = ["::1" "127.0.0.1"];
          bantime = "24h";
        };
        # OpenSSH server
        openssh = {
          enable = cfg.openssh;
          authorizedKeysInHomedir = false;
          settings = {
            PasswordAuthentication = false;
          };
        };
      };

      # Convenience!
      networking.firewall.allowedTCPPorts = mkIf config.services.caddy.enable [80 443];
      # Convenience!
      networking.networkmanager.enable = true;
      programs.ssh = {
        startAgent = true;
        agentTimeout = "30m";
      };
      systemd.network.wait-online.ignoredInterfaces = [config.services.tailscale.interfaceName];
    }
  ];
}
