{ inputs, pkgs, config, lib, ...}:
{
  hey.sshServer.enable = true;
  age.secrets.lychee-hearth.file = ../../secrets/lychee-hearth.age;
  users.users.lychee = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPasswordFile = config.age.secrets.lychee-hearth.path;
  };

  system.stateVersion = "24.05";
}
