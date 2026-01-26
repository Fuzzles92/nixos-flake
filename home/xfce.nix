#==========================================#
#       XFCE Home Manager
#==========================================#

{ config, pkgs, ... }:

{
  #--------------------------
  # Packages (user-level)
  #--------------------------
  home.packages = with pkgs; [

    # Applications
    pika-backup
    impression
  ];

}

