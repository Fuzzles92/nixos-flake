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
    cosmic-store        # COSMIC Store
    #--------------------------
    #  Included COSMIC Packages
    #--------------------------
    #cosmic-files      # COSMIC File Manager
    #cosmic-edit       # COSMIC Text Editor
    #cosmic-player     # COSMIC Media Player
    #cosmic-term       # COSMIC Terminal
    
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
