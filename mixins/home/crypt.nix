{ 
  git,
  gpg ? true,
  ssh ? true,
  gpgAgent ? true,
}:
{ config, lib, ...}:
with lib;
{
  config = mkOverride 500 {
    programs = {
      git = rec {
        inherit (git) userName userEmail enable;

        extraConfig = {
          user = {
            email = "itslychee@protonmail.com";
            name = "Lychee";
            signingkey = "~/.ssh/id_ed25519.pub";
          };
          gpg.format = "ssh";
          commit.gpgsign = true;
        };
        delta = {
          enable = git.withDelta;
          options.line-numbers = true;
        };
        extraConfig.core.editor = config.home.sessionVariables.EDITOR; 
      };
      # NOTE: Support GPG and SSH private keys!
      gpg.enable = gpg;
      ssh = {
        enable = ssh;
        compression = true;
        # TODO: match blocks!
        extraConfig = ''
          AddKeysToAgent yes
        '';
        matchBlocks = {
          "pi" = {
            hostname = "192.168.0.2";
            user = "pi";
          };
        };
      };
    };
    services.gpg-agent = {
      enable = gpgAgent;
      pinentryFlavor = "tty";
      extraConfig = ''
        no-allow-external-cache
      '';
    };
  };
}
