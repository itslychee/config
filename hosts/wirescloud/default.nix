{
  inputs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    "${inputs.self}/users/lychee"
  ];

  boot.loader.systemd-boot.enable = true;
  hey = {
    ctx.platform = "server";
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
