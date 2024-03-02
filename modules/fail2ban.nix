{
  lib,
  config,
  ...
}: let
  inherit
    (lib)
    mkIf
    mkEnableOption
    ;
  cfg = config.hey.services.fail2ban;
in {
  options.hey.services = {
    fail2ban.enable = mkEnableOption "Fail2Ban";
  };
  config = mkIf cfg.enable {
    services.fail2ban = {
      enable = true;
      maxretry = 5;
      ignoreIP = [
        "::1"
        "127.0.0.1"
      ];
      bantime = "24h";
    };
  };
}
