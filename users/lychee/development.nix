{
  programs = {
    ssh = {
      enable = true;
      compression = true;
      addKeysToAgent = "yes";
    };

    git = {
      enable = true;
      difftastic.enable = true;
      userName = "itslychee";
      userEmail = "itslychee@protonmail.com";
      signing = {
        signByDefault = true;
        key = "~/.ssh/id_ed25519";
      };
      extraConfig.gpg.format = "ssh";
      ignores = [
        "*.swp"
        "*~"
      ];
    };
  };
}
