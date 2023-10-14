# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  # boot.loader.timeout = 15;
  #boot.loader.grub = {
  #  enable = true;
  #  useOSProber = true;
  #  device = "nodev";
  #  efiSupport = true;
  #};
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "asus-zenbook"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  fonts.packages = with pkgs; [
    open-sans
  ];

  # Enable hyprland
  programs.hyprland = {    
    enable = true;    
    xwayland.enable = true;    
    enableNvidiaPatches = true; 
  }; 
  environment.sessionVariables = {
    # for invisible cursor fix
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint for electorn apps to use wayland
    NIXOS_OZONE_WL = "1";
  };
  # xdg.portal.enable = true;
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];


  # Enable the X11 windowing system.
  # Enable the GNOME Desktop Environment.
  services.xserver = {
    enable = true;
    displayManager = {
      # for Gnome
      gdm.enable = true;
      gdm.wayland = true;
    };
    desktopManager = {
      gnome.enable = true;
    };
    # Configure keymap in X11
    layout = "us";
    xkbVariant = "";
  };

  # Exclude Gnome features / apps I don't use
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome.gnome-music
    epiphany # web browswer
    gnome.totem # video player
    gnome-tour
    gnome.gnome-terminal
    gnome-console
    gnome.gnome-weather
    gnome.gnome-contacts  
    gnome.gnome-maps
    gnome.geary # mail client
  ]) ++ (with pkgs.gnome; [
    gedit
    # gnome-tweaks # didn't seem to work
  ]);
  
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi.enable = true;
   # for a WiFi printer
  services.avahi.openFirewall = true;
  # for an USB printer
  # services.ipp-usb.enable = true;


  # Enable sound with pipewire.
  # If dual booting and sound isn't working disable fast-boot in Windows Power settings
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # This and adbusers in extraGroups allows for adb to work
  programs.adb.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.matt = {
    isNormalUser = true;
    description = "matt";
    extraGroups = [ "networkmanager" "wheel" "adbusers"];
    packages = with pkgs; [
      # monero-gui
      # xmrig
      irssi
      ledger-live-desktop
    ];
    openssh.authorizedKeys.keys = [ ];
  };

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

    # Enable automatic login for the user.
  # services.xserver.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.autoLogin.user = "matt";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  # systemd.services."getty@tty1".enable = false;
  # systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    opengl.enable = true;
    nvidia = {
      # Multi-monitor sync attempt:
      modesetting.enable = true;
      prime = {
        sync.enable = true;
        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:0:2:0";
      };
    };
  };
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    # HYPRLAND REQUIREMENTS
    pkgs.kitty
    pkgs.dunst
    pkgs.waybar
    pkgs.libnotify
    pkgs.swww # wallpaper daemon
    pkgs.rofi-wayland #app launcher
    # BROWSERS
    pkgs.firefox
    pkgs.ungoogled-chromium
    pkgs.microsoft-edge
    # DEV
    pkgs.vscode
    pkgs.git
    # UTILS
    pkgs.nfs-utils
    pkgs.cifs-utils
    pkgs.ntfs3g
    pkgs.neofetch
    pkgs.zsh
    pkgs.btop
    pkgs.nethogs
    pkgs.busybox
    pkgs.nvtop
    pkgs.bitwarden
    pkgs.gparted
    pkgs.anbox # TODO: Test to see if this can work for onenote
    pkgs.remmina # https://gitlab.com/Remmina/Remmina/-/issues/1584
    pkgs.p7zip
    pkgs.hollywood
    pkgs.tilix
    pkgs.wget
    pkgs.curl
    pkgs.unzip
    pkgs.font-awesome
    # pandoc
    # This was the old way?
    # android-tools
    # fprintd TODO: Move this to T440 specific
    pkgs.virt-manager
    # gaming
    pkgs.steam
    # WORK
    # teams
    # p3x-onenote
    pkgs.azure-cli
    pkgs.azuredatastudio
    pkgs.drawio
    pkgs.onedrive # TODO: check into safety
    # MEDIA
    pkgs.vlc
    # mplayer
    # chat
    pkgs.signal-desktop
    pkgs.discord
    pkgs.zoom-us
    # element-desktop
    # dbeaver
    # GNOME
    pkgs.gnomeExtensions.compiz-windows-effect
    pkgs.gnomeExtensions.vitals
    pkgs.gnomeExtensions.workspace-indicator
    pkgs.gnomeExtensions.window-state-manager
    pkgs.gnomeExtensions.extension-list
    pkgs.gnomeExtensions.removable-drive-menu
    pkgs.gnomeExtensions.hide-top-bar
    pkgs.gnomeExtensions.emoji-selector
    pkgs.gnomeExtensions.gsconnect # TODO: Not working
    # gjs
    # gnome3.gnome-tweaks
  ];
  
  services.tailscale.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  # TODO: T440 specific
  # services.fprintd = {
  #   enable = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall = { 
    enable = true;
    checkReversePath = "loose";
    allowedTCPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
    allowedUDPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
  }; 

  # NFS NAS Mounting (nas-01)
  fileSystems."/var/nas-01" = {
    device = "nas-01.szafir.home:/volume1/MATT";
    fsType = "nfs";
    options = [ "x-systemd.device-timeout=1ms" "nofail" "nfsvers=4.1"];
  };

  # Garbage collection
  nix = {
    settings.auto-optimise-store = true;
    settings.experimental-features = [ "nix-command" "flakes" ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
