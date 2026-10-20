#--------------------------------#
#             Gaming
#--------------------------------#

#--------------------------------#
#        Gaming Module #
#--------------------------------#

{ pkgs, ... }:

{
  #--------------------------------#
  #             Steam
  #--------------------------------#
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;

    # Enable only if hosting Source dedicated servers
    dedicatedServer.openFirewall = false;
  };

  #--------------------------------#
  #           Game Mode
  #--------------------------------#
  programs.gamemode.enable = true;

  #--------------------------------#
  #          AMD Graphics
  #--------------------------------#
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  #--------------------------------#
  #       Controller Support
  #--------------------------------#
  hardware.bluetooth.enable = true;
  hardware.xone.enable = true;
  boot.kernelModules = [ "joydev" ];

  #--------------------------------#
  #        Gaming Utilities
  #--------------------------------#
  environment.systemPackages = with pkgs; [
    # Game Launchers
    lutris
    heroic

    # Proton
    protonplus

    # Performance Monitoring and Configuration
    mangohud
    mangojuice

    # Controller / Input Configuration
    input-remapper
  ];
}
