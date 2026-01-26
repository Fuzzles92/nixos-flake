#==========================================#
#         Home Manager
#==========================================#

{ config, pkgs, ... }:

{
  imports = [
    ./nixos-helper.nix
    ./mangohud.nix
    #./gnome.nix
    #./xfce.nix
    #./qtile.nix
  ];

  home.username = "fuzzles";
  home.homeDirectory = "/home/fuzzles";

  home.stateVersion = "25.11";
}
