{ config, pkgs, headless, lib, ...}:
let
  inherit (lib) mkIf;
in {
  imports = [
    ./starship.nix
  ];

  home.shellAliases = {
    tree = "exa --tree";
    htop = "btop";
  };
  home.sessionVariables = {
    DIRENV_LOG_FORMAT = "";
    GOPATH = "${config.home.homeDirectory}/.local/go";
  };

  programs = {
    # Terminal
    alacritty = mkIf (!headless) {
      enable = true;
      settings = {
        scrolling.multiplier = 3;
        font.size = 12;
        font.bold.style = "Regular";
        font.italic.style = "Regular";
        font.bold_italic.style = "Regular";
        draw_bold_text_with_bright_colors = true;
        cursor.style.blinking = "On";
        window.opacity = 0.95;
      };
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableVteIntegration = true;
      autocd = true;
      history.ignoreDups = true;
      initExtra = ''
        setopt PROMPT_SUBST
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
        bindkey -v '^?' backward-delete-char
      '';
    };
    # CLI utilities
    btop.enable = true;
    eza.enable = true;
    eza.enableAliases = true;
    ripgrep.enable = true;
    ripgrep.arguments = [
      "--no-ignore"
      "--max-columns=150"
      "--max-columns-preview"
    ];
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    nix-index.enable = true;
  };
}
