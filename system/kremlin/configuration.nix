{ config, options, pkgs, ... }:
{
  boot.loader = {
    timeout = 30;
    systemd-boot = {
      enable = true;
      editor = false;
      consoleMode = "max";
    };
    efi.canTouchEfiVariables = true;
  };
  networking = {
    hostName = "kremlin";
    interfaces = {
      enp10s0.useDHCP = true;
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [ 443 80 ];
      allowedUDPPorts = [ 443 80 ];
    };
  };

  sound.enable = true;
  services = {
    openssh.enable = true;
    blueman.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  security = {
    protectKernelImage = true;
    rtkit.enable = true;
    sudo = {
      execWheelOnly = true;
    };
  };

  console.earlySetup = true;

  # OpenGL
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  # Programs
  programs = {
    dconf.enable = true;
    zsh.enable = true;
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "tty";
    };
  };

  environment = {
    binsh = "${pkgs.dash}/bin/dash";
    pathsToLink = [ "/share/zsh" ];
  };

  # Fonts
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      jetbrains-mono
      ubuntu_font_family
      spleen
      dejavu_fonts
      noto-fonts
      noto-fonts-extra
      noto-fonts-cjk
      noto-fonts-emoji
      tamsyn
      terminus_font
      liberation_ttf
      font-awesome
      fira
    ];
    enableDefaultFonts = true;
    fontconfig.defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      monospace = [
        "Terminus"
        "Fira Mono"
      ];
      serif = [ "DejaVu Serif" ];
      sansSerif = [ "Fira Sans" ];
    };
  };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    gtkUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  users.users = {
    lychee = {
      shell = pkgs.zsh;
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    };
  };

  system.stateVersion = "22.05";
}

