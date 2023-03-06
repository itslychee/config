{ pkgs, flags, ...}:
{
  home.shellAliases = {
    "tree" = "${pkgs.exa}/bin/exa --tree";
  };
  
  programs = {
    bash.enable = true;
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
            # Language servers
            nix = {
              command = "${pkgs.rnix-lsp}/bin/rnix-lsp";
              filetypes = [ "nix" ];
            };
            rust = {
              command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
              filetypes = [ "rust" ];
              rootPatterns = [ "Cargo.toml" ];
            };
          };
        };
      };
      extraConfig = ''
       set number
       set nowrap
       colorscheme everforest
      '';
      extraLuaConfig = ''
        vim.api.nvim_set_keymap('n', '<c-P>', "<cmd>lua require 'fzf-lua'.files()<CR>",
        { noremap = true, silent = true }
        )
      '';
      plugins = with pkgs.vimPlugins; [
        vim-startify
        yankring
        vim-nix
        vim-polyglot
        coc-pairs
        everforest
        fzf-lua
        fzfWrapper
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
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
