{ config, pkgs, headless, ...}:
with pkgs.lib;
{
  imports = [
    ./shell.nix 
    ./nvim.nix  
    ./graphical.nix
    ./sway.nix
    ./mpd.nix
    ./waybar.nix
  ];
  # Git
  programs.git.package = pkgs.gitAndTools.gitFull;
  programs.git.delta = { enable = true; options.line-numbers = true; };
  programs.git.extraConfig = {
    core.editor = "${pkgs.nvim}/bin/nvim --clean";
    gpg.format = "ssh";
    user.signingkey = "~/.ssh/id_ed25519.pub";
    push.gpgSign = "if-asked";
    commit.gpgsign = true;
    user = { email = "itslychee@protonmail.com"; name = "lychee"; };
    merge.ff = false;
    pull.rebase = "merges";
  };
  # GPG
  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
  services.gpg-agent.pinentryFlavor = "tty";
  services.gpg-agent.extraConfig = "no-allow-external-cache";
  # SSH
  programs.ssh.enable = true;
  programs.ssh.compression = true;
  programs.ssh.extraConfig = "AddKeysToAgent yes";
  # XDG
  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    desktop     = "${config.home.homeDirectory}/desktop";
    documents   = "${config.home.homeDirectory}/documents";
    download    = "${config.home.homeDirectory}/downloads";
    music       = "${config.home.homeDirectory}/media/music";
    videos      = "${config.home.homeDirectory}/media/videos";
    pictures    = "${config.home.homeDirectory}/media/images";
    templates   = "${config.home.homeDirectory}/media/templates";
    publicShare = "${config.home.homeDirectory}/pub";
  };
}
