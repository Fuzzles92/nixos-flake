#==========================================#
#         Home Manager
#==========================================#

{ config, pkgs, ... }:

{

  #--------------------------
  #  Imports
  #--------------------------
  imports = [
    ./home/common.nix
    ./home/mangohud.nix
    #./home/gnome.nix
    #./home/qtile.nix
  ];

  #--------------------------
  #  User Settings
  #--------------------------
  home.username = "fuzzles";
  home.homeDirectory = "/home/fuzzles";
  home.stateVersion = "25.11";

}
