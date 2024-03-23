{pkgs, ...}: {
  environment.defaultPackages = [pkgs.git];

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };

  programs.zsh = {
    enable = true;
    enableLsColors = false;
    vteIntegration = true;
    syntaxHighlighting.enable = true;
    enableBashCompletion = true;
    autosuggestions.enable = true;
    shellInit = ''
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
    '';
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
      format = ''
        [\[$directory$git_branch$git_state$git_commit\]](bold green)
        [❤️ $username$hostname](bold #ff9ad2)$character
      '';
      right_format = "$rust$golang$python$nix_shell";
      character = {
        success_symbol = "➜";
        error_symbol = "➜";
      };
    };
  };
}
