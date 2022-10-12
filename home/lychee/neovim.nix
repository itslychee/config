{ pkgs, ...}:
{
  programs.neovim = {
    enable = true;
    extraConfig = builtins.readFile ./vimrc;
    coc = {
      enable = true;
      package = pkgs.unstable.vimPlugins.coc-nvim;
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
		nvim-colorizer-lua
        vim-hexokinase
        sonokai
		vim-polyglot
    ];
    # Aliases
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
  };
}
