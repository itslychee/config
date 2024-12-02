{
  config,
  nodes,
  lib,
  ...
}:
let
  inherit (lib) singleton mapAttrsToList filterAttrs;
  generateStaticConfigs =
    {
      static_configs,
      pred,
      job_name,
    }:
    singleton {
      inherit job_name;
      static_configs = mapAttrsToList (hostname: cfg: (static_configs hostname cfg.config)) (
        filterAttrs pred nodes
      );
    };
in
{
  # Caddy reverse proxy!
  services.caddy.enable = true;
  services.grafana = {
    enable = true;
    settings = {
      server.root_url = "https://grafana.wires.cafe";
    };
    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          url = "http://[::1]:${toString config.services.prometheus.port}";
          type = "prometheus";
        }
        {
          name = "Loki";
          url = "http://[::1]:${toString config.services.loki.configuration.server.http_listen_port}";
          type = "loki";
        }
      ];
    };
  };

  # Loki logging server
  services.loki = {
    enable = true;

    configuration = {
      auth_enabled = false;
      server.http_listen_port = 20500;
      common = {
        ring = {
          instance_addr = "127.0.0.1";
          kvstore = {
            store = "inmemory";
          };
        };
        replication_factor = 1;
        path_prefix = "/tmp/loki";
      };

      schema_config = {
        configs = lib.singleton {
          from = "2024-12-01";
          store = "tsdb";
          object_store = "filesystem";
          schema = "v13";
          index = {
            prefix = "index_";
            period = "24h";
          };
        };
      };
      storage_config = {
        tsdb_shipper = {
          active_index_directory = "/tmp/loki/index";
          cache_location = "/tmp/loki/index_cache";
        };
        filesystem.directory = "/tmp/loki/chunks";

      };
    };
    extraFlags = [
      "-config.expand-env=true"
    ];
  };

  # Prometheus metrics server
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
      }
      # Garage exporter
      ++ generateStaticConfigs {
        pred =
          _n: v:
          v.config.services.garage.enable
          && v.config.services.garage ? settings
          && v.config.services.garage.settings ? admin;
        job_name = "garage";
        static_configs = hostname: _cfg: {
          targets = singleton "${hostname}:3902";
        };
      };
  };

  services.caddy.virtualHosts =
    let
      grafana = config.services.grafana.settings.server;
    in
    {
      "grafana.wires.cafe".extraConfig = ''
        reverse_proxy http://${grafana.http_addr}:${toString grafana.http_port}
      '';
    };
}
