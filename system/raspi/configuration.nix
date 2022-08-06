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
       generic-extlinux-compatible.enable = true;
     };
  };
  networking.hostName = "raspi"; # Define your hostname.
  time.timeZone = "US/Central";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pi = {
    isNormalUser = true;
    openssh.authorizedKeys = {
      keys = [
       "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDQDDa177v9bubNE98TLIqYbCNf8Uc7kyrBGIxSqKksi"
       "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAxsk7CXGzb74/VgcDdax+migLka0muKNC6NH8g/QaBw"
       "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINPaOWJB8D5PImrtYLrA/phy9hKcEQCvmMDR993mOQoj"
      ];
    };
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
