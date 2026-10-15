#==========================================#
#       KDE Desktop
#==========================================#

{ config, pkgs, ... }:

{

  #--------------------------
  # KDE Desktop
  #--------------------------

  services.xserver.excludePackages = with pkgs; [
  	pkgs.xterm		# xTerm
  ];

  services.displayManager = {
              sddm.enable = true;
};

  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  #--------------------------
  # KDE Excludes
  #--------------------------

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
	# Excludes
  	  elisa  			    # Music player
	  discover		        # Software Centre
	  khelpcenter           # KDE Help Centre
	];

  #--------------------------
  # System Packages
  #--------------------------
  environment.systemPackages = with pkgs; [
    # Mostly Managed By Home Manager (User)
    kdePackages.partitionmanager		# KDE Partition Manager
    kdePackages.kcalc                   # KDE Calculator
	];
}
