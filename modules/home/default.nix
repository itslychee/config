# NOTE:
# These are meant to be used by ../home.nix, and are relative for each
# user, so any user can use these options. im so smart :)
#
# Guidelines for modules inside here:
# - They should strictly be user-unaware
# - Useful defaults should be enabled by default
# umm uhhh, :) :) wires wires
{
  imports = [
    ./sway-env.nix
    ./wrappers.nix
  ];
}
