#==========================================#
#        My Nix Qtile Configuation         #
#==========================================#

{ config, pkgs, ... }:

{

#==========================================#
#           Qtile Window Manager           #
#==========================================#

services.xserver.enable = true;
services.xserver.displayManager.lightdm = {
		enable = true;
		autoLogin = {
			enable = true;
			user = "fuzzles";
			};
		};
services.xserver.windowManager.qtile = {
  		enable = true;
  		configFile = "/etc/nixos/desktops/qtile/config.py";
  		extraPackages = python3Packages: with python3Packages; [
    		qtile-extras
    		];
};
  
#==========================================#
#           System Packages                #
#==========================================#
environment.systemPackages = with pkgs; [
	rofi							# Application Launcher
	kdePackages.polkit-kde-agent-1	# KDE Polkit Agent
	kdePackages.dolphin				# File Manager
	kdePackages.kate				# KDE Text Editor
	alacritty						# Terminal
	networkmanagerapplet			# Network Manager Applet
	pavucontrol						# GUI PulseAudio
	alsa-utils						#
	pamixer							#
	blueman 						# Bluetooth (not fully working)
	flameshot 						# Screenshot Application
	copyq 							# Clipboard
	];

#==========================================#
#                Hardware                  #
#==========================================#
hardware.bluetooth.enable = true;

#==========================================#
#                 Fonts                    #
#==========================================#
fonts.packages = with pkgs; [
font-awesome
];

}
