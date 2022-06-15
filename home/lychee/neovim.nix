{ pkgs, ...}:
{
  programs.neovim = {
    enable = true;
    coc = {
      enable = true;
      package = pkgs.vimUtils.buildVimPluginFrom2Nix {
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
      settings = {
        "suggest.noselect" = false;
        "suggest.enablePreselect" = true;
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
      # Status bar
      vim-airline vim-airline-themes
      # Syntax Highlighting
      vim-polyglot
      # Theme
      onedark-vim
      gruvbox

    ];
    extraConfig = ''
    set number
    set guicursor=""
    set nocompatible
    set termguicolors
    set nowrap
    set tabstop=4


    let &t_SI = "\e[0 q"
    let &t_EI = "\e[0 q"

    syntax on
    filetype plugin indent on
    let g:airline_theme='ayu_mirage'

    colorscheme gruvbox 
    '';
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;

  };
}
