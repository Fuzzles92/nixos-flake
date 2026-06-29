#==========================#
#         COSMIC
#==========================#

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
  #  System Packages Exclude
  #--------------------------
  environment.cosmic.excludePackages = with pkgs; [
    cosmic-store        # Cosmic Store
    #--------------------------
    #  Included COSMIC Packages
    #--------------------------
    #cosmic-files      # file manager
    #cosmic-edit       # text editor
    #cosmic-player     # media player
    #cosmic-term       # terminal
    
  ];
  
  #--------------------------
  #  System Packages
  #--------------------------
  environment.systemPackages = with pkgs; [
    # Comsic System Packages
    pika-backup        # Backup GUI Tool
    impression         # ISO Image Writer
    ];
}
