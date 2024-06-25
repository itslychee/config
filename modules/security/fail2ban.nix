{
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  services.fail2ban = {
    enable = mkDefault config.hey.caps.headless;
    maxretry = 5;
    ignoreIP = [
      "::1"
      "127.0.0.1"
      "100.0.0.0/8"
    ];
    bantime = "24h";
  };
}
