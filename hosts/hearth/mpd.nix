{pkgs, ...}: let
    mpdConfig = pkgs.writeText "mpd.conf" ''
        db_file                 "/storage/data/mpd/db"
        state_file              "/storage/data/mpd/state"
        playlist_directory      "/storage/data/mpd/playlists"
        music_directory         "/storage/media/music"
        sticker_file            "/storage/data/mpd/sticker.db"
        log_file                "syslog"
        bind_to_address         "127.0.0.1"

        auto_update "yes"
        audio_output {
            type "pipewire"
            name "pipewire server"
        }
    '';
in {
    systemd.user.services.mpd = {
        wantedBy = [ "default.target"];
        requires = [ "pipewire.service" ];
        after = [ "pipewire.service" ];
        unitConfig.ConditionUser = "lychee";
        serviceConfig = {
            Type = "notify";
            ExecStart = "${pkgs.mpd}/bin/mpd --systemd ${mpdConfig}";

            # allow MPD to use real-time priority 40
            LimitRTPRIO=40;
            LimitRTTIME= "infinity";
            
        };
    };
}
