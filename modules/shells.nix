{
  programs.autojump.enable = true;

  programs.zsh = {
    enable = true;
    enableLsColors = false;
    vteIntegration = true;
    syntaxHighlighting.enable = true;
    enableBashCompletion = true;
    autosuggestions.enable = true;
    shellAliases = {
      try = "colmena apply-local --sudo -v";
      deploy = "colmena apply";
    };
    shellInit = ''
      setopt autocd
      zsh-newuser-install() { :; }

      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      bindkey '5~' kill-word
      bindkey '^H' backward-kill-word
    '';
  };
  environment.sessionVariables = {
    ZLE_RPROMPT_INDENT = 0;
  };

  programs.starship = {
    enable = true;
    settings = {
      hostname.format = " in [$ssh_symbol$hostname]($style)";
      username = {
        style_user = "bold cyan";
        format = "[$user]($style)";
      };
      nix_shell.format = "$symbol[nixshell]($style)";
      python.format = "[\${symbol}\${pyenv_prefix}(\${version} )(($virtualenv) )]($style)";
      rust.format = "[$symbol($version )]($style)";
      git_branch = {
        symbol = "  ";
        format = "[$symbol$branch(:$remote_branch)]($style)";
      };
      golang.format = "go($version)";
      git_status.stashed = "stashed";
      format = ''
        [\[$directory$git_branch$git_state$git_commit$git_status\]](bold green)
        [❤️ $username$hostname](bold #ff9ad2)$character
      '';
      character = {
        success_symbol = "➜";
        error_symbol = "➜";
      };
    };
  };
}
