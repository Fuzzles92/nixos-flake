#==========================================#
#       NixOS Helper
#==========================================#

{ config, pkgs, ... }:

{
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

  # optional: copy icon from flake
  home.file.".local/share/icons/hicolor/scalable/apps/nixos-helper.svg".source =
    ../assets/icons/nixos-helper.svg;
}

