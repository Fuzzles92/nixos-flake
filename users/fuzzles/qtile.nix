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
  #  Programs
  #--------------------------
  programs.rofi = {
          enable = true;
          package = pkgs.rofi; #pkgs.rofi-wayland
          theme = ./rofi/catppuccin/catppuccin-mocha.rasi;

          extraConfig = {
              show-icons = true;
              modi = "drun,run,window";
          };
  };

  #--------------------------
  # Qtile Configuration
  #--------------------------
#   xdg.configFile."qtile" = {
#     source = ./qtile;
#     recursive = true;
#     force = true;
#   };
}
