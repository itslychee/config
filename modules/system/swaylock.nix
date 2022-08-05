{ lib, config, ...}:
with lib;
{
  config.security.pam.services.swaylock.text = mkDefault ''
    auth include login
  '';
}
