{ pkgs, flags, ...}:
with pkgs;
let
  guiOnly = !flags.headless or false;
in
{
  programs = {
   btop.enable = true;
   exa.enable = true;
   exa.enableAliases = true;
   direnv.enable = true;
   direnv.nix-direnv.enable = true;
   ssh = {
      enable = true;
      compression = true;
      matchBlocks = {
        "server" = {
          hostname = "lefishe.club";
          user = "lychee";
        };
      };
    };

  # Desktop programs only
  mpv.enable = guiOnly; 
  ncmpcpp = {
    enable = guiOnly; 
    bindings = [
      { key = "j"; command = "scroll_down"; }
      { key = "k"; command = "scroll_up"; }
      { key = "J"; command = ["select_item" "scroll_down"]; }
      { key = "K"; command = ["select_item" "scroll_up"]; }
    ];
  };
  alacritty = {
    enable = guiOnly;
    settings = {
      scrolling.multiplier = 3;
      font.size = 11;
      draw_bold_text_with_bright_colors = true;
      cursor.style.blinking = "On";
      window.opacity = 0.95;
    };
  };
  swaylock = {
    enable = guiOnly;
    settings = {
      color = "FFA9D2";
      font-size = 30;
      show-failed-attempts = true;
      ignore-empty-password = true;
      daemonize = true;
      indicator-caps-lock = true;
      font = "Terminus";
    };
  };
};
}
