{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hey.net;
  inherit
    (lib)
    mkIf
    mkMerge
    mkEnableOption
    mkOption
    mkForce
    ;
  inherit
    (lib.types)
    bool
    str
    either
    listOf
    ;
in {
  options.hey = {
    hostKeys = mkOption {
      type = either str (listOf str);
      apply = f:
        if builtins.typeOf f == "string"
        then [f]
        else f;
      description = "SSH public key for host, preferably ed25519";
    };
    net = {
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
  };
  config = mkMerge [
    (mkIf cfg.home {
      # https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1658731959
      systemd.services.NetworkManager-wait-online.serviceConfig = {
        ExecStart = ["" "${pkgs.networkmanager}/bin/nm-online -q"];
      };
      networking.networkmanager.unmanaged = [config.services.tailscale.interfaceName];
    })
    {
      services = {
        tailscale = {
          enable = true;
          useRoutingFeatures = "both";
          openFirewall = true;
        };
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
        extraConfig = ''
          Host big-floppa
            User student
        '';
      };
      systemd.network.wait-online.ignoredInterfaces = [config.services.tailscale.interfaceName];
    }
  ];
}
