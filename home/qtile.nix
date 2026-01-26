#==========================================
#       Qtile Home Manager
#==========================================

{ config, pkgs, ... }:

{
  #--------------------------
  # Qtile Packages
  #--------------------------
  home.packages = with pkgs; [
    python3
    python3Packages.qtile
    xorg.xprop   # optional, useful for Qtile utils
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
