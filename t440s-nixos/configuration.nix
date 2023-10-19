# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      <nixos-hardware/lenovo/thinkpad/t440s>
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.timeout = 15;
  boot.loader.grub = {
    enable = true;
    useOSProber = true;
    device = "nodev";
    efiSupport = true;
  };
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  
  systemd.services.fix-mouse = {
    description = "Fix mouse after suspend";
    wantedBy = [ "suspend.target" ];
    after = [ "suspend.target" ];
    serviceConfig = {
      User = "matt";
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash /home/matt/fixMouse.sh";
    };
  };


  networking.hostName = "t440-nixos"; # Define your hostname.
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

    fonts.packages = with pkgs; [
      open-sans
    ];

  # Enable hyprland
  programs.hyprland = {    
    enable = true;    
    xwayland.enable = true;    
  }; 
  environment.sessionVariables = {
    # for invisible cursor fix
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint for electorn apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

  # Enable wayland
  # programs.sway.enable = true;

  # Enable the X11 windowing system.
  # Enable the GNOME Desktop Environment.
  services.xserver = {
    enable = true;
    displayManager = {
      # For awesome
      # sddm.enable = true;
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.matt = {
    isNormalUser = true;
    description = "matt";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      # monero-gui
      # xmrig
      irssi
    ];
  };

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Enable automatic login for the user.
  # services.xserver.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.autoLogin.user = "matt";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  # systemd.services."getty@tty1".enable = false;
  # systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # HYPRLAND REQUIREMENTS
    kitty
    dunst
    waybar
    libnotify
    swww # wallpaper daemon
    rofi-wayland #app launcher
    # browsers
    firefox
    microsoft-edge
    microsoft-edge-dev
    # dev
    vscode
    git
    # utils
    nfs-utils
    neofetch
    zsh
    btop
    remmina
    p7zip
    hollywood
    tilix
    wget
    curl
    unzip
    font-awesome
    # pandoc
    fprintd
    virt-manager
    # gaming
    steam
    # work
    bitwarden
    # azure-cli
    azuredatastudio
    drawio
    # media
    vlc
    # mplayer
    # chat
    # teams
    signal-desktop
    discord
    # zoom-us
    # element-desktop
    # dbeaver
    # Gnome
    gnomeExtensions.compiz-windows-effect
    gnome3.gnome-tweaks
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
  services.fprintd = {
    enable = true;
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nix = {
    settings.experimental-features = [ "nix-command" "flakes"];
    # Garbage collection
    settings.auto-optimise-store = true;
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
