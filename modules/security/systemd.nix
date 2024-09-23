{
  systemd =
    let
      extraConfig = ''
        DefaultTimeoutStartSec=10s
        DefaultTimeoutStopSec=10s
        DefaultTimeoutAbortSec=10s
        DefaultDeviceTimeoutSec=10s
      '';
    in
    {
      # thank u raf
      inherit extraConfig;
      user.extraConfig = extraConfig;
    };
}
