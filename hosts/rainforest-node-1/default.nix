{
  config,
  lib,
  ...
}:
{
  boot.loader.systemd-boot.enable = true;
  hey.hostKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHiCax0o/1zd+Ry7impZRDbOn4F3ife/A1HhS0EYh1KH root@rainforest-node-2"
  ];

  hey.github.enable = true;
  hey.remote.builder = {
    enable = true;
    maxJobs = 40;
    speedFactor = 105;
  };

  networking.firewall.interfaces.${config.services.tailscale.interfaceName} = {
    allowedTCPPorts = [ 9050 ];
  };

  services.promtail.configuration.scrape_configs = lib.singleton {
    job_name = "syslog-ng";
    syslog = {
      listen_address = "127.0.0.1:1514";
      label_structured_data = true;
      labels.job = "syslog";
    };
    relabel_configs = lib.singleton {
      source_labels = [ "__syslog_message_hostname" ];
      target_label = "host";
    };
  };

  networking.firewall.allowedUDPPorts = [ 514 ];

  services.syslog-ng = {
    enable = true;
    extraConfig = ''
      destination d_loki {
        syslog("127.0.0.1" transport("tcp") port(1514));
      };
      log {
          source {
            network();
          };
          destination(d_loki);
      };
    '';
  };
}
