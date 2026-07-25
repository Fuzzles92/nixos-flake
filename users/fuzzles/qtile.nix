#==========================================
#       Qtile Home Manager
#==========================================

# screenshotting
# clipboard
# polkit prompt
# fix disc format on qtile bar


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
