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

  networking.hostName = "raspi";
  users.users.pi = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [ 
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDQDDa177v9bubNE98TLIqYbCNf8Uc7kyrBGIxSqKksi"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAxsk7CXGzb74/VgcDdax+migLka0muKNC6NH8g/QaBw"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOE1QgmLF4nZtCRmYevk4DhmrVZE7ac4xuLYeECihZRkb"
    ];
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
  ];
  system.stateVersion = "22.05"; # Did you read the comment?
}
