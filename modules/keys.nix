{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) attrsOf either listOf str submodule;
  keyList = mkOption {
    type = attrsOf (either str (listOf str));
    readOnly = true;
  };
  key = mkOption {
    type = attrsOf str;
    readOnly = true;
  };
in {
  options.hey.keys = {
    # Public SSH keys for hosts
    hosts = key;
    # Public SSH keys for users
    users = keyList;
    # like users but privileged (e.g. me)
    privileged = keyList;
  };
  config.hey.keys = {
    hosts = {
      hearth = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHEW9f3t4Ak7o5tVWPdVpLDFxkrrc7ZH9+kn3ZxHJozV";
      hellfire = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICzt2XbvnHZf0gPn68PNMW5jj2YrPfKo1plVh2Dtle+j";
      wirescloud = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICEfmXtpdYV4s2YhL0eG96H4iD+Gx/j3oXuB2opEqOai";
    };
    users = {
      # some random person
      hadock = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIMefXB2y1fdobZGva3FEN/CDJxqu6JJmjNdKkQ/jMy/cAAAABHNzaDo= hadock@hadock-tech"
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPTSzju6VJ1ohoKcnY9Tirj/TS4/nOEhDSav3raL486ilbaitzuSispLj3/quPNFrwqrDkX9U8rPoIzICUNhiZM="
      ];
      # me
      lychee = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMHt4eGShEQs/nNwsHYbZDqOz9k1WVxDlJ4lJUfzosiG"
      ];
    };
    privileged = {
      inherit
        (config.hey.keys.users)
        lychee
        ;
    };
  };
}
