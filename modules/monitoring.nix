{ config, nodes, ... }:
{

  services.promtail = {
    enable = true;
    configuration = {
      clients =
        let
          kc = nodes.kaycloud.config;
        in
        [
          {
            url = "http://${kc.networking.hostName}:${toString kc.services.loki.configuration.server.http_listen_port}/loki/api/v1/push";
            tenant_id = config.networking.hostName;
          }
        ];
      server = {
        http_listen_port = 20000;
        grpc_listen_port = 0;
      };
      scrape_configs = [
        {
          job_name = "systemd-journal";

          relabel_configs = [
            {
              source_labels = [ "__journal__hostname" ];
              target_label = "host";
            }
            {
              source_labels = [ "__journal__systemd_unit" ];
              target_label = "systemd_unit";
              regex = "(.+)";
            }
            {
              source_labels = [ "__journal__systemd_user_unit" ];
              target_label = "systemd_user_unit";
              regex = "(.+)";
            }
            {
              source_labels = [ "__journal__transport" ];
              target_label = "transport";
              regex = "(.+)";
            }
            {
              source_labels = [ "__journal_priority_keyword" ];
              target_label = "severity";
              regex = "(.+)";
            }
          ];
          journal.labels = {
            job_name = "systemd";
            job_host = config.networking.hostName;

          };

        }
      ];
    };

  };

}
