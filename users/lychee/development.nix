{
  programs = {
    git = {
      enable = true;
      delta.enable = true;
      userName = "itslychee";
      userEmail = "itslychee@protonmail.com";
      signing = {
        signByDefault = true;
        key = "45324E7F52DA3BA3";
      };
      ignores = ["*.swp" "*~"];
    };
  };

  home.file.".gnupg/sshcontrol" = {
    force = true;
    text = ''
      932A393893C9BCD3A179010B2917AD4447972B25
    '';
  };
}
