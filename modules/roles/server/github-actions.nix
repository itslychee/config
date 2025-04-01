{
  lib,
  config,
  inputs,
  ...
}:
{

  options.hey.github = {
    enable = lib.mkEnableOption "github runner";
  };
  config = lib.mkIf config.hey.github.enable {
    deployment.keys.github-runner-pat = {
      destDir = "/var/lib/secrets/github-runner";
      keyCommand = [
        "gpg"
        "--decrypt"
        "${inputs.self}/secrets/github-runner-pat.gpg"
      ];
    };
    services.github-runners =
      lib.genAttrs
        [
          "${config.networking.hostName}_1"
          "${config.networking.hostName}_2"
          "${config.networking.hostName}_3"
          "${config.networking.hostName}_4"
          "${config.networking.hostName}_5"
        ]
        (_: {
          enable = true;
          url = "https://github.com/wires-org";
          tokenFile = config.deployment.keys.github-runner-pat.path;
          ephemeral = true;
          replace = true;
          runnerGroup = "lychee";
          extraLabels = [
            "public-self-hosted"
            config.networking.hostName
          ];
        });

  };
}
