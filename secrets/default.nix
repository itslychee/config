{self, ...}: {}: let
  pubKeys =
    builtins.catAttrs "key"
    (builtins.attrValues self.publicSSHKeys);
in {
}
