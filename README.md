# itslychee/config

## hosts
- `hosts/hearth` -  main computer
- `hosts/hellfire` - raspberry pi
- `hosts/iso` - multi-arch ISO image

## building ISO

Simply run `nix build` to build `iso`, otherwise pass `.#hellfire` to build
hellfire's ISO.
