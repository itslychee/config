{
  pkgs,
  config,
  ...
}:
{
  # should be obvious why this is global
  hey.users.lychee = {
    enable = true;
    hashedPassword = "$y$j9T$kDsIrEIkHOucclmZa6hRK/$O6av0rpCl9lMFHe.u8W96cvFZon08OM8Usq935rGuLB";
    groups = [
      "wheel"
      "audio"
      "dialout"
      "libvirtd"
      "video" # needed for light
      "networkmanager"
      "wireshark"
    ];
    sshKeys = config.hey.keys.lychee.ssh;
    files = {
      ".config/git/config".text = ''
        [commit]
            gpgSign = true
        [core]
            pager = "${pkgs.delta}/bin/delta"
        [gpg]
            program = "${pkgs.gnupg}/bin/gpg2"
        [interactive]
            diffFilter = "${pkgs.delta}/bin/delta --color-only"
        [tag]
            gpgSign = true
        [user]
            email = "itslychee@proton.me"
            name = "itslychee"
            signingKey = "8684A1194DF12A0F"
      '';
      ".config/git/ignore".text = ''
        .direnv
      '';

    };
  };
}
