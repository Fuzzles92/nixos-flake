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
    # Managed By Home Manager
    #pika-backup        # Backup GUI Tool
    #impression         # ISO Image Writer
    ];
}
