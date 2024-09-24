{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.hydra = {
    enable = true;
    port = 20001;
    hydraURL = "hydra.wires.cafe";
    notificationSender = "hydra@wires.cafe";
    useSubstitutes = true;
  };
  services.caddy = {
    enable = true;
    virtualHosts."hydra.wires.cafe".extraConfig = ''
      reverse_proxy http://[::1]:${toString config.services.hydra.port}
    '';
  };

  deployment.keys.attic-secret = {
    destDir = "/var/lib/secrets/hydra";
    keyCommand = [
      "gpg"
      "--decrypt"
      "${../../secrets/hydra-attic-key.gpg}"
    ];
  };

  systemd.services.hydra-watcher = {
    wantedBy = [
      "multi-user.target"
    ];
    requires = [ "atticd.service" ];
    path = [ pkgs.attic-client ];
    script = ''
      attic login wires https://cache.wires.cafe $TOKEN
      attic watch-store lychee-config
    '';
    serviceConfig = {
      EnvironmentFile = config.deployment.keys.attic-secret.path;
    };
  };

  hey.remote.use = true;
}
