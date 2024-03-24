# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # boot.kernelPackages = pkgs.linuxPackages_5_15;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "asus-zenbook"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

  
  # Enable the GNOME Desktop Environment.
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome.enable = true;
    # Configure keymap in X11
    layout = "us";
    xkbVariant = "";
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # For Plasma sddm Display Manager
  # services.xserver.displayManager.sddm = {
  #   enable = true;
  #   wayland.enable = true;
  # };

  # Plasma 6
  # services.desktopManager.plasma6.enable = true;
  # Workaround for error. Needs lib at top of file
  # programs.ssh.askPassword = lib.mkForce "${pkgs.ksshaskpass}/bin/ksshaskpass";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
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

  # Exclude Gnome features / apps I don't use
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome.gnome-music
    epiphany # web browswer
    gnome.totem # video player
    gnome-tour
    # gnome.gnome-terminal
    gnome-console
    gnome.gnome-weather
    gnome.gnome-contacts  
    gnome.gnome-maps
    gnome.geary # mail client
  ]);

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.matt = {
    isNormalUser = true;
    description = "matt";
    extraGroups = [ "networkmanager" "wheel" "adbusers"];
    packages = with pkgs; [
      # monero-gui
      # xmrig
      open-sans
      irssi
      ledger-live-desktop
      dbeaver
      postgresql
      gnuradio
    ];
    # openssh.authorizedKeys.keys = [ ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  programs.virt-manager.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      # Multi-monitor sync attempt:
      modesetting.enable = true;
      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of 
      # supported GPUs is at: 
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;
      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;
      # Optionally, you may need to select the appropriate driver version for your specific GPU.

      prime = {
        sync.enable = true;
        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:0:2:0";
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  # BROWSERS
    firefox
    ungoogled-chromium
    microsoft-edge
    # DEV
    vscode
    git
    # UTILS
    nfs-utils
    cifs-utils
    ntfs3g
    nmap
    neofetch
    tmux
    btop
    nethogs
    pavucontrol # audio control
    busybox
    nvtop
    bitwarden
    gparted
    anbox # TODO: Test to see if this can work for onenote
    remmina # https://gitlab.com/Remmina/Remmina/-/issues/1584
    p7zip
    hollywood
    tilix
    wget
    curl
    unzip
    font-awesome
    variety # wallpaper changer
    # pandoc
    # This was the old way?
    # android-tools
    # fprintd TODO: Move this to T440 specific
    # gaming
    steam
    # WORK
    # teams
    # p3x-onenote
    azure-cli
    azuredatastudio
    drawio
    onedrive # TODO: check into safety
    # MEDIA
    vlc
    # mplayer
    # chat
    signal-desktop
    discord
    zoom-us
    # element-desktop
    # dbeaver
    # GNOME
    # gnome.gnome-tweaks
    gnomeExtensions.compiz-windows-effect
    # gnomeExtensions.vitals
    # gnomeExtensions.workspace-indicator
    # gnomeExtensions.appindicator # Tried for variety but didn't work
    gnomeExtensions.window-state-manager
    gnomeExtensions.extension-list
    gnomeExtensions.removable-drive-menu
    # gnomeExtensions.hide-top-bar
    gnomeExtensions.emoji-copy
    gnomeExtensions.gsconnect 
    # gjs
    # gnome3.gnome-tweaks
    # KDE plasma6
    # libsForQt5.plasma-browser-integration
  ];

  services.tlp = {
    enable = true;
    #settings = {
    #  CPU_SCALING_GOVERNOR_ON_AC = "performance";
    #  CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
#
    #  CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    #  CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
#
    #  CPU_MIN_PERF_ON_AC = 0;
    #  CPU_MAX_PERF_ON_AC = 100;
    #  CPU_MIN_PERF_ON_BAT = 0;
    #  CPU_MAX_PERF_ON_BAT = 20;
#
    #  #Optional helps save long term battery health
    #  START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
    #  STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
    #};
  };
  services.power-profiles-daemon.enable = false; # Disable power-profiles-daemon to avoid conflict

  # Required for gnomeExtensions.appindicator (and variety systray)
  # services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.tailscale.enable = true;

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

  fileSystems."/var/nas-01" = {
    device = "nas-01.szafir.home:/volume1";
    fsType = "nfs";
    options = [ "x-systemd.device-timeout=1ms" "nofail" "nfsvers=4.1"];
  };
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
