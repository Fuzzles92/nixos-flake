#==========================================#
#        Flake Auto Upgrade
#==========================================#

{ config, pkgs, ... }:

{
  system.autoUpgrade = {
    enable = true;

    # Use your flake source
    #flake = "github:Fuzzles92/nixos_config";
    flake = "/etc/nixos";


    # Run every day at 03:00
    dates = "03:00";

    # Do NOT reboot automatically
    allowReboot = false;

    # If machine was off at 03:00, run at next boot
    persistent = true;
  };
}
