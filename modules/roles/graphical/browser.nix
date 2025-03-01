{ pkgs, lib, ... }:
{
  programs.firefox = {
    package = pkgs.librewolf;
    enable = lib.mkDefault true;
    preferences = {
      "webgl.disabled" = false;
      "privacy.clearOnShutdown.history" = false;
      "middlemouse.paste" = false;
    };
    policies.ExtensionSettings = {
      "uBlock0@raymondhill.net" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        installation_mode = "force_installed";
      };
      "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        installation_mode = "force_installed";
      };
      "jid1-MnnxcxisBPnSXQ@jetpack" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
        installation_mode = "force_installed";
      };

    };

  };

}
