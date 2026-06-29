#================================#
#        Gaming Module
#================================#

{ config, pkgs, ... }:

{
  #--------------------------
  # Steam
  #--------------------------
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  
  
  #--------------------------
  # Game Mode
  #--------------------------
  programs.gamemode.enable = true;
  
  #--------------------------
  # Gamescope
  #--------------------------
  programs.gamescope.enable = true;
  
  #--------------------------
  # Controller Support
  #--------------------------
  hardware.bluetooth.enable = true;
  hardware.xone.enable = true;       # Xbox wireless adapter
  boot.kernelModules = [ "joydev" ]; # Generic joystick support

  #--------------------------
  # Vulkan support (32-bit needed for Steam/Proton)
  #--------------------------
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  #--------------------------
  # Gaming Utilities
  #--------------------------
  environment.systemPackages = with pkgs; [
       protonplus       # Manage Proton versions
       lutris           # Game launcher for Windows/emulators
       protonup-qt      # Install/manage Proton-GE
       #heroic           # Epic/GOG/Amazon game launcher
       mangohud         # FPS/performance overlay
       gamescope        # Valve gaming compositor
       gamemode         # Performance boost daemon
       input-remapper   # Remap inputs per game
       mangojuice       # MangoHud GUI/tweaks tool
  ];

}
