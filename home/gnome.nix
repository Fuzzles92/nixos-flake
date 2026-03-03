#==========================================#
#       GNOME Home Manager
#==========================================#

{ config, pkgs, ... }:

{
  #--------------------------
  # Packages (user-level)
  #--------------------------
  home.packages = with pkgs; [
    # Applications
    gnome-tweaks
    ignition
    pika-backup
    impression
    dconf-editor
    # Spotify # Not working currently using flatpak

    # GNOME Extensions
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.dash-to-dock
    gnomeExtensions.caffeine
    gnomeExtensions.gsconnect
    gnomeExtensions.edit-desktop-files
    gnomeExtensions.simple-tiling
  ];

  # --------------------------
  # Extension Settings
  # --------------------------
    # Dash to Dock
    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position = "BOTTOM";
      dash-max-icon-size = 32;
      custom-theme-shrink = true;
    };
  };

}

