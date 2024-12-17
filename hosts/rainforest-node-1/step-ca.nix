{ config, ... }:
{
  deployment.keys.step-ca = {
    destDir = "/var/lib/secrets/stepca";
    user = "step-ca";
    group = "step-ca";
    keyCommand = [
      "gpg"
      "--decrypt"
      (toString ../../secrets/stepca-intermediate.gpg)
    ];
  };

  networking.firewall.allowedTCPPorts = [
    443
    80
  ];

  services.step-ca = {
    enable = true;
    intermediatePasswordFile = config.deployment.keys.step-ca.path;
    port = 443;
    address = "0.0.0.0";
    settings = {
      address = ":443";
      authority = {
        backdate = "1m0s";
        provisioners = [
          {
            claims = {
              allowRenewalAfterExpiry = false;
              disableRenewal = false;
              disableSmallstepExtensions = false;
              enableSSHCA = true;
            };
            name = "acme";
            options = {
              ssh = { };
              x509 = { };
            };
            type = "ACME";
          }
        ];
        template = { };
      };
      commonName = "Step Online CA";
      crt = "/var/lib/step-ca/.step/certs/intermediate_ca.crt";
      db = {
        badgerFileLoadingMode = "";
        dataSource = "/var/lib/step-ca/.step/db";
        type = "badgerv2";
      };
      dnsNames = [ "ca.ratlabs.co" ];
      federatedRoots = null;
      insecureAddress = "";
      key = "/var/lib/step-ca/.step/secrets/intermediate_ca_key";
      logger.format = "text";
      root = "/var/lib/step-ca/.step/certs/root_ca.crt";
      tls = {
        cipherSuites = [
          "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256"
          "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256"
        ];
        maxVersion = 1.3;
        minVersion = 1.2;
        renegotiation = false;
      };

    };
    openFirewall = true;
  };
}
