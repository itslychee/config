{lib, ...}: let
  colorOption = hexcode:
    lib.mkOption {
      description = "color option for ${hexcode}";
      default = hexcode;
      type = lib.types.str;
    };
in {
  options.hey.theme = {
    primary = colorOption "#C89FA3";
    secondary = colorOption "#536271";
    accent = colorOption "#b56e96";
    foreground = colorOption "#D6B7BA";
    background = colorOption "#3E4C5E";
  };
}
