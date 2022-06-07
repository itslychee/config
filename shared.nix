# Shared configuration among all hosts. Mostly "defaults" 
# that would be a drag to write for every single one.
#
# The definitions below should be wrote in a way that allows
# a host to override any set value here.

{ lib, ...}:
with lib;
{
  # Locale
  time.timeZone = mkDefault "US/Central";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";

  imports = [ ./modules/system/flakes.nix ];

  # OpenSSH security-focused defaults
  services.openssh = {
    passwordAuthentication = mkDefault false;
    permitRootLogin = mkDefault "no";
  };

  services.dbus.enable = mkDefault true;
  # Disable DHCP
  networking.useDHCP = mkDefault false;
}
