#==========================================#
#        Gaming
#==========================================#

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
    input-remapper
    mangohud
    mangojuice
    gamemode
    protonup-qt
    lutris
    heroic
  ];

  #--------------------------
  # CPU Performance
  #--------------------------
  powerManagement.cpuFreqGovernor = "performance";

  #--------------------------
  # Audio / 32-bit
  #--------------------------
  services.pipewire.alsa.support32Bit = true;

}
