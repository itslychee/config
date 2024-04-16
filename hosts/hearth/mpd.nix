{pkgs, inputs, ...}: {
  home-manager.sharedModules = [
    inputs.mpdrp.homeManagerModules.default
    {
      home.packages = [pkgs.libnotify pkgs.mpc_cli];
      programs.mpdrp.enable = true;
      services = {
        mpd = {
          enable = true;
          musicDirectory = "/storage/media/music";
          dataDir = "/storage/data/mpd";
          extraArgs = ["--verbose"];
          extraConfig = ''
            audio_output {
                type "pipewire"
                name "pipewire"
            }
            audio_output {
                type   "fifo"
                name   "my_fifo"
                path   "~/.cache/mpd.fifo"
                format "44100:16:2"
            }
          '';
        };
        mpdris2.enable = true;
      };

      # MPD Client
      programs.ncmpcpp = {
        enable = true;
        package = pkgs.ncmpcpp.override {visualizerSupport = true;};
        bindings = [
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
        settings = {
          display_bitrate = "yes";
          jump_to_now_playing_song_at_start = "yes";
          fetch_lyrics_for_current_song_in_background = "no";
          incremental_seeking = "yes";
          progressbar_look = "╼O=";
          progressbar_color = "green";
          user_interface = "alternative";
          main_window_color = "blue";
          alternative_ui_separator_color = "blue";
          show_hidden_files_in_local_browser = "no";
          allow_for_physical_item_deletion = "yes";
          centered_cursor = "yes";
          autocenter_mode = "yes";
          startup_screen = "visualizer";
          playlist_display_mode = "classic";
          visualizer_data_source = "~/.cache/mpd.fifo";
          visualizer_in_stereo = "yes";
          visualizer_type = "wave_filled";
          visualizer_look = "••";
          visualizer_output_name = "FIFO output";
          visualizer_color = "blue";
          visualizer_autoscale = "yes";
          visualizer_spectrum_smooth_look = "yes";
          visualizer_fps = "120";
        };
      };
    }
  ];
}
