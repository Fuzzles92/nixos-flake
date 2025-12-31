#==========================================#
#         My Nix KDE Configuation          #
#==========================================#

{ config, pkgs, ... }:

{

#==========================================#
#               KDE Desktop                #
#==========================================#

services.xserver.excludePackages = with pkgs; [
  	pkgs.xterm		# xTerm
  ];

services.displayManager.sddm = {
				enable = true;
				autoLogin.enable = true;
				autoLogin.user = "fuzzles";
};

services.displayManager.sddm.wayland.enable = true;
services.desktopManager.plasma6.enable = true;

#==========================================#
#             KDE Excludes                 #
#==========================================#

environment.plasma6.excludePackages = with pkgs.kdePackages; [
	# Uncommented Excludes
  	elisa  			    # Music player
	discover		    # Software Centre
  	#konsole 		    # Terminal emulator
	#kate				# Text Editor
	#gwenview			# Image Viewer
	#okular				# View & Edit Documents
  	#ark				# Archiving Tool
	#dolphin			# File Manager
	];

#==========================================#
#           System Packages                #
#==========================================#
environment.systemPackages = with pkgs; [
	# Other Applications
	kdePackages.partitionmanager		# KDE Partition Manager
	kdePackages.isoimagewriter			# KDE ISO Image Writer
	kdePackages.skanlite                # KDE Image Scanner
	pika-backup		    				# Backup Application
	];
}
