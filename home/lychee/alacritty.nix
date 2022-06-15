{ config, pkgs, ...}:
{
  
  config.programs.alacritty = {
      enable = true;
      settings = {
        title = "alacritty";
        dynamic_title = true;
        window.decorations = "none";
        draw_bold_text_with_bright_colors = true;
        font = {
          normal.family = "JetBrains Mono";
          normal.style = "Medium";
          size = 10;
        };
        cursor = {
          style = {
            shape = "Beam";
            blinking = "On";
          };
          blink_interval = 900;
          thickness = 0.25;
        };
        live_config_reload = true;
        colors = {
          # Colors (Ayu Dark)

          # Default colors
          primary = {
            background = "0x0A0E14";
            foreground = "0xB3B1AD";
          };
          # Normal colors
          normal = {
            black = "0x01060E";
            red   = "0xEA6C73";
            green = "0x91B362";
            yellow =  "0xF9AF4F";
            blue = "0x53BDFA";
            magenta = "0xFAE994";
            cyan = "0x90E1C6";
            white = "0xC7C7C7";
          };

          # Bright colors
          bright = {
            black = "0x686868";
            red = "0xF07178";
            green = "0xC2D94C";
            yellow = "0xFFB454";
            blue = "0x59C2FF";
            magenta = "0xFFEE99";
            cyan = "0x95E6CB";
            white = "0xFFFFFF";
          };
        };
     };
  };
}
