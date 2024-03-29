{
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.hey.net;
  inherit (lib) mkIf mkMerge mkEnableOption mkOption;
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
      age.secrets.wifi.file = "${inputs.self}/secrets/wifi.age";
      networking.networkmanager = {
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
    })
    (mkIf cfg.fail2ban {
      services.fail2ban = {
        enable = true;
        maxretry = 5;
        ignoreIP = ["::1" "127.0.0.1"];
        bantime = "24h";
      };
    })
    (mkIf cfg.openssh {
      # OpenSSH server
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
        };
      };
      boot.initrd.network.ssh.enable = true;
    })
    (mkIf config.services.caddy.enable {
      networking.firewall.allowedTCPPorts = [80 443];
    })
    {
      programs.ssh = {
        startAgent = true;
        agentTimeout = "30m";
        knownHosts = {
          "pi.lan" = {
            extraHostNames = [ "hellfire"];
            publicKey = config.hey.keys.hosts.hellfire;
          };
          "hearth.lan" = {
            extraHostNames = [ "hearth"];
            publicKey = config.hey.keys.hosts.hearth;
          };
          "lefishe.club" = {
            extraHostNames = ["wirescloud"];
            publicKey = config.hey.keys.hosts.wirescloud;
          };
          "wiretop".publicKey = config.hey.keys.hosts.wiretop;
        };
      };

      services.tailscale = {
        enable = true;
        extraUpFlags = [
          "--login-server=https://scaley.lefishe.club"
        ];
      };
    }
  ];
}
