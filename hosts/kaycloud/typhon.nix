{
  inputs,
  pkgs,
  config,
  ...
}:
{

  services.caddy.virtualHosts."ci.wires.cafe".extraConfig = ''
    reverse_proxy http://rainforest-node-1:9050
  '';

}
