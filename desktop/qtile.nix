#==========================================#
#       Qtile Config
#==========================================#

{ config, pkgs, ... }:

{

  #--------------------------
  #  Display Manager (LightDM)
  #--------------------------
  #services.xserver.displayManager.lightdm.enable = true;


  #--------------------------
  #  Qtile Window Manager
  #--------------------------
  services.xserver.enable = true;
  services.xserver.windowManager.qtile = {
        enable = true;
       extraPackages = python3Packages: with python3Packages; 
            [
              qtile-extras
            ];
  };

  #--------------------------
  #  DG Desktop Portals (Flatpak)
  #--------------------------
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
        xdg-desktop-portal-gtk   # GTK backend
        xdg-desktop-portal-xapp  # XFCE/MATE backend (optional)
        ];
  xdg.portal.config.common.default = "*"; # pick first available portal
  
  #--------------------------
  #  Polkit
  #--------------------------
  security.polkit.enable = true;
    
  #--------------------------
  #  System Packages
  #--------------------------
  environment.systemPackages = with pkgs; [
          lxqt.lxqt-policykit       # LXQT Polkit Agent
          thunar                    # XFCE Thunar File Manager
          thunar-volman             # XFCE Thunar USB & Removeable Media
          tumbler                   # XFCE Thunar Image/Video Thumbnail Support
          gvfs                      # XFCE Thunar Trash Support,Network Mounts etc
          mousepad                  # XFCE Text Editor
          ristretto                 # XFCE Image Viewer
          #rofi                      # Application Launcher
          #kdePackages.dolphin       # File Manager GUI
          kitty
          alacritty                 # Terminal
          networkmanagerapplet      # Network Manager Applet
          pavucontrol               # GUI PulseAudio
          alsa-utils                # Utils for Advanced Linux Sound Architecture
          pamixer                   # Pulseaudio Command Line Mixer
          blueman                   # Bluetooth
          flameshot                 # Screenshot Application
          copyq                     # Clipboard
  ];

  #--------------------------
  #  Hardware
  #--------------------------
  hardware.bluetooth.enable = true;

  #--------------------------
  #  Fonts
  #--------------------------
  fonts.packages =
    (with pkgs; [
      font-awesome
    ])
    ++ builtins.filter
      pkgs.lib.attrsets.isDerivation
      (builtins.attrValues pkgs.nerd-fonts);

}
