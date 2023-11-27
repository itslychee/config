{ pkgs, lib, ...}:
{
  programs = {
    git = {  
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      delta = {
        enable = true;
        options.line-numbers = true;
      };
      ignores = [ ".envrc" "*.swp" ".direnv/" ];
      extraConfig = {
        core.editor = "${pkgs.neovim}/bin/nvim --clean";
        gpg.format = "ssh";
        user.signingkey = "~/.ssh/id_ed25519.pub";
        push.gpgSign = "if-asked";
        commit.gpgsign = true;
        merge.ff = false;
        pull.rebase = "merges";
        user = { email = "itslychee@protonmail.com"; name = "lychee"; };
      };
    };
    # GPG
    gpg.enable = true;
    ssh = {
      enable = true;
      compression = true;
      extraConfig = "AddKeysToAgent yes";
    };
  };
  services = {
    ssh-agent.enable = true;
    gpg-agent = {
      enable = true;
      pinentryFlavor = "tty";
      extraConfig = "no-allow-external-cache";
    };
  };
  systemd.user.services.ssh-agent = {
    # I want a timeout
    Service.ExecStart = lib.mkForce "${pkgs.openssh}/bin/ssh-agent -D -t 1h -a %t/ssh-agent";
  };
}
