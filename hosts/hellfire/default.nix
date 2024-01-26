{ inputs, pkgs, config, lib, ...}: {
  imports = [ 
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
  ];

  hey.sshServer.enable = true;

  # I don't wanna compile filesystem drivers or whatever the fuck
  # they're called.
  boot.supportedFilesystems = lib.mkForce ["ext4" "vfat"];
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;

  # Networking
  networking.networkmanager.enable = true;
  networking.firewall = {
    allowedTCPPorts = [ 53 80 ];
    allowedUDPPorts = [ 53 67 ];
  };



  virtualisation = { 
    docker = {
      enable = true;
    };
    oci-containers.backend = "docker";
    oci-containers.containers.pihole = {
      image = "pihole/pihole";
      ports = [
        "67:67/udp" # Only required if you are using Pi-hole as your DHCP server
        "80:80/tcp"
        "53:53/tcp"
        "53:53/udp"
        "443:443/tcp"
      ];
      hostname = "pi.hole";
      environment = {
        TZ = config.time.timeZone;
        DNSMASQ_USER = "root";
        DNSMASQ_LISTENING="bind";
        VIRTUAL_HOST = "pi.hole";
        PROXY_LOCATION = "pi.hole";
        FTLCONF_LOCAL_IPV4 = "127.0.0.1";
      };
      volumes = [
         "pihole:/etc/pihole/"
         "pihole-dnsmasq:/etc/dnsmasq.d/"
      ];
      extraOptions = [
        "--cap-add=NET_ADMIN"
        "--cap-add=CAP_SYS_NICE"
      ];
    };
  };



  # I do not care about inode dates and I want my RPI's I/O as fast
  # as possible
  fileSystems."/".options = [ "noatime" ];

  time.timeZone = "US/Central";
  users.users.pi = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "pi";
    openssh.authorizedKeys.keys = inputs.self.publicSSHKeys;
  };
  # do not touch #
  system.stateVersion = "24.05";
}
