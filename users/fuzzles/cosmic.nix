#==========================================#
#       COSMIC Home Manager
#==========================================#

{ config, pkgs, ... }:

{ 

  #--------------------------
  # Packages (user-level)
  #--------------------------
  home.packages = with pkgs; [
    # Applications
    cosmic-ext-tweaks      # COSMIC Tweaks
    ignition               # GNOME Startup
    pika-backup            # Backup GUI Tool
    impression             # ISO Image Writer
  ];


}

