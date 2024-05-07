inputs: let
  inherit (inputs.deploy) lib;
  hosts = inputs.self.nixosConfigurations;
in {
  wirescloud = {
    interactiveSudo = true;
    remoteBuild = true;
    hostname = "wirescloud";
    profiles.system = {
      path = lib.x86_64-linux.activate.nixos hosts.wirescloud;
      user = "root";
    };
  };
  wiretop = {
    interactiveSudo = true;
    sshUser = "lychee";
    hostname = "wiretop";
    profiles.system = {
      user = "root";
      path = lib.x86_64-linux.activate.nixos hosts.wiretop;
    };
  };
  hearth = {
    interactiveSudo = true;
    remoteBuild = true;
    hostname = "hearth";
    profiles.system = {
      user = "root";
      path = lib.x86_64-linux.activate.nixos hosts.hearth;
    };
  };
  hellfire = {
    hostname = "hellfire";
    sshUser = "root";
    profiles.system = {
      user = "root";
      path = lib.aarch64-linux.activate.nixos hosts.hellfire;
    };
  };
}
