{ config, ... }:
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

  hey.remote.use = true;
}
