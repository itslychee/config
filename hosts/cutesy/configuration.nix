{ config, pkgs, ... }:
{
  imports = [
    (import ../../mixins/openssh.nix { allowedUsers = ["lychee"]; })
    (import ../../mixins/networking.nix {
      hostName = "cutesy"; 
      extraTCPPorts = [ 80 443 2222 ];
      extraUDPPorts = [ 80 443 2222 ];
      Fail2Ban = { enable = true; };
    })
    ../../mixins/hardware.nix
    ../../mixins/security.nix
  ];

  # Using GRUB bootloader due to server environment 
  boot.loader.grub = {
     enable = true;
     version = 2;
     device = "/dev/vda"; 
  };

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      gitea = {
        image = "gitea/gitea:latest";
        ports = [ "127.0.0.1:3000:3000" "2222:22" ];
        volumes = [ "/containers/gitea/:/data" ];
      };
      vaultwarden = {
        image = "vaultwarden/server";
        ports = [
          "127.0.0.1:3001:80"
        ];
        volumes = [ "/containers/vaultwarden/:/data/"];
      };
    };
  };

  services.caddy = {
    enable = true;
    extraConfig = ''
      https://git.lefishe.club {
        reverse_proxy 127.0.0.1:3000
      }
      https://vault.lefishe.club {
        reverse_proxy 127.0.0.1:3001
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

