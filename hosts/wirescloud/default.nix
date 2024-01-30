{
  config,
  inputs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./secrets.nix
    ./hw-config.nix
  ];

  boot.loader.systemd-boot.enable = true;
  hardware.enableAllFirmware = true;

  hey.sshServer.enable = true;
  users.mutableUsers = lib.mkForce true;
  users.users = {
    hadock = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIMefXB2y1fdobZGva3FEN/CDJxqu6JJmjNdKkQ/jMy/cAAAABHNzaDo="
      ];
    };
    lychee = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = config.hey.keys.users.lychee;
      extraGroups = ["wheel"];
      # hashedPasswordFile = config.age.secrets.lychee-password.path;
    };
  };

  networking.firewall.allowedTCPPorts = [80 443];


  # do not change
  system.stateVersion = "23.05";
}
