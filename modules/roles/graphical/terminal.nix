{ pkgs, ... }:
let
  bar = pkgs.fetchFromGitHub {
    owner = "adriankarlen";
    repo = "bar.wezterm";
    rev = "ccdb5ad64a73e2fe96f93a1fc0adb8fe73f5d139";
    hash = "sha256-YGJGaZYbOXkNYcZ3Lkk/mEodF4ivvje+TrcKBMitDS0=";
  };

  pluginsBundled = pkgs.linkFarm "plugins-bundled" [
    {
      path = bar;
      name = "bar";
    }
  ];

  weztermConfig = pkgs.writeText "config.lua" ''
    local wezterm = require("wezterm")
    local config = wezterm.config_builder()

    config.font = wezterm.font_with_fallback {
        "Terminus",
        "JetbrainsMono Nerd Font",
        "Font Awesome 6 Free",
        "Font Awesome 6 Brands",
        "Noto Color Emoji",
        "Material Design Icons"
    }

    -- config.color_scheme = "Darkside (Gogh)"
    config.color_scheme = "OneHalfDark"
    config.window_padding = {
      left = 0,
      right = 0,
      top = 0,
      bottom = 0,
    }
    config.warn_about_missing_glyphs = false

    return config

  '';
in
{
  environment.plasma6.excludePackages = [ pkgs.kdePackages.konsole ];

  environment.systemPackages = pkgs.lib.singleton (
    pkgs.symlinkJoin {
      name = "wezterm-wrapped";
      paths = [
        pkgs.wezterm
      ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      meta.mainProgram = "wezterm";
      postBuild = ''
        wrapProgram $out/bin/wezterm  \
           --set WEZTERM_CONFIG_FILE ${weztermConfig}

      '';
    }
  );

}
