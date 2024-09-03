{
  boot.loader.systemd-boot.enable = true;
  hey.hostKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEocveIiwBkFkdQQS7ArFCfZWF6dh/P/qT4EVYmORuHa root@gatekeeper"
  ];
  system.stateVersion = "24.05";

  hey.remote.builder = {
    enable = true;
    maxJobs = 20;
    speedFactor = 95;
  };
}
