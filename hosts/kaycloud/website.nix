{pkgs, ...}: let
  site = pkgs.linkFarm "site" [
    {
      path = ./index.html;
      name = "index.html";
    }
  ];
in {
  services.caddy = {
    enable = true;
    virtualHosts."wires.cafe".extraConfig = ''
      file_server * {
        root ${site}
        index index.html
      }
    '';
  };
}
