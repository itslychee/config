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
}
