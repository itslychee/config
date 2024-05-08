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
      hearth = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHEW9f3t4Ak7o5tVWPdVpLDFxkrrc7ZH9+kn3ZxHJozV";
      hellfire = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICzt2XbvnHZf0gPn68PNMW5jj2YrPfKo1plVh2Dtle+j";
      wirescloud = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICEfmXtpdYV4s2YhL0eG96H4iD+Gx/j3oXuB2opEqOai";
      wiretop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID622//cxsXYlGosqCLHStsr8JufcIPD9bQl9iId/spm";
      pathway = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMCKV09cEzRiI+ss0kaK++sKlqV17PAtQrpzQ37tO78a";
    };
    users = {
      # me
      lychee = {
        # "Tags" for finer permissions
        secrets = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMHt4eGShEQs/nNwsHYbZDqOz9k1WVxDlJ4lJUfzosiG lychee@desktop"];
        local_ssh = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHXeFJBxjG2NgeKr4l58KIp7lPf/pUeYD/4bYVapuump phone"];
        ssh = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMHt4eGShEQs/nNwsHYbZDqOz9k1WVxDlJ4lJUfzosiG lychee@desktop"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKFqTbiSzLECj3huZ5NBd8xQwB+TEvCbUTKCxBmwmWWw lychee@wiretop"
        ];
        deployment = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMHt4eGShEQs/nNwsHYbZDqOz9k1WVxDlJ4lJUfzosiG lychee@desktop"];
      };
    };
  };
}
