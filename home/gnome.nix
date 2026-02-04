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

  #--------------------------
  # GNOME dconf Settings
  #--------------------------
  dconf.settings = {

    # Enable GNOME extensions
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
            "appindicatorsupport@rgcjonas.gmail.com"
            "blur-my-shell@aunetx"
            "dash-to-dock@micxgx.gmail.com"
            "caffeine@patapon.info"
            "gsconnect@andyholmes.github.io"
            "editdesktopfiles@dannflower"
      ];
    };
    
  # --------------------------
  # Interface Settings
  # --------------------------
  "org/gnome/desktop/interface" = {
    gtk-theme = "Adwaita";
    icon-theme = "Adwaita";
    font-name = "Cantarell 11";
    document-font-name = "Cantarell 11";
    monospace-font-name = "Monospace 11";
    cursor-theme = "Adwaita";
    cursor-size = 24;
    color-scheme = "prefer-dark";
    show-battery-percentage = false;
    };

  # --------------------------
  # Background / Wallpaper
  # --------------------------
  "org/gnome/desktop/background" = {
    picture-uri = "file:///etc/nixos/assets/wallpapers/purple-abstract.png";
    picture-uri-dark = "file:///etc/nixos/assets/wallpapers/purple-abstract.png";
    picture-options = "zoom";
    primary-color = "#000000";
    secondary-color = "#000000";
    };

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

