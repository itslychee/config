{
  pkgs,
  config,
  ...
}: {
  # should be obvious why this is global
  hey.users.lychee = {
    enable = true;
    usePasswdFile = true;
    passwordFile =
      (pkgs.writeText
        "hash" "$y$j9T$i6s3FePGTaI/qFEI.DGnO/$Z80iTqKXQCu3AF8qsOkThNFN/eHisyfXirpjSZ4N.N6")
      .outPath;
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
  };
}
