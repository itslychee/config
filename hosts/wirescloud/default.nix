{
  inputs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  hey = {
    users.lychee.enable = true;
    services = {
      openssh.enable = true;
      matrix = {
        enable = true;
        serverName = "lefishe.club";
        matrixHostname = "matrix.lefishe.club";
        elementHostname = "element.lefishe.club";
      };
      vault = {
        enable = true;
        domain = "vault.lefishe.club";
      };
      website = {
        enable = true;
        domain = "lefishe.club";
      };
    };
  };

  users.users.root.openssh = {
    authorizedKeys.keys = config.hey.keys.users.lychee;
  };

  # do not change
  system.stateVersion = "23.05";
}
