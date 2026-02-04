#==========================================#
#             NixOS Configuation
#==========================================#

{ config, pkgs, ... }:

{

  #--------------------------
  #  Imports
  #--------------------------
  imports =
    [ ./hardware-configuration.nix
      ./modules
      ./desktop
    ];


  #--------------------------
  #  Fakes
  #--------------------------
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];


  #--------------------------
  #  Bootloader
  #--------------------------
  #boot.loader.grub.enable = true;
  #boot.loader.grub.device = "/dev/sda";
  #boot.loader.grub.useOSProber = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];


  #--------------------------
  #  Plymonth
  #--------------------------
  boot.plymouth.enable = true;

  #==========================================#
  #           System Information             #
  #==========================================#
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  #==========================================#
  #           Sound (Pipewire)               #
  #==========================================#
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };


  #==========================================#
  #           Touchpad Support               #
  #==========================================#
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;


  #==========================================#
  #               User Information           #
  #==========================================#
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fuzzles = {
    isNormalUser = true;
    description = "Fuzzles";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  #==========================================#
  #           Enable Applications            #
  #==========================================#
  programs.firefox.enable = true;

  #==========================================#
  #           Garbage Collection             #
  #==========================================#
  nix.gc = {
  	automatic = true;
  	dates = "weekly";
  	options = "--delete-older-than 10d";
  };

  #==========================================#
  #           Enable Unfree Packages         #
  #==========================================#
  nixpkgs.config.allowUnfree = true;


  #==========================================#
  #           System Packages                #
  #==========================================#
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
          git                   # Distributed Version Control System
          p7zip			        # Port of 7Zip
          wget			        # World Wide Web Get
          neofetch		        # CLI Information Tool
          ntfs3g		        # Open Source Driver for NTFS
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
