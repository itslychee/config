{ 
  git ? {
    enable = true;
    userName = "Lychee";
    userEmail = "itslychee@protonmail.com";
    withDelta = true;
  },
  gpg ? true,
  ssh ? true,
  gpgAgent ? true,
  sshAgent ? true,
}:
{ config, lib, ...}:
with lib;
{
  config = mkDefault {
    programs = {
      git = rec {
        inherit (git) userName userEmail enable;
        signing = {
          signByDefault = true;
          key = userEmail;
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
      };
    };
    services.gpg-agent = {
      enable = gpgAgent;
      pinentryFlavor = "tty";
      enableSshSupport = sshAgent;
    };
  };
}
