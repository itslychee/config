{ config, pkgs, ...}:
{
  
  config.programs.alacritty = {
    enable = true;
    settings = {
      title = "alacritty";
      dynamic_title = true;
      window = {
        dynamic_padding = true;
        # opacity = 0.90;
        decorations = "none";
      };
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
    };
  };
}
