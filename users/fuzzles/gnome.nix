#==========================================#
#       GNOME Home Manager
#==========================================#

{ config, pkgs, ... }:

{ 
  #--------------------------
  # Set Wallpaper & Lock Screen
  #--------------------------
  # Copy wallpaper into ~/Pictures
  home.file."Pictures/Wallpapers/bazzite.png".source =
    ./assets/wallpapers/bazzite.png;

  #--------------------------
  # Packages (user-level)
  #--------------------------
  home.packages = with pkgs; [
    # Applications
    gnome-tweaks           # GNOME Tweaks
    ignition               # GNOME Startup
    pika-backup            # Backup GUI Tool
    impression             # ISO Image Writer
    dconf-editor           # GUI dconf Configuration

    # GNOME Extensions
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.dash-to-dock
    gnomeExtensions.caffeine
    gnomeExtensions.gsconnect
    gnomeExtensions.edit-desktop-files
    gnomeExtensions.all-in-one-clipboard
    gnomeExtensions.tiling-shell
  ];

  #--------------------------
  # dconf / GNOME settings
  #--------------------------     
    dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          appindicator.extensionUuid
          blur-my-shell.extensionUuid
          caffeine.extensionUuid
          dash-to-dock.extensionUuid
          edit-desktop-files.extensionUuid
          gsconnect.extensionUuid
          all-in-one-clipboard.extensionUuid
        ];        
      };
      
      # Dash to Dock
      "org/gnome/shell/extensions/dash-to-dock" = {
        dock-position = "BOTTOM";
        dash-max-icon-size = 32;
        custom-theme-shrink = true;
      };
      
      # Dark Mode
      "org/gnome/desktop/interface" = {
         color-scheme = "prefer-dark";
         gtk-theme = "Adwaita-dark";
         icon-theme = "Adwaita";
      };
      
      # Wallpaper      
      "org/gnome/desktop/background" = {
          picture-uri = "file://${config.home.homeDirectory}/Pictures/Wallpapers/bazzite.png";
          picture-uri-dark = "file://${config.home.homeDirectory}/Pictures/Wallpapers/bazzite.png";
          picture-options = "zoom";
       };
       
       # Lock screen wallpaper
       "org/gnome/desktop/screensaver" = {
          picture-uri = "file://${config.home.homeDirectory}/Pictures/Wallpapers/bazzite.png";
          picture-options = "zoom";
          };
    };
  };
}

