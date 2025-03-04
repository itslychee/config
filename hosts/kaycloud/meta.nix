{ config, ... }:
{
  time.timeZone = "Europe/Berlin";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  hey.hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPyghJsTMDlHz0WPWnSV9Tklp/2SuJQzRvjBvowPJHOh";

  deployment.keys.factorio = {
    destDir = "/var/lib/secrets/factorio";
    keyCommand = [
      "gpg"
      "--decrypt"
      (toString ../../secrets/factorio.gpg)
    ];
  };

  services.factorio = {
    enable = true;
    openFirewall = true;
    saveName = "kayili-server";
    description = "kayili productions co ltd inc";
    allowedPlayers = [
      "itslychee"
      "ItzMichaili"
      "vaskel"
    ];
    autosave-interval = 20;
    nonBlockingSaving = true;
    extraSettingsFile = config.deployment.keys.factorio.path;
  };

}
