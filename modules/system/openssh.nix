{ config, lib, ...}:
with lib;
{
  config = {
    services.openssh.enable = mkDefault true;
    services.openssh.passwordAuthentication = mkDefault false;
    services.openssh.permitRootLogin = mkDefault "no";
  };
}
