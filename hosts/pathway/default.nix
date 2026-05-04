{
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  hey.hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPb84IrcxIN9tStsIRZvuY+/aJ5zLroEntE/D05mhq5I";

  networking.networkmanager.enable = true;

  services.logind.lidSwitchExternalPower = "ignore";
}
