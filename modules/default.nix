{inputs, ...}: {
  imports = [
    ./agenix.nix
    ./caddy-module-patch.nix
    ./fail2ban.nix
    ./fonts.nix
    ./home.nix
    ./keys.nix
    ./kmscon.nix
    ./matrix.nix
    ./meta.nix
    ./nix.nix
    ./openssh.nix
    ./pipewire.nix
    ./vaultwarden.nix
    ./website.nix
    "${inputs.self}/users"
  ];
  # Global options
  time.timeZone = "US/Central";
  security.polkit.enable = true;
}
