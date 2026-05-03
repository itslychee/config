{
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  hey = {
    caps.headless = true;
    net.home = true;
  };
  networking.networkmanager.enable = true;

  services.logind.lidSwitchExternalPower = "ignore";
}
