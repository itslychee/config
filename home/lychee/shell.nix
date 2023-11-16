{ pkgs, headless, ...}:
with pkgs.lib;
{
  # Aliases
  home.shellAliases.tree = "exa --tree";
  home.shellAliases.htop = "btop";
  home.sessionVariables.DIRENV_LOG_FORMAT = "";
  # Zsh!
  programs.zsh.enable = true;
  programs.zsh.enableAutosuggestions = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.enableVteIntegration = true;
  programs.zsh.autocd = true;
  programs.zsh.history.ignoreDups = true;
  programs.zsh.initExtra = ''
    setopt PROMPT_SUBST
    bindkey "^[[1;5C" forward-word
    bindkey "^[[1;5D" backward-word
    bindkey -v '^?' backward-delete-char
  '';
  # Starship
  programs.starship.enable = true;
  programs.starship.settings = {
    hostname.format = "in [$ssh_symbol$hostname]($style)";
    username = {
      style_user = "bold cyan";
      format = "[$user]($style)";
    };
    nix_shell.format = "$symbol[nixshell]($style)";
    python.format = "[\${symbol}\${pyenv_prefix}(\${version} )(\($virtualenv\) )]($style)";
    rust.format = "[$symbol($version )]($style)";
    git_branch = {
      symbol = "  ";
      format = "[$symbol$branch(:$remote_branch)]($style)";
    };
    golang.format = "go($version)";
    format = ''
    [\[$directory$git_branch$git_state$git_commit\]](bold green)
    [❤️ $username$hostname](bold #ff9ad2)$character
    '';
    right_format = ''$rust$golang$python$nix_shell'';
    character = {
      success_symbol = "➜";
      error_symbol = "➜";
    };
  };
  # CLI utilities
  programs.btop.enable = true;
  programs.eza.enable = true;
  programs.eza.enableAliases = true;
  programs.ripgrep.enable = true;
  programs.ripgrep.arguments = [
    "--max-columns=150"
    "--max-columns-preview"
  ];
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  # Alacritty
  programs.alacritty = mkIf (!headless) {
    enable = true;
    settings = {
      scrolling.multiplier = 3;
      font.size = 12;
      draw_bold_text_with_bright_colors = true;
      cursor.style.blinking = "On";
      window.opacity = 0.95;
    };
  };
}
