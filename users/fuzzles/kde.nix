#==========================================#
#       KDE Home Manager
#==========================================#

{ config, pkgs, ... }:

{ 

  #--------------------------
  # Set Wallpaper & Lock Screen
  #--------------------------
  # Copy wallpaper into ~/Pictures
  home.file."Pictures/Wallpapers/bazzite.png".source =
    ./assets/wallpapers/bazzite.png;

  #--------------------------
  # Packages (user-level)
  #--------------------------
  home.packages = with pkgs; [
    # Applications
	kdePackages.isoimagewriter			# KDE ISO Image Writer
  ];

}
