{
  config,
  mylib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  hey = {
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
         prefixes.v4 = "1.0.0.0/24";
      };
  };

  services.caddy = {
      enable = true;
      virtualHosts."scaley.lefishe.club".extraConfig = ''
          reverse_proxy ${config.services.headscale.address}:${toString config.services.headscale.port}
      '';
  };

  # do not change
  system.stateVersion = "23.05";
}
