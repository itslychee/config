{
  boot.loader.systemd-boot.enable = true;
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  hey = {
    hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKsjWwOI8IiTedsAWbPbTGk3ksEC3owyJqJPZM7/6Tjl";
  };
  services.tailscale.ip = "100.108.100.56";

  services.consul = {
    enable = true;
    extraConfig.server = true;
  };
  hey.remote.builder = {
    enable = true;
    maxJobs = 20;
    speedFactor = 55;
  };

  system.stateVersion = "24.05";
}
