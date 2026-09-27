{
  networking.useDHCP = false;
  systemd.network = {
    enable = true;
    networks = {
      eno1np0 = {
        matchConfig.Name = "eno1np0";
        addresses = [
          { Address = "40.160.54.108/24"; }
          { Address = "2604:2dc0:100:596c::1/64"; }
        ];
        routes = [
          { Gateway = "40.160.54.254"; }
          {
            Gateway = "2604:2dc0:0100:59ff:00ff:00ff:00ff:00ff";
            GatewayOnLink = true;
          }
        ];
        dns = [
          "1.1.1.1"
          "1.0.0.1"
          "2606:4700:4700::1111"
          "2606:4700:4700::1001"
        ];
        linkConfig.RequiredForOnline = "routable";
      };

    };
  };
}
