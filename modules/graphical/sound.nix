{lib, ...}: {
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
  sound.enable = lib.mkForce false; # Ensure this remains off
  hardware.pulseaudio.enable = lib.mkForce false; # Ensure this remains off
}
