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
          # move to home manager at somepoint
	];
}
