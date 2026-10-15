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
    #./cosmic.nix      # COSMIC Home Manager
    #./kde.nix          # KDE Home Manager
    #./qtile.nix        # Qtile Home Manager
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
  ];
  
  #--------------------------
  #  NixOS Manager Just Wrapper
  #--------------------------
  home.file.".local/bin/nixjust" = {
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

}
