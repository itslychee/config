{ config, inputs, ... }:
{
  time.timeZone = "Europe/Berlin";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  hey.hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPyghJsTMDlHz0WPWnSV9Tklp/2SuJQzRvjBvowPJHOh";

  deployment.keys.factorio-secrets = {
    destDir = "/var/lib/factorio";
    keyCommand = [
      "gpg"
      "--decrypt"
      (toString ../../secrets/factorio.gpg)
    ];
  };

  systemd.services.factorio.serviceConfig.LoadCredential =
    "secrets.json:${config.deployment.keys.factorio-secrets.path}";

  services.factorio = {
    enable = true;
    package = inputs.unstable.legacyPackages.${config.nixpkgs.hostPlatform.system}.factorio-headless;
    openFirewall = true;
    saveName = "new-leaf";
    description = "wires server stuff";
    game-name = "wires cafe";
    allowedPlayers = [
      "itslychee"
      "ItzMichaili"
      "vaskel"
    ];
    admins = [
      "itslychee"
      "ItzMichaili"
    ];
    autosave-interval = 10;
    nonBlockingSaving = true;
    extraSettingsFile = "/run/credentials/factorio.service/secrets.json";
  };

  hey.users.michaili = {
    groups = [ "wheel" ];
    hashedPassword = "$y$j9T$bbST2Hh4s48HybtRlvSDp1$D76h1n6sS1s0o00ZmQjBo5wjffXUFv/Mn3/2Yks5DQC";
    sshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOct0GpSUGR8eFXiyPF6rHFQ9r97rdH/+rv/GDZnSyqS"
    ];
  };

}
