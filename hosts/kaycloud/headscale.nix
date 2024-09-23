{ config, ... }:
{

  networking.firewall.allowedUDPPorts = [ 3478 ];

  services.headscale = {
    enable = true;
    settings = {
      derp.server = {
        enabled = true;
        stun_listen_addr = "0.0.0.0:3478";
      };
      dns = {
        base_domain = "wires.cafe";
        nameservers.global = [
          "1.1.1.1"
          "1.0.0.1"
          "2606:4700:4700::1111"
          "2606:4700:4700::1001"
        ];
      };
      server_url = "https://control.wires.cafe";
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts."control.wires.cafe".extraConfig = ''
      reverse_proxy ${config.services.headscale.settings.listen_addr}
    '';
  };
}
