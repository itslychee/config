# Shared configuration among all hosts. Mostly "defaults" 
# that would be a drag to write for every single one.
#
# The definitions below should be wrote in a way that allows
# a host to override any set value here.

{ pkgs, ...}@inputs:
with pkgs.lib;
{
  # Locale
  time.timeZone = mkDefault "US/Central";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";

  # OpenSSH security-focused defaults
  services.openssh = {
    passwordAuthentication = mkDefault false;
    permitRootLogin = mkDefault "no";
  };

  # documentation.nixos.enable = mkDefault false;

  services.dbus.enable = mkDefault true;
  # Disable DHCP
  networking.useDHCP = mkDefault false;
  # Nix defaults, I don't really expect myself to override
  # these but it's good to know that I could.
  nix = {
    autoOptimiseStore = mkDefault true;
    gc = {
      persistent = mkDefault true;
      automatic = mkDefault true;
      options = mkDefault "-d --delete-older-than 10d";
      dates = mkDefault "5d";
    };
    optimise = {
      automatic = mkDefault true;
      dates = mkDefault [ "6d" ];
    };

    # Flakes setup
    #
    # I'm quite eager to see the day when the following 
    # lines are marked obsolete.
    package = mkDefault pkgs.nixFlakes;
    extraOptions = mkDefault ''
      experimental-features = nix-command flakes
    '';
  };
}
