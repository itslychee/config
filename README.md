# itslychee/config

my nixos configuration, designed with multi-user and multi-host in mind, as I
value extensibility.

## hosts
- `hosts/hearth` -  main computer
- `hosts/hellfire` - raspberry pi
- `hosts/iso` - multi-arch ISO image
- `hosts/wirescloud` - hetzner server instance
- `hosts/wiretop` - former school laptop repurposed for NixOS

## Building ISO

Simply run `nix build` to build `iso`, otherwise pass `.#hellfire` to build
hellfire's ISO. You can also specify architectures via `nix build .#iso-ARCH`

## acknowledgements

I drew inspiration from these users, no matter how big or small
it was.

- https://github.com/Gerg-L/nixos
- https://github.com/NobbZ/nixos-config
- https://github.com/nu-nu-ko/crystal

These configurations taught me the importance of the module system and how it can be used
to your advantage, you can look at the other branches in the repository and you will see the difference :D

