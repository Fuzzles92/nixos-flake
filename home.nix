#==========================================#
#         Home Manager
#==========================================#

{ config, pkgs, ... }:

{

  #--------------------------
  #  Imports
  #--------------------------
  imports = [
    ./home/nixos-helper.nix
    ./home/mangohud.nix
    #./home/gnome.nix
    #./home/xfce.nix
    #./home/qtile.nix
  ];


  #--------------------------
  #  User Settings
  #--------------------------
  home.username = "fuzzles";
  home.homeDirectory = "/home/fuzzles";
  home.stateVersion = "25.11";

  # User Packages
  home.packages = with pkgs; [
      thunderbird        # Email Client
      libreoffice        # Office Suite
      discord            # Discord Client
      spotify            # Spotify Client
      vlc                # Media & Video Player

  ];

}
