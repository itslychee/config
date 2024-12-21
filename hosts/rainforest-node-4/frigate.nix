{ lib, config, ... }:
{

  security.acme.acceptTerms = true;
  security.acme.defaults = {
    server = "https://ca.ratlabs.co/acme/acme/directory";
    email = "nope@nope.com";
  };

  networking.firewall.allowedTCPPorts = [
    443
    80
  ];

  services.nginx.virtualHosts.${config.services.frigate.hostname} = {
    enableACME = true;
    forceSSL = true;
  };

  services.frigate = {
    enable = true;
    hostname = "frigate.ratlabs.co";
    settings = {
      tls.enabled = false;
      record = {
        enabled = true;
        retain = {
          days = 7;
          mode = "motion";
        };
        events.retain = {
          default = 200;
          mode = "motion";
        };
      };
      snapshots = {
        enabled = true;
        retain.default = 30;
      };

      cameras =
        lib.mapAttrs
          (name: path: {
            enabled = true;
            ffmpeg.inputs = lib.singleton {
              inherit path;
              roles = [ "detect" ];
            };
            detect.enabled = false;

          })
          {
            camera-1 = "rtsp://10.20.60.29/live.sdp";
            camera-2 = "rtsp://10.20.60.30/live.sdp";
          };

    };
  };
}
