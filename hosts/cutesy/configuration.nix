{ config, pkgs, ... }:
{
  imports = [
    (import ../../mixins/networking.nix {
      hostName = "cutesy"; 
      Fail2Ban = { enable = true; };
    })
    (import ../../mixins/openssh.nix { AllowUsers = ["lychee"]; })
    ../../mixins/hardware.nix
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

