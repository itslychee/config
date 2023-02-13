{ config, pkgs, ... }:
{
  imports = [
    (import ../../mixins/networking.nix { hostName = "cutesy"; })
    ../../mixins/hardware.nix
    ../../mixins/openssh.nix
    ../../mixins/security.nix
  ];

  # Using GRUB bootloader due to server environment 
  boot.loader.grub = {
     enable = true;
     version = 2;
     device = "/dev/vda"; 
  };

  # UTC time preferred for server environment
  time.timeZone = "Etc/UTC";

  # Administrator user
  users.users.lychee = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; 
    openssh.authorizedKeys.keyFiles = [ ../../keys.pub ];
  };
}

