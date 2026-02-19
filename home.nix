#==========================================#
#         Home Manager
#==========================================#

{ config, pkgs, ... }:

{

  #--------------------------
  #  Imports
  #--------------------------
  imports = [
    #./home/nixos-helper.nix
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

  #--------------------------
  #  User Packages
  #--------------------------
  home.packages = with pkgs; [
      thunderbird        # Email Client
      libreoffice        # Office Suite
      discord            # Discord Client
      #spotify            # Spotify Client
      vlc                # Media & Video Player
  ];

  #--------------------------
  #  NixOS Helper Script
  #--------------------------
  home.file.".local/bin/nixos-helper.sh" = {
    source = ./scripts/nixos-helper.sh;  # path to your script in the repo
    executable = true;                    # makes it executable
  };

  # Optional: ensure the icon for your helper is in place
  home.file.".local/share/icons/hicolor/scalable/apps/nixos-helper.svg".source =
    ./assets/icons/nixos-helper.svg;

  # Optional: update .desktop file to point to this script
  home.file.".local/share/applications/nixos-helper.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=NixOS Helper
    GenericName=NixOS Management Helper
    Comment=Manage NixOS from a GUI Launcher
    Exec=pkexec /etc/nixos/scripts/nixos-helper.sh
    Icon=nixos-helper
    Terminal=true
    Categories=Utility;System;
    Keywords=helper;tool;script;
  '';
}
