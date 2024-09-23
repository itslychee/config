{
  boot.loader.systemd-boot.enable = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  hey = {
    hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAp0yi9vv/paF5cnqy5XhZl67z8Lv9qGWakrE6Zxijvf";
  };

  hey.remote.builder = {
    enable = true;
    maxJobs = 20;
    speedFactor = 85;
  };

  services.consul.extraConfig.server = true;

  system.stateVersion = "24.05";
  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [ "eno2" ];
  };
}
