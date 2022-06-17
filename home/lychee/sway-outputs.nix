{ hostname, ...}:
let 
  defaultOptions = {
    bg = "~/.wallpaper-image fill";
  };
  outputs = (
    if (hostname == "kremlin") then {
      "HDMI-A-1".resolution = "1920x1080@144.001Hz";
    }
    else if (hostname == "laptop") then {
      "eDP-1".resolution = "1366x768@60.020Hz";
    }
    else builtins.abort "no output for hostname '${hostname}'"
  );
in with builtins; mapAttrs (name: val: val // defaultOptions) outputs
