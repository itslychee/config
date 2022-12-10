{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/networkmanager.nix
    ../../modules/system/gpg-agent.nix
    ../../modules/system/system-updates.nix
    ../../modules/system/firewall.nix
  ];

  virtualisation.docker.enable = true;
  boot = {
     kernelPackages = pkgs.linuxPackages_rpi4;
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
  networking.allowedTCPPorts = networking.allowedTCPPorts ++ [ 53 ];
  networking.allowedUDPPorts = networking.allowedUDPPorts ++ [ 53 67 ];


  users.users.pi = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = (import ../../misc/keys.nix).ssh;
    extraGroups = [ "wheel" ];
  };
  environment.systemPackages = with pkgs; [
    docker-compose
    vim
    wget
  ];
}
