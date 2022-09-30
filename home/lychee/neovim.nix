{ pkgs, ...}:
{
  programs.neovim = {
    enable = true;
    extraConfig = builtins.readFile ./vimrc;
    plugins = with pkgs.vimPlugins; [
		(nvim-tree-lua.overrideAttrs (_: {
          src = pkgs.fetchFromGitHub {
            repo = "nvim-tree.lua";
            owner = "kyazdani42";
            rev = "104292c8f908300e44c0142722746c50fdfa9859";
            sha256 = "sha256-9ahNp9WMxzY5MYB/YxJJe7sgbQpGHiauuiOdBY+LHbg=";
          };
        }))
		vim-easy-align
		nvim-web-devicons
		vim-go
		zenburn
        molokai
		nvim-colorizer-lua
		vim-polyglot
    ];
    # Aliases
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
  };
}
