{ config, pkgs, ... }:
{
  imports = [
    (import ../../mixins/openssh.nix { allowedUsers = ["lychee"]; })
    (import ../../mixins/networking.nix {
      hostName = "cutesy"; 
      extraTCPPorts = [ 80 443 222 ];
      extraUDPPorts = [ 80 443 ];
      Fail2Ban = { enable = true; };
    })
    ../../mixins/hardware.nix
    ../../mixins/security.nix
  ];
  virtualisation.docker.enable = true;
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];
  boot.loader.grub = {
     enable = true;
     version = 2;
     device = "/dev/vda"; 
  };

  services.caddy = {
    enable = true;
    extraConfig = ''
      https://git.lefishe.club {
        reverse_proxy 127.0.0.1:3000
      }
    '';
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

