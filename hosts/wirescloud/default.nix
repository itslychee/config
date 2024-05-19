{
  config,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.attic.nixosModules.atticd
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

  age.secrets.atticd.file = ../../secrets/atticd.age;

  services = {
    # use as vpn exit node
    tailscale.extraUpFlags = ["--advertise-exit-node"];

    atticd = {
      enable = true;
      credentialsFile = config.age.secrets.atticd.path;
      settings = {
        listen = "[::1]:4000";
        chunking = {
          nar-size-threshold = 64 * 1024; # 64 KiB
          min-size = 16 * 1024; # 16 KiB
          avg-size = 64 * 1024; # 64 KiB
          max-size = 256 * 1024; # 256 KiB
        };
      };
    };
    headscale = {
      enable = true;
      settings.server_url = "https://scaley.lefishe.club:443";
    };

    caddy = let
      head = config.services.headscale;
      attic = config.services.atticd.settings;
    in {
      enable = true;
      virtualHosts = {
        ${head.settings.server_url}.extraConfig = ''
          reverse_proxy http://${head.address}:${toString head.port}
        '';
        "attic.lefishe.club".extraConfig = ''
          reverse_proxy http://${attic.listen}
        '';
      };
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
