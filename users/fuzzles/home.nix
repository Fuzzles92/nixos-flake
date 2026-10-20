
#--------------------------------#
#      Fuzzles Home Manager
#--------------------------------#

{ config, pkgs, ... }:

{
  #--------------------------------#
  #            Imports
  #--------------------------------#

  imports = [
    ../../home/desktops/gnome.nix    # GNOME Home Manager
    # ../../home/desktops/cosmic.nix # COSMIC Home Manager
    # ../../home/desktops/kde.nix    # KDE Home Manager
    # ../../home/desktops/qtile.nix  # Qtile Home Manager
  ];

  #--------------------------------#
  #         User Settings
  #--------------------------------#

  home.username = "fuzzles";
  home.homeDirectory = "/home/fuzzles";
  home.stateVersion = "25.05";

  #--------------------------------#
  #          Home Manager
  #--------------------------------#

  programs.home-manager.enable = true;

  #--------------------------------#
  #          Bash Settings
  #--------------------------------#

  programs.bash = {
    enable = true;

    initExtra = ''
      export PATH="$HOME/.local/bin:$PATH"
    '';
  };

  #--------------------------------#
  #          User Packages
  #--------------------------------#

  home.packages = with pkgs; [
    gimp           # Image Editor
    libreoffice    # Office Suite
    thunderbird    # Email Client
    vlc            # Media Player
    discord        # Discord Client
    spotify        # Music Streaming
    just           # Command Runner
    fzf            # Interactive Fuzzy Finder
  ];

  #--------------------------------#
  #         Nix Just Wrapper
  #--------------------------------#

  home.file.".local/bin/nixjust" = {
    executable = true;

    text = ''
      #!${pkgs.bash}/bin/bash

      JUSTFILE="/etc/nixos/Justfile"

      if [ ! -f "$JUSTFILE" ]; then
        echo "Error: Justfile not found at $JUSTFILE"
        exit 1
      fi

      if [ "$#" -eq 0 ]; then
        exec ${pkgs.just}/bin/just \
          --justfile "$JUSTFILE" \
          --choose \
          --chooser "${pkgs.fzf}/bin/fzf" \
          --color always
      else
        exec ${pkgs.just}/bin/just \
          --justfile "$JUSTFILE" \
          --color always \
          "$@"
      fi
    '';
  };
}
