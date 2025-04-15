{
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    ignoreIP = [
      "::1"
      "127.0.0.1"
      "100.0.0.0/8"
      "fd7a:115c:a1e0::/48"
    ];
    bantime = "24h";
  };
}
