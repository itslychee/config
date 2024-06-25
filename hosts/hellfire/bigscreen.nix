{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.hey.caps) graphical;
in {
  # Bigscreen
  services.xserver.desktopManager.plasma5 = mkIf graphical {
    bigscreen.enable = false;
  };
  services.displayManager.sddm = mkIf graphical {
    enable = true;
    wayland.enable = true;
    settings = {
      Autologin = {
        User = "viewer";
        Session = "plasma-bigscreen-wayland";
        Relogin = true;
      };
    };
  };

  nixpkgs.overlays = [
    (_final: prev: {
      libcec = prev.libcec.override {withLibraspberrypi = true;};
    })
  ];

  hey = {
    users = mkIf graphical {
      viewer = {
        enable = false;
        groups = ["video" "uinput"];
      };
    };
    # users.lychee.enable = lib.mkForce false;
  };

  fileSystems."/home/viewer/.cache" = mkIf graphical {
    device = "none";
    fsType = "tmpfs";
  };
}
