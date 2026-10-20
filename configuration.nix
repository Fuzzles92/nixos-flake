#--------------------------------#
#        My NixOS Config
#--------------------------------#

{ config, pkgs, ... }:

{

  #--------------------------------#
  #            Imports
  #--------------------------------#
  imports =
    [ 
     # Managed by Flakes (flake.nix)
    ];
   
  #--------------------------------#
  #             Kernel
  #--------------------------------#
  #boot.kernelPackages = pkgs.linuxPackages;         # default for your release
  #boot.kernelPackages = pkgs.linuxPackages_latest;  # newest branch packaged in your Nixpkgs
  
  #--------------------------------#
  #    Plymonth (Splash Screen)
  #--------------------------------#
  boot.plymouth.enable = true;

  #--------------------------------#
  #            Services
  #--------------------------------#
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
    
  #--------------------------------#
  #        Touchpad Support
  #--------------------------------#
  # Enabled default in most desktop manager
  services.libinput.enable = true;

  #--------------------------------#
  #      Enable Applications
  #--------------------------------#
  programs.firefox.enable = true;

  #--------------------------------#
  #        System Packages
  #--------------------------------#
  environment.systemPackages = with pkgs; [
          git                   # Distributed Version Control System
          p7zip			# Port of 7Zip
          wget			# World Wide Web Get
          fastfetch		# CLI Information Tool
          ntfs3g		# Open Source Driver for NTFS
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
