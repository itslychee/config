{
  config,
  ...
}:
{
  boot.kernelParams = [ "intel_iommu=on" ];
  boot.loader.systemd-boot.enable = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  hey.hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGSuccGN1fYQQqKWK5Eg+Ldj7H1a6LDIJsXxI3646Jgg";

  hey.github.enable = true;

  hey.remote.builder = {
    enable = true;
    maxJobs = 20;
    speedFactor = 100;
  };

}
