{
  config,
  inputs,
  pkgs,
  ...
}:
{
  boot.loader.systemd-boot.enable = true;
  hey.hostKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHiCax0o/1zd+Ry7impZRDbOn4F3ife/A1HhS0EYh1KH root@rainforest-node-2"
  ];

  hey.remote.builder = {
    enable = true;
    maxJobs = 40;
    speedFactor = 105;
  };

  networking.firewall.interfaces.${config.services.tailscale.interfaceName} = {
    allowedTCPPorts = [ 9050 ];
  };
  imports = [
    inputs.typhon.nixosModules.default
  ];

  services.typhon = {
    enable = true;
    hashedPassword = "$argon2id$v=19$m=16,t=2,p=1$Zndmd2Zmd2Z3$hgv5ewz0KyULWjCKoYll8w";
    environmentFile = "${pkgs.writeText "env" ''
      LEPTOS_SITE_ADDR=0.0.0.0:9050
    ''}";
  };
}
