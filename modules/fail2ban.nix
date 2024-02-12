{ mylib, lib, config, ...}: let
  inherit (lib)
    mkIf
  ;
  cfg = config.hey.net.fail2ban;
in {
  options.hey.net = {
    fail2ban = {
      enable = mylib.mkDefaultOption;
    };
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
