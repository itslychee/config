let
  publicSSHKeys = import ../keys.nix;
  hearthKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHEW9f3t4Ak7o5tVWPdVpLDFxkrrc7ZH9+kn3ZxHJozV";
  hellfireKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICzt2XbvnHZf0gPn68PNMW5jj2YrPfKo1plVh2Dtle+j";
  wirescloudKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILlm0RhDrXbORKg8dRIl6Z/yct7KJv1FNAouzqA/8BAE";

  hellfireKeys = [hellfireKey] ++ publicSSHKeys;
  hearthKeys = [hearthKey] ++ publicSSHKeys;
  wirescloudKeys = [ wirescloudKey ] ++ publicSSHKeys;

  # statix: stfu dum bitch
  allKeys = hearthKeys + hellfireKeys ++ wirescloudKeys;
in {
  "pi-hellfire.age".publicKeys = hellfireKeys;
  "lychee-password.age".publicKeys = hearthKeys ++ wirescloudKeys;
  "wifi-ssid.age".publicKeys = hearthKeys;
  "wifi-password.age".publicKeys = hearthKeys;
}
