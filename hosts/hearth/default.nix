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
    wifi.file = ../../secrets/wifi.age;
    lastfm.file = ../../secrets/lastfm.age;
  };

  boot.loader.systemd-boot.enable = true;

  services = {
    sonarr = {
      enable = true;
      openFirewall = true;
    };
    radarr = {
      enable = true;
      openFirewall = true;
    };
    jellyfin = {
      enable = true;
      openFirewall = true;
    };
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
    enable = true;
    ensureProfiles.environmentFiles = [config.age.secrets.wifi.path];
    ensureProfiles.profiles.wifi = let
      psk = "$SSID";
      ssid = "$PASSWORD";
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
