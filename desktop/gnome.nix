#==========================================#
#         Gnome Desktop
#==========================================#

{ config, pkgs, ... }:

{
  #--------------------------
  #  Display Manager (GDM)
  #--------------------------
  services.displayManager.gdm.enable = true;

  #--------------------------
  #  Auto Login
  #--------------------------
  services.displayManager.autoLogin = {
    enable = true;
    user = "fuzzles";
  };

  #--------------------------
  #  GNOME Desktop
  #--------------------------
  services.desktopManager.gnome.enable = true;

  #--------------------------
  #  Excluded X11 Packages
  #--------------------------
  services.xserver.excludePackages = with pkgs; [
    pkgs.xterm
  ];

  #--------------------------
  #  GNOME Excludes
  #--------------------------
  environment.gnome.excludePackages = with pkgs.gnome; [
    pkgs.gnome-calendar
    pkgs.gnome-characters
    pkgs.gnome-clocks
    pkgs.gnome-contacts
    pkgs.gnome-font-viewer
    pkgs.gnome-logs
    pkgs.gnome-maps
    pkgs.gnome-music
    pkgs.gnome-photos
    pkgs.gnome-weather
    pkgs.gnome-connections
    pkgs.gnome-tour
    pkgs.snapshot
    pkgs.decibels
    pkgs.totem
    pkgs.geary
    pkgs.seahorse
    pkgs.epiphany
    pkgs.yelp
    pkgs.gnome-software
  ];

  #--------------------------
  #  System Packages
  #--------------------------
  environment.systemPackages = with pkgs; [
  # Managed By Home Manager
  ];
}

