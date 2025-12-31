#==========================================#
#         My Nix XFCE Configuation        #
#==========================================#

{ config, pkgs, ... }:

{

#==========================================#
#               XFCE DE                    #
#==========================================#

#services.xserver.enable = true; # optional
#services.displayManager.sddm.enable = true;
#services.displayManager.sddm.wayland.enable = true;
#services.desktopManager.plasma6.enable = true;

services.xserver.enable = true;
services.desktopManager = {
      		xterm.enable = false;
      		xfce.enable = true;
   		};

services.displayManager.defaultSession = "xfce";

#==========================================#
#             XFCE Excludes                #
#==========================================#

#environment.plasma6.excludePackages = with pkgs.kdePackages; [
  	#elisa  # Music player
  	#konsole # Terminal emulator
  	#plasma-browser-integration # Browser integration tools
  	
  	# You can also exclude other optional packages from the kdePackages set
  	# example: kdePackages.kmail # Email client
	#];

}
