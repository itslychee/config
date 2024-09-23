{
  pkgs,
  config,
  ...
}:
{
  # should be obvious why this is global
  hey.users.lychee = {
    enable = true;
    hashedPassword = "$y$j9T$i6s3FePGTaI/qFEI.DGnO/$Z80iTqKXQCu3AF8qsOkThNFN/eHisyfXirpjSZ4N.N6";
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
            email = "itslychee@protonmail.com"
            name = "itslychee"
            signingKey = "45324E7F52DA3BA3"
      '';
    };
  };
}
