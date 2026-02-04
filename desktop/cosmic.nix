#==========================================#
#                    Cosmic
#==========================================#

{ config, pkgs, ... }:

{

  #--------------------------
  #  Display Manager (LightDM)
  #--------------------------
  services.displayManager.cosmic-greeter.enable = true;

  #--------------------------
  #  Auto Login
  #--------------------------
  services.displayManager.autoLogin = {
    enable = true;
    user = "fuzzles";
  };

  #--------------------------
  #  Cosmic Desktop
  #--------------------------
  services.desktopManager.cosmic.enable = true;

  #--------------------------
  #  DG Desktop Portals (Flatpak)
  #--------------------------
  #xdg.portal.enable = true;
  #xdg.portal.extraPortals = with pkgs; [
        #xdg-desktop-portal-gtk   # GTK backend
        #xdg-desktop-portal-xapp  # XFCE/MATE backend (optional)
        #];
  #xdg.portal.config.common.default = "*"; # pick first available portal
  
  
  #--------------------------
  #  System Packages Exclude
  #--------------------------
  environment.cosmic.excludePackages = with pkgs; [
            cosmic-store        # Cosmic Store
  ];
  
  #--------------------------
  #  System Packages
  #--------------------------
  environment.systemPackages = with pkgs; [
          # Applications
           pika-backup
           impression
           # Spotify # Not working currently using flatpak

	];
}
