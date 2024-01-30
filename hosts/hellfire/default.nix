{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
    ./secrets.nix
  ];



  hey = {
    # SSH Server
    sshServer.enable = true;
    nix.emulation = false;
  };

  # I don't wanna compile filesystem drivers or whatever the fuck
  # they're called.
  boot.supportedFilesystems = lib.mkForce ["ext4" "vfat"];
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;

  sdImage = {
    imageBaseName = config.networking.hostName;
    compressImage = false;
  };

  # Networking
  networking.firewall = {
    allowedTCPPorts = [53 80];
    allowedUDPPorts = [53 67];
  };

  # issues with setup, will come back later
  #
  # virtualisation = {
  #   oci-containers.backend = "docker";
  #   oci-containers.containers.pihole = {
  #     image = "pihole/pihole";
  #     # ports = [S
  #     #   "67:67/udp"
  #     #   "80:80/tcp"
  #     #   "53:53/tcp"
  #     #   "53:53/udp"
  #     #   "443:443/tcp"
  #     # ];
  #
  #     hostname = "pi.hole";
  #     environment = {
  #       TZ = config.time.timeZone;
  #       DNSMASQ_USER = "root";
  #       VIRTUAL_HOST = "pi.hole";
  #       PROXY_LOCATION = "pi.hole";
  #       FTLCONF_LOCAL_IPV4 = "127.0.0.1";
  #       PIHOLE_DNS_ = "1.1.1.1;1.0.0.1;8.8.8.8;8.8.4.4";
  #       REV_SERVER = "true";
  #       REV_SERVER_CIDR = "192.168.0.0/24";
  #       REV_SERVER_TARGET = "192.168.0.1";
  #       TEMPERATUREUNIT = "f";
  #       INTERFACE = "end0";
  #       DNSMASQ_LISTENING = "single";
  #     };
  #     volumes = [
  #        "pihole:/etc/pihole/"
  #        "pihole:/etc/dnsmasq.d/"
  #     ];
  #     extraOptions = [
  #       "--net=host"
  #       "--cap-add=NET_ADMIN"
  #       "--cap-add=CAP_SYS_NICE"
  #       "--dns=127.0.0.1"
  #     ];
  #   };
  # };

  # I do not care about inode dates and I want my RPI's I/O as fast
  # as possible
  fileSystems."/".options = ["noatime"];

  time.timeZone = "US/Central";
  users.users.root.openssh.authorizedKeys.keys = inputs.self.publicSSHKeys;
  users.users.pi = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    hashedPasswordFile = config.age.secrets.pi-hellfire.path;
    openssh.authorizedKeys.keys = inputs.self.publicSSHKeys;
  };
  # do not touch #
  system.stateVersion = "24.05";
}
