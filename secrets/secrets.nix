let
  inherit (import <nixpkgs> {}) lib;
  inherit (builtins) isList;
  secrets = import ../lib/keys.nix;

  keys =
    (lib.evalModules {
      modules = [../modules/keys.nix];
    })
    .config
    .hey
    .keys;

  # Wrapper for privileged + host keys
  withPrivilegedUser = user: hosts:
    lib.flatten [
      # user public keys
      keys.users.${user}.secrets
      # Hosts pub keys
      (
        if (isList hosts)
        then (map (name: keys.hosts.${name}) hosts)
        else keys.hosts.${hosts}
      )
    ];

  withPrivileged = withPrivilegedUser "lychee";
in {
  "wifi.age".publicKeys = withPrivileged ["hearth" "wiretop"];
  "lychee-password.age".publicKeys = withPrivileged ["hellfire" "hearth" "wirescloud" "wiretop"];
  "vault-admin.age".publicKeys = withPrivileged ["wirescloud"];
}
