{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [ "${inputs.self}/users/lychee" ];

  age.secrets = {
    wifi-ssid.file = ../../secrets/wifi-ssid.age;
    wifi-password.file = ../../secrets/wifi-password.age; 
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
