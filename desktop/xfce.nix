#==========================================#
#         XFCE Dekstop
#==========================================#

{ config, pkgs, ... }:

{

  #--------------------------
  #  XFCE
  #--------------------------
  services.xserver = {
    enable = true;
    desktopManager = {
		xterm.enable = false;
		xfce.enable = true;
    };
  };

  #--------------------------
  #  Auto Login
  #--------------------------
  services.displayManager = {
              autoLogin.enable = true;
              autoLogin.user = "fuzzles";
};

  services.displayManager.defaultSession = "xfce";

  #--------------------------
  #  DG Desktop Portals (Flatpak)
  #--------------------------
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
        xdg-desktop-portal-gtk   # GTK backend
        xdg-desktop-portal-xapp  # XFCE/MATE backend (optional)
        ];
  xdg.portal.config.common.default = "*"; # pick first available portal

}
