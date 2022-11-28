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
          rust = {
            command = "rust-analyzer";
            filetypes = [ "rust" "rs" ];
            rootPatterns = [ "Cargo.toml" ];
          };
        };
      };
    };
    plugins = with pkgs.vimPlugins; [
		(nvim-tree-lua.overrideAttrs (_: {
          src = pkgs.fetchFromGitHub {
            repo = "nvim-tree.lua";
            owner = "kyazdani42";
            rev = "c446527056e92a57b51e2f79be47c28ba8ed43e4";
            sha256 = "sha256-l/UXZ+zV8oxXijrLh2DevoFCyOclf69mvG9XWTN5ytA=";
          };
        }))
		vim-easy-align
		nvim-web-devicons
		nvim-colorizer-lua
        vim-hexokinase
		vim-polyglot
        srcery-vim
    ];
    # Aliases
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
  };
}
