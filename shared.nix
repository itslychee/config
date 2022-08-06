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

  # Enables Flakes for all systems, this is one
  # exception to the file's preamble for obvious reasons.
  imports = [
    ./modules/system/flakes.nix
    ./modules/system/firewall.nix
    ./modules/system/openssh.nix
  ];

  # OpenSSH security-focused defaults
  services.openssh = {
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = mkDefault true;
  # Dbus!
  services.dbus.enable = mkDefault true;
  # Disable DHCP
  networking.useDHCP = mkDefault false;
}
