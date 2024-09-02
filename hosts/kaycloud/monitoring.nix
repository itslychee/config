{
  config,
  nodes,
  lib,
  ...
}: let
  inherit (lib) singleton mapAttrsToList filterAttrs;
  generateStaticConfigs = {
    static_configs,
    pred,
    job_name,
  }:
    singleton {
      inherit job_name;
      static_configs = mapAttrsToList (
        hostname: cfg: (static_configs hostname cfg.config)
      ) (filterAttrs pred nodes);
    };
in {
  # Caddy reverse proxy!
  services.caddy.enable = true;
  services.grafana = {
    enable = true;
    settings = {
      server.domain = "grafana.wires.cafe";
    };
    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus (Personal)";
          url = "http://[::1]:${toString config.services.prometheus.port}";
          type = "prometheus";
        }
      ];
    };
  };

  services.prometheus = {
    enable = true;
    scrapeConfigs =
      # Node exporter
      generateStaticConfigs {
        pred = _n: v: v.config.services.prometheus.exporters.node.enable;
        job_name = "Nodes";
        static_configs = hostname: cfg: {
          targets = singleton "${hostname}:${toString cfg.services.prometheus.exporters.node.port}";
        };
      };
    # ++
    # Garage exporter
    # generateStaticConfigs {
    #   pred = _n: v: v.config.services.garage.enable && v.config.services.garage ? settings && v.config.services.garage.settings ? admin;
    #   job_name = "Garage S3";
    #   static_configs = _hostname: cfg: {
    #     targets = singleton (toString cfg.services.garage.settings.admin.api_bind_addr);
    #   };
    # };
  };

  services.caddy.virtualHosts = let
    grafana = config.services.grafana.settings.server;
  in {
    "grafana.wires.cafe".extraConfig = ''
      reverse_proxy http://${grafana.http_addr}:${toString grafana.http_port}
    '';
  };
}
