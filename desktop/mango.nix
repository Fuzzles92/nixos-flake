#==========================================#
#       MangoWM Config
#==========================================#

{ config, pkgs, ... }:

{

  #--------------------------
  #  Display Manager (LightDM)
  #--------------------------
  #services.xserver.displayManager.lightdm.enable = true;


  #--------------------------
  #  Mango Window Manager
  #--------------------------
  programs.mango.enable = true;

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
  # Managed By Home Manager
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
