{ inputs, pkgs, config, lib, ...}:
{
  hey.sshServer.enable = true;
  users.users.lychee = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPasswordFile = config.age.secrets.lychee-hearth.path;
  };
}
