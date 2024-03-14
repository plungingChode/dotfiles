{ pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../pkgs
    ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    grub = {
      enable = true;
      device = "nodev";
      useOSProber = true;
      efiSupport = true;
      default = "saved";
      configurationLimit = 5;
    };
  };
  boot.supportedFilesystems = [
    # Allow mounting Windows partitions
    "ntfs"
  ];

  networking.hostName = "pepti-pc";
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  time.timeZone = "Europe/Budapest";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "hu_HU.UTF-8";
    LC_IDENTIFICATION = "hu_HU.UTF-8";
    LC_MEASUREMENT = "hu_HU.UTF-8";
    LC_MONETARY = "hu_HU.UTF-8";
    LC_NAME = "hu_HU.UTF-8";
    LC_NUMERIC = "hu_HU.UTF-8";
    LC_PAPER = "hu_HU.UTF-8";
    LC_TELEPHONE = "hu_HU.UTF-8";
    LC_TIME = "hu_HU.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "gb";
    xkbVariant = "";
  };

  # Configure console keymap
  console = {
    earlySetup = true;
    packages = with pkgs; [ terminus_font ];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    keyMap = "uk";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.chode = {
    isNormalUser = true;
    description = "Szigeti Peter";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    open-sans
  ];

  environment.systemPackages = with pkgs; [
    _7zz
    curl
    gcc
    gnumake
    home-manager
    libnotify
    mako # notification system developed by swaywm maintainer
    myPackages.nordic-gtk-theme
    myPackages.astro-language-server
    unzip
    wdisplays # tool to configure displays
    wget
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    xdg-utils # for opening default programs when clicking links
  ];

  # Window manager
  programs.hyprland.enable = true;
  # Run window manager after tty login
  environment.loginShellInit = ''
    [ "$(tty)" = "/dev/tty1" ] && exec ${pkgs.hyprland}/bin/Hyprland
  '';
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # File manager
  programs.thunar.enable = true;
  programs.xfconf.enable = true; # Save Thunar configuration
  services.gvfs.enable = true; # Mount, trash, and other functionalities

  # Required for privilige elevation requests
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  # Sound settings
  security.rtkit.enable = true;
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  system.stateVersion = "23.11"; 
}
