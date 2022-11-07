{ pkgs, ...}:
{
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    package = pkgs.vscodium;
    userSettings = {
      "[nix]"."editor.tabSize" = 2;

    };
  };
}
