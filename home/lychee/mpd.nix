{ pkgs, ...}:
{
  services = {
    mpdris2.enable = true;
    mpd = {
      enable = true;
      extraConfig = ''
        audio_output {
          type "pulse"
          name "PulseAudio"
          auto_resample "no"
          # samplerate_converter            "internal"
          use_mmap "yes"
        }
       '';
       musicDirectory = /mnt/storage/media/music;
     };
   };

   systemd.user.services = with pkgs.lib; {
     mpdris2.Service.Restart = mkForce "always";
     mpd.Service.Restart = mkForce "always";
   };

   programs.ncmpcpp = {
     enable = true;
     package = pkgs.ncmpcpp.override (_: { visualizerSupport = true; clockSupport = true; });
     settings = {
      display_bitrate = "yes";
      jump_to_now_playing_song_at_start = "yes";
      fetch_lyrics_for_current_song_in_background = "no";
      incremental_seeking = "yes";
      progressbar_look  = "╼O=";
      progressbar_color = "magenta";
      user_interface = "alternative";
      main_window_color = "cyan";
      alternative_ui_separator_color = "cyan";
      show_hidden_files_in_local_browser = "no";
      allow_for_physical_item_deletion = "yes";
      centered_cursor = "yes";
      autocenter_mode = "yes";
      playlist_display_mode = "classic";
    };
  };
}
