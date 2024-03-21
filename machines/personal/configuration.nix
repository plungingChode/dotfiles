# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

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

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

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

  # Set your time zone.
  time.timeZone = "Europe/Budapest";

  # Select internationalisation properties.
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

  # TODO use this when switching to sway
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = "${pkgs.fish}/bin/fish";
  #       user = "chode";
  #     };
  #   };
  # };

  # Configure console keymap
  console = {
    earlySetup = true;
    packages = with pkgs; [ terminus_font ];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u24n.psf.gz";
    keyMap = "uk";
  };

  fonts = {
    # TODO
    # enableDefaultPackages = false;
    packages = with pkgs; [
      open-sans
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "DejaVu Serif" "Book" ];
        sansSerif = [ "Open Sans" ];
        monospace = [ "FiraCode Nerd Font" ];
      };
    };
  };

  # Enable docker
  virtualisation.docker = {
    enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."chode" = {
    isNormalUser = true;
    description = "Szigeti Péter";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
  };

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ((vim_configurable.override { }).customize {
      name = "vim";
      vimrcConfig.customRC = ''
        syntax on
        set tabstop=2
        set shiftwidth=2
        set number
        set relativenumber
        set expandtab
        set nowrap
      '';
    })
    # wdisplays # tool to configure displays
    # wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    _7zz
    bc
    alacritty
    curl
    gcc
    git
    gnumake
    # TODO move this to home-manager
    myPackages.nordic-gtk-theme
    libnotify
    unzip
    wget
    xdg-utils # for opening default programs when clicking links
  ];
  
  # Use executable name to allow overrides
  environment.variables.EDITOR = "vim";
  environment.variables.VISUAL = "vim";
  environment.variables.SYSTEMD_EDITOR = "vim";


  # TODO required for i3 (but why)
  environment.pathsToLink = [
    "/libexec"
  ]; 
  environment.sessionVariables.CUSTOM_SCRIPTS_DIR = "$HOME/.config/home-manager/scripts";
  programs.dconf.enable = true;
  services.xserver = {
    enable = true;

    # Configure keymap in X11
    layout = "gb,hu";
    xkbVariant = ",qwerty";
    xkbOptions = "grp:win_space_toggle,caps:escape";

    desktopManager = {
      xterm.enable = false;
    };
    displayManager = {
      lightdm.enable = true;
      defaultSession = "none+i3";
    };
    # gnome.gnome-keyring.enable = true;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };
  };

  location = {
    provider = "manual";
    latitude = 47.497913;
    longitude = 19.040236;
  };

  services.redshift = {
    enable = true;
  };

  # Required for some GTK applications
  xdg.portal = {
    enable = true;
    wlr.enable = true;

    # TODO resolve warning: xdg-desktop-portal 1.17 reworked how portal
    # implementations are loaded
    config.common.default = "*";
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk 
    ];
  };

  # File manager
  programs.thunar.enable = true;
  programs.xfconf.enable = true; # Save Thunar configuration
  services.gvfs.enable = true; # Mount, trash, and other functionalities

  # Required for privilige elevation requests
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
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

  # Sound settings
  security.rtkit.enable = true;
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11";
}
