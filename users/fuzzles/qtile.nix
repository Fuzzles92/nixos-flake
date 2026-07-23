#==========================================
#       Qtile Home Manager
#==========================================

{ config, pkgs, ... }:

{
  #--------------------------
  # Qtile Packages
  #--------------------------
  home.packages = with pkgs; [
    # Manage With Home Manager
    # Move from system to home manager
  ];

  #--------------------------
  # Qtile Configuration
  #--------------------------
  xdg.configFile."qtile" = {
    source = ./qtile;
    recursive = true;
    force = true;
  };
}
