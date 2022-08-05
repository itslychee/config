{ pkgs, ...}:
let
  cocPackage = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "coc.nvim";
    version = "2022-05-21";
    src = pkgs.fetchFromGitHub {
      owner = "neoclide";
      repo = "coc.nvim";
      rev = "791c9f673b882768486450e73d8bda10e391401d";
      sha256 = "sha256-MobgwhFQ1Ld7pFknsurSFAsN5v+vGbEFojTAYD/kI9c=";
    };
    meta.homepage = "https://github.com/neoclide/coc.nvim/";
  };
in {
  programs.neovim = {
    enable = true;
    coc = {
      enable = true;
      package = cocPackage;
      settings = {
        "suggest.noselect" = true;
        "suggest.enablePreselect" = false;
       	"suggest.enablePreview" = true;
        languageserver = {
          go = {
            command = "gopls";
            rootPatterns = [ "go.mod" ];
            "trace.server" = "verbose";
            filetypes = [ "go" "go.mod" "go.work" ];
          };
        };
      };
    };
    extraConfig = builtins.readFile ./vimrc;
    plugins = with pkgs.vimPlugins; [
     vim-airline-themes
     vim-airline
	 vim-polyglot
     sonokai
     nvim-colorizer-lua
     (nvim-tree-lua.overrideAttrs (_: {
       src = pkgs.fetchFromGitHub {
         repo = "nvim-tree.lua";
         owner = "kyazdani42";
         rev = "104292c8f908300e44c0142722746c50fdfa9859";
         sha256 = "sha256-9ahNp9WMxzY5MYB/YxJJe7sgbQpGHiauuiOdBY+LHbg=";
       };
     }))
     (pkgs.vimUtils.buildVimPlugin {
       name = "yuck.vim";
       src = pkgs.fetchFromGitHub {
         owner = "elkowar";
         repo = "yuck.vim";
         rev = "6dc3da77c53820c32648cf67cbdbdfb6994f4e08";
         sha256 = "sha256-lp7qJWkvelVfoLCyI0aAiajTC+0W1BzDhmtta7tnICE=";
       };
     })
    ];
    # Aliases
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
  };
}
