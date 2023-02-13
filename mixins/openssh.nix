{ pkgs, ...}:
with pkgs.lib;
{
  config = mkDefault {
    services.openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = "no";
    };
  };
}
