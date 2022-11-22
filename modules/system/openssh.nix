{ config, lib, ...}:
with lib;
{
  config = {
    services.openssh.enable = mkDefault true;
    services.openssh.passwordAuthentication = mkDefault false;
    services.openssh.startWhenNeeded = mkDefault true;
    services.openssh.permitRootLogin = mkDefault "no";
  };
}
