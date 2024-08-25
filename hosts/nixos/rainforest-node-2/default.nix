{
  boot.loader.systemd-boot.enable = true;
  hey.caps.headless = true;
  hey.hostKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEocveIiwBkFkdQQS7ArFCfZWF6dh/P/qT4EVYmORuHa root@gatekeeper"
  ];
  system.stateVersion = "24.05";

  services.consul = {
    enable = true;
    extraConfig = {
      server = true;
    };
  };
  hey.remote.builder = {
    enable = true;
    maxJobs = 20;
    speedFactor = 95;
  };

  services.tailscale.ip = "100.108.191.121";
  services.garage = {
    enable = true;
  };
}
