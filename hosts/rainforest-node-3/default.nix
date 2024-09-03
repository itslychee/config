{
  boot.loader.systemd-boot.enable = true;
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  hey = {
    hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKsjWwOI8IiTedsAWbPbTGk3ksEC3owyJqJPZM7/6Tjl";
  };

  hey.remote.builder = {
    enable = true;
    maxJobs = 20;
    speedFactor = 55;
  };

  system.stateVersion = "24.05";
}
