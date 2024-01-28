let
  publicSSHKeys = import ../keys.nix;
  hearthKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHEW9f3t4Ak7o5tVWPdVpLDFxkrrc7ZH9+kn3ZxHJozV";
  hellfireKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMbJJu96yDOzZrkWoVResruK3t22thNZmTE2/+1m+DdH";

  hellfireKeys = [ hellfireKey ] ++ publicSSHKeys;
  hearthKeys = [ hearthKey ] ++ publicSSHKeys;
  allKeys = hearthKeys + hellfireKeys;
in {
  "pi-hellfire.age".publicKeys = hellfireKeys;
  "lychee-hearth.age".publicKeys = hearthKeys;
}
