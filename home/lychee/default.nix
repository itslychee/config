{ config, pkgs, lib, headless, ...}:
{
  imports = [
    ./shell.nix
    ./nvim.nix
  ] 
  ++ lib.optionals (!headless) [
    ./graphical.nix
    ./sway.nix
    ./mpd.nix
    ./waybar.nix
    ./firefox.nix
  ] 
  ++ lib.optionals headless [];
  # Git
  programs.git.enable = true;
  programs.git.package = pkgs.gitAndTools.gitFull;
  programs.git.delta = { enable = true; options.line-numbers = true; };
  programs.git.ignores = [ "*.swp" ".direnv/"];
  programs.git.extraConfig = {
    core.editor = "${pkgs.neovim}/bin/nvim --clean";
    gpg.format = "ssh";
    user.signingkey = "~/.ssh/id_ed25519.pub";
    push.gpgSign = "if-asked";
    commit.gpgsign = true;
    merge.ff = false;
    pull.rebase = "merges";
    user = { email = "itslychee@protonmail.com"; name = "lychee"; };
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
  # services.ssh-agent.enable = true;
  # systemd.user.services.ssh-agent = {
  #   # I want a timeout
  #   Service.ExecStart = lib.mkForce "${pkgs.openssh}/bin/ssh-agent -D -t 1h -a %t/ssh-agent";
  # };

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

  home.packages = with pkgs;
  lib.optionals (!headless) [
    # Discord
    discord-canary xdg-utils
    # Screenshot
    grim slurp wayshot
    # Clipboard
    wl-clipboard
  ];
}
