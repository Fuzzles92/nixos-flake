#================================#
#        My NixOS Config
#================================#

# multi user
# strartup apps the nix way
# niri??
# qtile??

{ config, pkgs, ... }:

{

  #================================#
  #           Imports
  #================================#
  imports =
    [ 
     # Managed by Flakes (flake.nix)
    ];
  
   
  #================================#
  #         Enable Flakes
  #================================#
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  #================================#
  #       Bootloader GRUB
  #================================#
  #boot.loader.grub.enable = true;
  #boot.loader.grub.device = "/dev/vda";
  #boot.loader.grub.useOSProber = true;
  #boot.supportedFilesystems = [ "ntfs" ];

  #================================#
  #       Bootloader Systemd
  #================================#
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  
  #================================#
  #         Kernel
  #================================#
  #boot.kernelPackages = pkgs.linuxPackages;         # default for your release
  #boot.kernelPackages = pkgs.linuxPackages_latest;  # newest branch packaged in your Nixpkgs
  
  #================================#
  #     Plymonth (Splash Screen)
  #================================#
  #boot.plymouth.enable = true;

  #================================#
  #     System Information
  #================================#
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

  #================================#
  #        Services
  #================================#
  # Enable sound with pipewire.
  services = {
    pipewire = {
       enable = true;
       audio.enable = true;
       pulse.enable = true;
       alsa.enable = true;
       alsa.support32Bit = true;
       jack.enable = true;
    };
  };  
 
  security = {
      rtkit = {
       enable = true;
       };
  };
    
  #================================#
  #        Touchpad Support
  #================================#
  # Enabled default in most desktop manager
  services.libinput.enable = true;

  #================================#
  #       User Information
  #================================#
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fuzzles = {
    isNormalUser = true;
    description = "Fuzzles";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
        # Managed By Home Manager (home.nix)
        ];
  };

  #================================#
  #       Enable Applications
  #================================#
  programs.firefox.enable = true;

  #================================#
  #        Garbage Collection
  #================================#
  nix.gc = {
  	automatic = true;
  	dates = "daily";
  	options = "--delete-older-than 2d";
  };
  
  #================================#
  #           Optimising
  #================================#
  nix.optimise.automatic = true;
  
  #================================#
  #     Enable Unfree Packages
  #================================#
   nixpkgs.config.allowUnfree = true;
  
  #================================#
  #        System Packages
  #================================#
  environment.systemPackages = with pkgs; [
          git                   # Distributed Version Control System
          p7zip			# Port of 7Zip
          wget			# World Wide Web Get
          fastfetch		# CLI Information Tool
          ntfs3g		# Open Source Driver for NTFS
          sbctl                 # Secure Boot Key Manager
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
