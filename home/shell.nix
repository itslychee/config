{ pkgs, ...}@args:
{
  home.shellAliases = {
    "tree" = "${pkgs.exa}/bin/exa --tree";
    "htop" = "${pkgs.btop}/bin/btop";
    "rebuild" = "sudo nixos-rebuild switch --flake .";
    "up" = "sudo nix flake update && sudo nixos-rebuild switch --flake .";
  };
  
  home.sessionVariables = pkgs.lib.mkIf (!args.flags.headless or false) {
    NIX_BUILD_SHELL = "zsh";
  };

  programs.zsh = pkgs.lib.mkIf (!args.flags.headless or false) {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableVteIntegration = true;
    autocd = true;
    history = {
      ignoreDups = true;
    };
    initExtra = ''
      PROMPT='%F{#FFA9D2}%n%f %F{green}%~%f %# '
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
    '';
  };
}
