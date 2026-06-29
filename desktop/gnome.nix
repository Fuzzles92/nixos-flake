#==========================#
#    GNOME Desktop
#==========================#

#gsettings reset-recursively org.gnome.desktop.interface
#gsettings reset-recursively org.gnome.desktop.wm.preferences

{ config, pkgs, ... }:

{
  #--------------------------
  #  Display Manager (GDM)
  #--------------------------
  # GDM is the GNOME Display Manager (login screen)
  services.displayManager.gdm.enable = true;

  #--------------------------
  #  GNOME Desktop
  #--------------------------
  # Enables the full GNOME desktop environment
  services.desktopManager.gnome.enable = true;

  #--------------------------
  #  Excluded X11 Packages
  #--------------------------
  # Removes legacy or unnecessary X11 utilities
  services.xserver.excludePackages = with pkgs; [
    pkgs.xterm  # Basic X terminal emulator
  ];

  #--------------------------
  #  GNOME Excluded Packages
  #--------------------------
  # Removes default GNOME apps to slim down the system
  environment.gnome.excludePackages = (with pkgs; [
    gnome-calendar       # GNOME Calendar
    gnome-characters         # GNOME Emoji and character picker
    gnome-clocks             # GNOME Clock, alarms, world time
    gnome-contacts           # GNOME Address Contacts
    gnome-font-viewer        # GNOME Font Preview Tool
    gnome-logs               # GNOME System Log Viewer
    gnome-maps               # GNOME Map Viewer
    gnome-music              # GNOME Music Player
    gnome-photos             # GNOME Photo Manager
    gnome-weather            # GNOME Weather
    gnome-connections        # GNOME Remote Desktop Client
    gnome-tour               # GNOME Tour
    gnome-software           # GNOME Software Center
    decibels                 # GNOME Audio Player
    showtime                 # GNOME Video player
    geary                    # GNOME Email Client
    epiphany                 # GNOME web browser
    yelp                     # GNOME Help viewer
    #gnome-console            # GNOME Terminal
    #gnome-calculator         # GNOME Calculator
    #gnome-text-editor        # GNOME Text Editor
    #gnome-disk-utility       # GNOME Disks
    #gnome-system-monitor     # GNOME System Monitor
    #snapshot                 # GNOME Camera
    #seahorse                 # GNOME Passwords and Keys Manager
    #loupe                    # GNOME Image Viewer
    #papers                   # GNOME Document Viewer
    #nautilus                # GNOME File Manager
    #baobab                  # GNOME Disk Usage Analyzer
  ]);

  #--------------------------
  #  System Packages
  #--------------------------
  environment.systemPackages = with pkgs; [
  # Managed By Home Manager 
  ];
}
