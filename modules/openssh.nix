{
  config,
  mylib,
  lib,
  ...
}: let
  cfg = config.hey.services.openssh;
  inherit (lib) mkIf mkMerge mkEnableOption;
in {
  options = {
    hey.services.openssh.enable = mkEnableOption "OpenSSH Server";
  };
  config = mkMerge [
    (mkIf cfg.enable {
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
