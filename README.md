# itslychee/config

## hosts
- `hosts/hearth` -  main computer
- `hosts/hellfire` - raspberry pi
- `hosts/iso` - multi-arch ISO image
- `hosts/wirescloud` - hetzner server instance

## building ISO

Simply run `nix build` to build `iso`, otherwise pass `.#hellfire` to build
hellfire's ISO.

## rules of this config

- specific options stay in their specific host files
- if the option is widely used, then it must be a module
- if a module's option is widely used, then it must be enabled by default
- modules must be declared under the `hey` option namespace to prevent conflicts.
- packages that are for a specific user must be available only for this user.
- the code must be readable

basically the rules here are simple, keep the scope as small as possible as long
as it makes sense to. This keeps the system modular and I like to think it makes it feel
cleaner!!!

got a problem with this design? guess what I don't care.

## acknowledgements

my config was inspired from

- https://github.com/nu-nu-ko/crystal
- https://github.com/Gerg-L/nixos
- https://github.com/NobbZ/nixos-config

much love to those users <3
