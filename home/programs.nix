{ pkgs, flags, ...}:
{
  home.shellAliases = {
    "tree" = "${pkgs.exa}/bin/exa --tree";
  };
  
  programs = {
    neovim = {
      enable = true;
      coc = {
        enable = true;
        settings = {
          "suggest.noselect" = true;
          "suggest.enablePreview" = true;
          "suggest.enablePreselect" = false;
          "suggest.disableKind" = true;
          languageserver = {
            nix = {
              command = "${pkgs.rnix-lsp}/bin/rnix-lsp";
              filetypes = [ "nix" ];
            };
          };
        };
      };
      plugins = with pkgs.vimPlugins; [
        vim-startify
        yankring
        vim-nix
        vim-polyglot
      ];
    };
    btop.enable = true;
    exa = {
      enable = true;
      enableAliases = true;
    };
    alacritty = {
      enable = !flags.headless or false;
      settings = {
        scrolling.multiplier = 3;
        font.size = 11;
        draw_bold_text_with_bright_colors = true;
        cursor.style.blinking = "On";
      };
    };
  };
}
