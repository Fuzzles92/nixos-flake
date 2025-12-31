#==========================================#
#         My Nix GNOME Configuation        #
#==========================================#

#==========================================#
#           GNOME gSettings                #
#==========================================#

#gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
#gsettings set org.gnome.desktop.interface cursor-size 24
#gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
#gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
#gsettings set org.gnome.shell.extensions.user-theme name 'Adwaita'

#gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita' && \
#gsettings set org.gnome.desktop.interface cursor-size 24 && \
#gsettings set org.gnome.desktop.interface icon-theme 'Adwaita' && \
#gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita' && \
#gsettings set org.gnome.shell.extensions.user-theme name 'Adwaita' && \
#gsettings set org.gnome.desktop.interface font-name 'Cantarell 11' && \
#gsettings set org.gnome.desktop.interface document-font-name 'Serif 11' && \
#gsettings set org.gnome.desktop.interface monospace-font-name 'Monospace 11' && \
#gsettings set org.gnome.desktop.interface text-scaling-factor 1.0 && \
#gsettings set org.gnome.desktop.interface font-hinting 'slight' && \
#gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'

{ config, pkgs, ... }:

{

#==========================================#
#               GNOME Desktop              #
#==========================================#
services.xserver.displayManager.gdm = {
				enable = true;
				autoLogin.enable = true;
				autoLogin.user = "fuzzles";
};

services.xserver.desktopManager.gnome.enable = true;
services.xserver.excludePackages = with pkgs; [
  	pkgs.xterm		# xTerm
  ];

#==========================================#
#             GNOME Excludes               #
#==========================================#
environment.gnome.excludePackages = with pkgs.gnome; [
	# Uncommented Excludes
	pkgs.gnome-calendar		    # Gnome Calendar
	pkgs.gnome-characters		# Gnome Characters
	pkgs.gnome-clocks		    # Gnome Clocks
	pkgs.gnome-contacts		    # Gnome Contacts
	pkgs.gnome-font-viewer		# Gnome Font Viewer
	pkgs.gnome-logs			    # Gnome Logs
	pkgs.gnome-maps			    # Gnome Maps
	pkgs.gnome-music		    # Gnome Music
	pkgs.gnome-photos		    # Gnome Photos
	pkgs.gnome-weather		    # Gnome Weather
	pkgs.gnome-connections		# Gnome Connections
	pkgs.gnome-tour			    # Gnome Tour
	pkgs.snapshot			    # Gnome Camera
	pkgs.decibels			    # Gnome Music Player
	pkgs.totem			        # Gnome Video Player
	pkgs.geary			        # Gnome Email Client
	pkgs.seahorse			    # Gnome Password Manager
	pkgs.epiphany		       	# Gnome Web Browser
	pkgs.yelp			        # Gnome Help Viewer
	pkgs.gnome-software         # Gnome Software	
	#pkgs.showtime				# Gnome Video Player
	#pkgs.papers				# Gnome Document Viewer
	#pkgs.baobab			    # Gnome Disk Usage Analyzer
	#pkgs.gnome-system-monitor	# Gnome System Monitor
	#pkgs.gnome-disk-utility	# Gnome Disk Utility
	#pkgs.gnome-text-editor		# Gnome Text Editor
	#pkgs.simple-scan		    # Gnome Document Scanner
	#pkgs.file-roller		    # Gnome Archive Manager
	#pkgs.gnome-calculator		# Gnome Calculator
  ];
  
#==========================================#
#           System Packages                #
#==========================================#
environment.systemPackages = with pkgs; [
	# Gnome Extra Applications
	gnome-tweaks		# Additional Gnome Changes
	ignition		    # Start up Applications
	pika-backup		    # Backup Application
	impression		    # ISO Image Writer

	# Gnome Extensions
	gnomeExtensions.appindicator
	gnomeExtensions.blur-my-shell
	gnomeExtensions.dash-to-dock
	gnomeExtensions.caffeine
	gnomeExtensions.gsconnect
	#gnomeExtensions.logo-menu
	];
}