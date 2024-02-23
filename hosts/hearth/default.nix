{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    "${inputs.self}/users/lychee"
    ./hardware-configuration.nix
  ];

  age.secrets = {
    wifi-ssid.file = ../../secrets/wifi-ssid.age;
    wifi-password.file = ../../secrets/wifi-password.age; 
    lastfm.file = ../../secrets/lastfm.age;
  };

  services = {
    sonarr =   { enable = true; openFirewall = true; };
    radarr =   { enable = true; openFirewall = true; };
    jellyfin = { enable = true; openFirewall = true; };
    mpd = {
      enable = true;
      dataDir = "/storage/data/mpd";
      musicDirectory = "/storage/media/music";
      startWhenNeeded = true;
    };
    # I really do not like to have this as a system service
    # as this is really a user-specific thing, eventually I'll make a module
    # for this on the home-level. I'm aware that I'm the only user but it still
    # irks me.
    mpdscribble = {
      enable = config.services.mpd.enable;
      endpoints."last.fm" = {
        username = "ItsNotLychee";
        passwordFile = config.age.secrets.lastfm.path;
      };
    };
  };

  hey = {
    ctx.platform = "hybrid";
    services.openssh.enable = true;
  };
  networking.networkmanager = {
    ensureProfiles.profiles.wifi = let
      # you're probably wondering why I'm doing this, and the short answer
      # is that I don't care if my system can see these, i just don't want
      # you seeing it :3
      ssid = builtins.readFile config.age.secrets.wifi-ssid.path;
      psk = builtins.readFile config.age.secrets.wifi-password;
    in {
      connection = {
        type = "wifi";
        id = ssid;
      };
      wifi = {
        inherit ssid;
      };
      wifi-security = {
        auth-alg = "open";
        key-mgmt = "wpa-psk";
        inherit psk;
      };
    };
  };

  # do not touch ever! #
  system.stateVersion = "24.05";
}
