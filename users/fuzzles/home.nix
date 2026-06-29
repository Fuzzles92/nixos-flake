#================================#
#         Home Manager
#================================#

{ config, pkgs, ... }:

{

  #--------------------------
  #  Imports
  #--------------------------
  imports = [
    ./gnome.nix       # GNOME Home Manager
  ];

  #--------------------------
  #  User Settings
  #--------------------------
  home.username = "fuzzles";
  home.homeDirectory = "/home/fuzzles";
  home.stateVersion = "26.05";
   
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  programs.bash = {
  enable = true;

  initExtra = ''
    export PATH="$HOME/.local/bin:$PATH"
  '';
};
  
  #--------------------------
  #  User Packages
  #--------------------------
  home.packages = with pkgs; [
     gimp               # GNU Image Manipulation Program
     libreoffice        # Office Suite
     thunderbird        # Email Client
     vlc                # Media Player
     discord            # Discord Client
     spotify            # Music Streaming
     just               # Just Command Runner
     fzf                # General-purpose command-line fuzzy finder
     xdg-utils          # CLI Tool Integrate with Desktop Env
  ];
  
  #--------------------------
  #  Generic Terminal Launcher
  #--------------------------
  home.file.".local/bin/run-terminal" = {
    executable = true;

    text = ''
      #!/usr/bin/env bash
      
      if command -v kgx >/dev/null 2>&1; then
        exec kgx -- "$@"
      elif command -v xdg-terminal-exec >/dev/null 2>&1; then
        exec xdg-terminal-exec "$@"
      elif command -v kitty >/dev/null 2>&1; then
        exec kitty -e "$@"
      elif command -v konsole >/dev/null 2>&1; then
        exec konsole -e "$@"
      elif command -v gnome-terminal >/dev/null 2>&1; then
        exec gnome-terminal -- "$@"
      else
        echo "No terminal emulator found"
        exit 1
      fi
    '';
  };
  
  #--------------------------
  #  NixOS Manager Just Wrapper
  #--------------------------
  home.file.".local/bin/nixos-manager" = {
    executable = true;

    text = ''
       #!/usr/bin/env bash

       if [ $# -eq 0 ]; then
          exec ${pkgs.just}/bin/just \
           --justfile /etc/nixos/Justfile \
           --choose \
           --color always
       else
           exec ${pkgs.just}/bin/just \
            --justfile /etc/nixos/Justfile \
            --color always \
            "$@"
       fi
     '';
  };   
  
  #--------------------------
  #  NixOS Manager
  #--------------------------
  
  # Icon
  home.file.".local/share/icons/hicolor/scalable/apps/nixos-snowflake.svg".source =
    ./assets/icons/nixos-snowflake.svg;
    
  home.file.".local/share/applications/nixos-manager.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=NixOS Manager
    GenericName=NixOS Manager
    Comment=Manage NixOS with Just
    Exec=${config.home.homeDirectory}/.local/bin/run-terminal ${config.home.homeDirectory}/.local/bin/nixos-manager
    Icon=nixos-snowflake
    Terminal=false
    StartupNotify=false
    Categories=System;Utility;
    Keywords=nixos;manager;just;
    '';

}
