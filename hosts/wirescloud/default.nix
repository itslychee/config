{
  config,
  inputs,
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

  age.secrets = {
    wiresconfig.file = "${inputs.self}/secrets/wiresbot.age";
    terraria.file = "${inputs.self}/secrets/terraria.age";
  };
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
      config = config.age.secrets.wiresconfig.path;
    };
    terraria = {
      password = "$Password";
      openFirewall = true;
      messageOfTheDay = "wires";
      maxPlayers = 10;
      enable = true;
      autoCreatedWorldSize = "large";
    };
  };

  systemd.services.terraria.serviceConfig = {
    EnvironmentFile = config.age.secrets.terraria.path;
  };

  # do not change
  system.stateVersion = "23.05";
}
