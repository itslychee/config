{
  lib,
  config,
  pkgs,
  ...
}: {
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };
  hardware.pulseaudio.enable = lib.mkForce false; # Ensure this remains off
  sound.enable = lib.mkForce false; # Ensure this remains off

  environment.systemPackages = lib.mkIf config.services.pipewire.enable [
    pkgs.qpwgraph
  ];
}
