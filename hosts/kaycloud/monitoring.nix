{
  config,
  nodes,
  lib,
  ...
}: {
  # Caddy reverse proxy!
  services.caddy.enable = true;
  services.grafana = {
    enable = true;
    settings = {
      server.domain = "grafana.wires.cafe";
    };
    provision = {
      enable = true;
      datasources.settings.datasources = lib.singleton {
        name = "Prometheus (Personal Infra)";
        url = "http://[::1]:${toString config.services.prometheus.port}";
        type = "prometheus";
      };
    };
  };

  services.prometheus = {
    enable = true;
    scrapeConfigs =
      lib.mapAttrsToList (name: value: {
        job_name = name;
        static_configs = lib.singleton {
          targets = ["${name}:${toString value.config.services.prometheus.exporters.node.port}"];
        };
      })
      nodes;
  };

  services.caddy.virtualHosts = let
    grafana = config.services.grafana.settings.server;
  in {
    "grafana.wires.cafe".extraConfig = ''
      reverse_proxy http://${grafana.http_addr}:${toString grafana.http_port}
    '';
  };
}
