let
  inherit (import <nixpkgs> {}) lib;
  inherit (builtins) isList;

  keys =
    (lib.evalModules {
      modules = [../modules/keys.nix];
    })
    .config
    .hey
    .keys;

  # Wrapper for privileged + host keys
  withPrivileged = hosts:
    lib.flatten [
      (builtins.attrValues keys.privileged)
      (
        if (isList hosts)
        then (map (name: keys.hosts.${name}) hosts)
        else keys.hosts.${hosts}
      )
    ];
in {
  "wifi.age".publicKeys = withPrivileged "hearth";
  "pi-hellfire.age".publicKeys = withPrivileged "hellfire";
  "lychee-password.age".publicKeys = withPrivileged ["hellfire" "hearth" "wirescloud"];
  "vault-admin.age".publicKeys = withPrivileged ["wirescloud"];
  "lastfm.age".publicKeys = withPrivileged ["hearth"];
}
