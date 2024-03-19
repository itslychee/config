{config, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  hey = {
    caps.headless = true;
    users.lychee.enable = true;
    services = {
      matrix = {
        enable = true;
        serverName = "lefishe.club";
        matrixHostname = "matrix.lefishe.club";
        elementHostname = "element.lefishe.club";
      };
      vault = {
        enable = true;
        domain = "vault.lefishe.club";
      };
      website = {
        enable = true;
        domain = "lefishe.club";
      };
    };
  };

  services.headscale = {
    enable = true;
    settings = {
      server_url = "https://scaley.lefishe.club:443";
      # headscale shouldn't be handling DNS beyond the tailnet
      dns_config.nameservers = [];
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts."scaley.lefishe.club".extraConfig = ''
      reverse_proxy http://${config.services.headscale.address}:${toString config.services.headscale.port}
    '';
  };

  # do not change
  system.stateVersion = "23.05";
}
