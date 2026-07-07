#==========================================#
#       KDE Home Manager
#==========================================#

{ config, pkgs, ... }:

{ 

  #--------------------------
  # Packages (user-level)
  #--------------------------
  home.packages = with pkgs; [
    # Applications
    kdePackages.partitionmanager		# KDE Partition Manager
	kdePackages.isoimagewriter			# KDE ISO Image Writer
  ];

}