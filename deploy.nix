{inputs}: let
  inherit (inputs.deploy) lib;
  hosts = inputs.self.nixosConfigurations;
in {
  wirescloud = {
    interactiveSudo = true;
    remoteBuild = true;
    hostname = "wirescloud";
    user = "lychee";
    profiles.system = {
      path = lib.x86_64-linux.activate.nixos hosts.wirescloud;
    };
  };
  wiretop = {
    interactiveSudo = true;
    hostname = "wiretop";
    user = "lychee";
    profiles.system = {
      path = lib.x86_64-linux.activate.nixos hosts.wiretop;
    };
  };
  hearth = {
    interactiveSudo = true;
    remoteBuild = true;
    hostname = "hearth";
    user = "lychee";
    profiles.system = {
      path = lib.x86_64-linux.activate.nixos hosts.hearth;
    };
  };
  hellfire = {
    interactiveSudo = true;
    user = "lychee";
    hostname = "hellfire";
    profiles.system = {
      path = lib.x86_64-linux.activate.nixos hosts.hellfire;
    };
  };
}
