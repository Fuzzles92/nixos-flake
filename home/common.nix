#==========================================#
#       Common Home Manager
#==========================================#

{ config, pkgs, ... }:

{

  #--------------------------
  #  User Packages
  #--------------------------
  home.packages = with pkgs; [
      thunderbird        # Email Client
      libreoffice        # Office Suite
      discord            # Discord Client
      #spotify            # Spotify Client        # not working look into
      vlc                # Media & Video Player
  ];

  #--------------------------
  #  NixOS Manager
  #--------------------------
  home.file.".local/bin/nixos-manager.sh" = {
    source = ../scripts/nixos-manager.sh;
    executable = true;
  };

  # Optional: ensure the icon for your helper is in place
  home.file.".local/share/icons/hicolor/scalable/apps/nixos-snowflake.svg".source =
    ../assets/icons/nixos-snowflake.svg;

  # Optional: update .desktop file to point to this script
  home.file.".local/share/applications/nixos-manager.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=NixOS Manager
    GenericName=NixOS Manager
    Comment=Manage NixOS from a GUI Launcher
    Exec=pkexec ${config.home.homeDirectory}/.local/bin/nixos-manager.sh
    Icon=nixos-snowflake
    Terminal=true
    Categories=Utility;System;
    Keywords=manager;tool;script;
  '';

}

