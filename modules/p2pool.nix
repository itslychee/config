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
      users.groups.p2pool = { };
      users.users.p2pool = {
        group = "p2pool";
        isSystemUser = true;
      };

      services.monero = {
        enable = true;
        priorityNodes = [
          "p2pmd.xmrvsbeast.com:18080"
          "nodes.hashvault.pro:18080"
          "xmr1.julias.zone:18089"
        ];
        extraConfig = ''
          zmq-pub=tcp://127.0.0.1:18083
          out-peers=500
          in-peers=800
        '';
      };

      # Open firewall ports
      networking.firewall.allowedTCPPorts = [
        18080 # Monero P2P port
        37889 # p2pool
        37888 # p2pool mini
      ];

      systemd.services.p2pool = {
        after = [ "monero.service" ];
        wantedBy = [ "multi-user.target" ];
        description = "P2Pool instance";
        serviceConfig = {
          User = "p2pool";
          Group = "p2pool";
          Restart = "always";
          ExecStart = "${pkgs.p2pool}/bin/p2pool --host 127.0.0.1 --wallet  ${cfg.walletAddress}";
        };

      };
    })
  ];
}
