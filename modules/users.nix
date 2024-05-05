{config, ...}: {
  age.secrets.lychee-password.file = ../secrets/lychee-password.age;
  # should be obvious why this is global
  hey.users.lychee = {
    enable = true;
    sshKeys = config.hey.keys.users.lychee.ssh;
    passwordFile = config.age.secrets.lychee-password.path;
    groups = [
      "wheel"
      "audio"
      "video" # needed for light
      "networkmanager"
    ];
  };
}
