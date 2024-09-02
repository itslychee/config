{
  boot.loader.systemd-boot.enable = true;
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  hey = {
    hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAp0yi9vv/paF5cnqy5XhZl67z8Lv9qGWakrE6Zxijvf";
  };
  services.tailscale.ip = "100.97.223.11";

  services.consul.enable = true;
  hey.remote.builder = {
    enable = true;
    maxJobs = 20;
    speedFactor = 85;
  };

  system.stateVersion = "24.05";
}
