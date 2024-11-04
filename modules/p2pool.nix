{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.hey.mine;
  inherit (lib)
    mkMerge
    mkIf
    mkOption
    mkEnableOption
    types
    ;
in
{
  options = {
    hey.mine = {
      instance = mkOption {
        description = "Pool instance location";
        default = "kaycloud:3333";
        type = types.str;
      };
      walletAddress = mkOption {
        description = "monero wallet";
        type = types.str;
        default = "43daqYrv4Go7ZR4Zew1AYW5kkt8xgZQrB2GLT3UJMQ9ziyh5MeUCVvmYbv4QG5W9Rw1FCwoDmEJDF3nkYMnM918KMueA92d";
      };
      use = mkEnableOption "Use p2pool instance";
      serve = mkEnableOption "Run as p2pool instance";
    };
  };
  config = mkMerge [
    (mkIf (cfg.use || cfg.serve) {
      boot.kernel.sysctl."vm.nr_hugepages" = 3072;
    })
    (mkIf cfg.use {
      services.xmrig = {
        enable = true;
        settings = {
          autosave = true;
          cpu = true;
          opencl = true;
          donate-level = 0;
          cuda = true;
          pools = [
            {
              coin = null;
              algo = null;
              url = cfg.instance;
              user = "43daqYrv4Go7ZR4Zew1AYW5kkt8xgZQrB2GLT3UJMQ9ziyh5MeUCVvmYbv4QG5W9Rw1FCwoDmEJDF3nkYMnM918KMueA92d";
              pass = "x";
              tls = false;
              keepalive = true;
              nicehash = false;
            }
          ];
        };
      };

    })
    (mkIf cfg.serve {

      # Open firewall ports
      networking.firewall.allowedTCPPorts = [
        37889 # p2pool
        37888 # p2pool mini
      ];

      systemd.services.p2pool = {
        after = [ "monero.service" ];
        wantedBy = [ "multi-user.target" ];
        description = "P2Pool instance";
        serviceConfig = {
          DynamicUser = true;
          User = "p2pool";
          Restart = "always";
          WorkingDirectory = "/var/lib/p2pool";
          StateDirectory = "p2pool";
          StateDirectoryMode = "0700";
          ExecStart = "${pkgs.p2pool}/bin/p2pool --host node.richfowler.net --rpc-port 18089 --zmq-port 18084 --wallet  ${cfg.walletAddress}";
        };

      };
    })
  ];
}
