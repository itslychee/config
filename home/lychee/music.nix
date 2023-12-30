{
  config,
  headless,
  pkgs,
  lib,
  inputs,
  ...
}:
lib.mkIf (!headless) ( let
  spicePkgs = inputs.spice.legacyPackages.${pkgs.system};
in {
  # MPD
  services.mpd.enable = true;
  services.mpd.musicDirectory = /storage/media/music;
  services.mpd.network.startWhenNeeded = true;
  services.mpd.extraConfig = ''
    audio_output {
      type "pipewire"
      name "PipeWire"
      auto_resample "no"
      use_mmap "yes"
    }
  '';
  # MPD <-> MPRIS protocol bridge
  services.mpd-mpris.enable = config.services.mpd.enable;
  services.mpd-mpris.mpd.network = "tcp";
  # ncmpcpp MPD client
  programs.ncmpcpp.enable = true;
  programs.ncmpcpp.bindings = [
    {
      key = "j";
      command = "scroll_down";
    }
    {
      key = "k";
      command = "scroll_up";
    }
    {
      key = "J";
      command = ["select_item" "scroll_down"];
    }
    {
      key = "K";
      command = ["select_item" "scroll_up"];
    }
  ];
  # Playerctl daemon
  services.playerctld.enable = true;

  # Rich presence
  programs.mpdrp.enable = true;
  programs.mpdrp.withMpc = true;


  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      hidePodcasts
      adblock
    ];
  };


})
