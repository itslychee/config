{
  config,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  hey = {
    caps.headless = true;
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

  services = {
    # use as vpn exit node
    tailscale.extraUpFlags = ["--advertise-exit-node"];

    headscale = {
      enable = true;
      settings = {
        server_url = "https://scaley.lefishe.club:443";
      };
    };

    caddy = let
      head = config.services.headscale;
    in {
      enable = true;
      virtualHosts.${head.settings.server_url}.extraConfig = ''
        reverse_proxy http://${head.address}:${toString head.port}
      '';
    };
    terraria = {
      openFirewall = true;
      messageOfTheDay = "wires";
      maxPlayers = 10;
      enable = true;
      autoCreatedWorldSize = "large";
    };
  };

  # do not change
  system.stateVersion = "23.05";
}
