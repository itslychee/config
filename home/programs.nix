{ pkgs, flags, ...}:
{
  home.shellAliases = {
    "tree" = "${pkgs.exa}/bin/exa --tree";
    "htop" = "${pkgs.btop}/bin/btop";
  };
  
  programs = {
    mpv.enable = !flags.headless or false;
    bash.enable = true;
    btop.enable = true;
    exa = {
      enable = true;
      enableAliases = true;
    };
    alacritty = {
      enable = !flags.headless or false;
      settings = {
        scrolling.multiplier = 3;
        font.size = 12;
        draw_bold_text_with_bright_colors = true;
        cursor.style.blinking = "On";
      };
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
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
    ncmpcpp = {
      enable = true;
      bindings = [
        { key = "j"; command = "scroll_down"; }
        { key = "k"; command = "scroll_up"; }
        { key = "J"; command = ["select_item" "scroll_down"]; }
        { key = "K"; command = ["select_item" "scroll_up"]; }
      ];
    };
  };
}
