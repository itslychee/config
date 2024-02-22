{ config,
 inputs,
 lib,
 ...
}: let
  cfg = config.hey.ctx;
in {
  age.secrets = {
    lychee-password.file = "${inputs.self}/secrets/lychee-password.age";
  };

  users.users.lychee = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = lib.mkIf (builtins.elem cfg.platform [ "hybrid" "server"]) config.hey.keys.users.lychee;
    extraGroups = ["wheel"];
    hashedPasswordFile = config.age.secrets.lychee-password.path;
  };
  hey.users.lychee = {
    wrappers.enable = true;
  };

}
