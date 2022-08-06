{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/networkmanager.nix
  ];

  boot = {
     kernelPackages = pkgs.linuxPackages_rpi4;
     tmpOnTmpfs = true;
     initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
     kernelParams = [
       "8250.nr_uarts=1"
       "console=ttyAMA0,115200"
       "console=tty1"
     ];
     loader = {
       grub.enable = false;
       #raspberryPi.enable = true;
       #raspberryPi.version = 4;
       generic-extlinux-compatible.enable = true;
     };
  };
  networking.hostName = "raspi"; # Define your hostname.
  time.timeZone = "US/Central";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pi = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "22.05"; # Did you read the comment?
}
