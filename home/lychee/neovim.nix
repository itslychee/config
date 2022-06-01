{ pkgs, ...}:
{
  programs.neovim = {
    enable = true;
    coc = {
      enable = false;
      package = pkgs.vimPlugins.coc-nvim;
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

    ];
    extraConfig = ''
    set number
    set guicursor=""
    set nocompatible
    set termguicolors
    set nowrap

    let &t_SI = "\e[0 q"
    let &t_EI = "\e[0 q"

    syntax on
    filetype plugin indent on
    let g:airline_theme='ayu_mirage'

    colorscheme onedark
    '';
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;

  };
}
