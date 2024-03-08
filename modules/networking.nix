{
  config,
  mylib,
  lib,
  ...
}: let
  cfg = config.hey.net;
  inherit (lib) mkIf mkMerge mkEnableOption;
in {
  options.hey.net = {
    openssh = mylib.mkDefaultOption;
    fail2ban = mylib.mkDefaultOption;
  };
  config = mkMerge [
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
        banner = "woe to all who try to enter!\n";
        settings = {
          PasswordAuthentication = false;
        };
      };
      boot.initrd.network.ssh.enable = true;
    })
    {
      programs.ssh = {
        startAgent = true;
        enableAskPassword = true;
        agentTimeout = "10m";
        knownHosts = {
          "pi.lan" = {
            extraHostNames = ["192.168.0.10"];
            publicKey = config.hey.keys.hosts.hellfire;
          };
          "hearth.lan" = {
            extraHostNames = ["192.168.0.3"];
            publicKey = config.hey.keys.hosts.hearth;
          };
          "lefishe.club" = {
            publicKey = config.hey.keys.hosts.wirescloud;
          };
        };
      };
    }
  ];
}