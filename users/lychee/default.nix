{ config,
 inputs,
 ...
}: {
  age.secrets = {
    lychee-password.file = "${inputs.self}/secrets/lychee-password.age";
  };

  users.users.lychee = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = config.hey.keys.users.lychee;
    extraGroups = ["wheel"];
    hashedPasswordFile = config.age.secrets.lychee-password.path;
  };
  hey.users.lychee = {
    wrappers.enable = true;
  };

}
