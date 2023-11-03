{ pkgs, ...}@args:
{
  imports = [
    ./starship.nix
  ];
  home.shellAliases = {
    "tree" = "${pkgs.exa}/bin/exa --tree";
    "htop" = "${pkgs.btop}/bin/btop";
    "rebuild" = "sudo nixos-rebuild switch --flake .";
    "up" = "sudo nix flake update && sudo nixos-rebuild switch --flake .";
  };
  
  programs.bash.enable = true;

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
      setopt PROMPT_SUBST
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      bindkey -v '^?' backward-delete-char
    '';
  };
}
