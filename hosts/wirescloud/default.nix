{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.wiresbot.nixosModule
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  hey = {
    caps.headless = true;
    users.lychee = {
      state = "24.05";
      enable = true;
    };
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


  age.secrets.wiresconfig.file = "${inputs.self}/secrets/wiresbot.age";
  services = {
      headscale = {
        enable = true;
        settings = {
          server_url = "https://scaley.lefishe.club:443";
          # headscale shouldn't be handling DNS beyond the tailnet
          dns_config.nameservers = [];
        };
      };

      caddy = {
        enable = true;
        virtualHosts."scaley.lefishe.club".extraConfig = ''
          reverse_proxy http://${config.services.headscale.address}:${toString config.services.headscale.port}
        '';
      };
      wiresbot = {
        enable = true;
        package = inputs.wiresbot.packages.${pkgs.system}.default;
        config = config.age.secrets.wiresconfig.path;
      };
  };


  # do not change
  system.stateVersion = "23.05";
}
