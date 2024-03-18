{
  pkgs,
  lib,
  config,
  ...
}: let
  git = config.programs.git;
  zsh = config.programs.zsh;
  gitConf = pkgs.formats.gitIni {};
  inherit (lib) mkOption mkEnableOption mkIf mkMerge;
in {
  options = {
    programs.git = {
      enable = mkEnableOption "Git";
      config = mkOption {
          inherit (gitConf) type;
      };
    };
    programs.zsh = {
        enable = mkEnableOption "Zsh configuration";
        init = mkOption {
            type = lib.types.lines;
        };
    };
  };
  config = mkMerge [
      (mkIf git.enable {
        root.".config/git/config".source = gitConf.generate "git" git.config;
      })
    
    

  ];
}
