let
  publicSSHKeys = import ../keys.nix;
  hearthKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHEW9f3t4Ak7o5tVWPdVpLDFxkrrc7ZH9+kn3ZxHJozV";
  hellfireKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICzt2XbvnHZf0gPn68PNMW5jj2YrPfKo1plVh2Dtle+j";

  hellfireKeys = [ hellfireKey ] ++ publicSSHKeys;
  hearthKeys = [ hearthKey ] ++ publicSSHKeys;
  allKeys = hearthKeys + hellfireKeys;
in {
  "pi-hellfire.age".publicKeys = hellfireKeys;
  "lychee-hearth.age".publicKeys = hearthKeys;
  "wifi-ssid.age".publicKeys = hearthKeys;
  "wifi-password.age".publicKeys = hearthKeys;
}
