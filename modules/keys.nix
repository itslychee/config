{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) attrsOf str listOf;
in {
  options.hey.keys = {
    # Public SSH keys for hosts
    hosts = mkOption {
      type = attrsOf str;
      readOnly = true;
    };
    # Public SSH keys for users
    users = mkOption {
      readOnly = true;
      type = attrsOf (attrsOf (listOf str));
    };
  };
  config.hey.keys = {
    hosts = {
      hearth = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIArMqV1t1DHgHH8nY9VbByx5/JXlHHySuBdsZr/UuHu+";
      hellfire = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICzt2XbvnHZf0gPn68PNMW5jj2YrPfKo1plVh2Dtle+j";
      wirescloud = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICEfmXtpdYV4s2YhL0eG96H4iD+Gx/j3oXuB2opEqOai";
      wiretop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMFhSwQjd3J7iPGxSp1AnGD5eS5mzqSOCSA/1osOfKom";
      pathway = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICE5cYKkvfT55xxhmLirU6K+JAHaZNd0xCsXPYrTuAEu";
    };
    users = {
      # me
      lychee = let
        hearthKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMHt4eGShEQs/nNwsHYbZDqOz9k1WVxDlJ4lJUfzosiG";
      in {
        # "Tags" for finer permissions
        secrets = [hearthKey];
        ssh = [hearthKey];
        deployment = [hearthKey];
        local_ssh = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHXeFJBxjG2NgeKr4l58KIp7lPf/pUeYD/4bYVapuump phone"
        ];
      };
    };
  };
}
