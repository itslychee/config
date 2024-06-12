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
      hearth = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOaAxiB8BtVJC+3WM/ydH+8CRaINbE+7X3aO1l/0cJhV";
      hellfire = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICzt2XbvnHZf0gPn68PNMW5jj2YrPfKo1plVh2Dtle+j";
      wirescloud = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICEfmXtpdYV4s2YhL0eG96H4iD+Gx/j3oXuB2opEqOai";
      wiretop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIINnq/AyE9T+4uA4/707mECHbt+5ZzeaK3zFW4AUEMvi";
      pathway = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICE5cYKkvfT55xxhmLirU6K+JAHaZNd0xCsXPYrTuAEu";
      school-desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIiZ7kKvxTiMJNtybsRHeF6Po9rl8onUZr1aQ0mhTRwx";
    };
    users = {
      # me
      lychee = let
        hearthKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL0oSTfGZYuBmADdQofLJm22dcIFAUaos048sayYp5/J";
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
