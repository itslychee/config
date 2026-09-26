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
      settings.Manager = {
        DefaultDeviceTimeoutSec = "10s";
        DefaultTimeoutAbortSec = "10s";
        DefaultTimeoutStopSec = "10s";
        DefaultTimeoutStartSec = "10s";
      };
      user.extraConfig = extraConfig;
    };
}
