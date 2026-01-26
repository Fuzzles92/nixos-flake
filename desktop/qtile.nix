#==========================================#
#       Qtile Config
#==========================================#

{ config, pkgs, ... }:

{

  #--------------------------
  #  Display Manager (LightDM)
  #--------------------------
  services.xserver.displayManager.lightdm.enable = true;

  #--------------------------
  #  Auto Login
  #--------------------------
  services.displayManager.autoLogin = {
    enable = true;
    user = "fuzzles";
  };


  #--------------------------
  #  Qtile Window Manager
  #--------------------------

 services.xserver.enable = true;
  services.xserver.windowManager.qtile = {
  		enable = true;
  		extraPackages = python3Packages: with python3Packages; [
    		qtile-extras
    		];
  };

  #--------------------------
  #  DG Desktop Portals (Flatpak)
  #--------------------------
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
        xdg-desktop-portal-gtk   # GTK backend
        xdg-desktop-portal-xapp  # XFCE/MATE backend (optional)
        ];
  xdg.portal.config.common.default = "*"; # pick first available portal
  
  #--------------------------
  #  System Packages
  #--------------------------
  environment.systemPackages = with pkgs; [
          rofi						# Application Launcher
          kdePackages.dolphin       # File Manager GUI
          ranger            		# File Manager
          alacritty					# Terminal
          networkmanagerapplet		# Network Manager Applet
          pavucontrol				# GUI PulseAudio
          alsa-utils				# Utils for Advanced Linux Sound Architecture
          pamixer					# Pulseaudio Command Line Mixer
          blueman 					# Bluetooth
          flameshot 				# Screenshot Application
          copyq 					# Clipboard
	];

  #--------------------------
  #  Hardware
  #--------------------------
  hardware.bluetooth.enable = true;

  #--------------------------
  #  Fonts
  #--------------------------
  fonts.packages = with pkgs; [
  font-awesome
  ];

}
