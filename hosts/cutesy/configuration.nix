{ config, pkgs, ... }:
{
  imports = [
    (import ../../mixins/openssh.nix { allowedUsers = ["lychee"]; })
    ../../mixins/hardware.nix
    ../../mixins/security.nix
  ];
  networking = {
    hostName = "cutesy";
    nameservers = ["1.1.1.1" "1.0.0.1"];
    firewall.enable = true;
    firewall.allowedTCPPorts = [ 222 80 443 7777];

    networkmanager.enable = true;
    networkmanager.enableFccUnlock = true;
  };

  virtualisation.docker.enable = true;

  services.fail2ban = {
    enable = true;
    maxretry = 20;
    ignoreIP = [
      # LAN ranges both in IPv6 and IPv4
      "127.0.0.0/8"
      "10.0.0.0/8"
      "::1/128"
    ];
    # TODO: Configure jails 
  };

  boot.loader.grub = {
     enable = true;
     device = "/dev/vda"; 
  };

  services.caddy = {
    enable = true;
    extraConfig = ''
      https://git.lefishe.club {
        reverse_proxy 127.0.0.1:3000
      }
      https://lefishe.club {
        root * /srv/things/
        file_server {
          index lefishe.jpg
        }
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
  users.users.prod = {
    isNormalUser = true;
    openssh.authorizedKeys.keyFiles = [ ../../keys.pub ];
  };
  environment.systemPackages = with pkgs; [screen terraria-server ];
}

