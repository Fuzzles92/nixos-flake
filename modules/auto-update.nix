#==========================================#
#        Flake Auto Upgrade
#==========================================#

{ config, pkgs, ... }:

{
  system.autoUpgrade = {
    enable = true;

    # Pull from your git repo (recommended)
    flake = "https://github.com/Fuzzles92/nixos_config";

    # Run daily at 03:00
    dates = "daily";

    # Don’t reboot automatically
    allowReboot = false;

    # Optional but recommended
    persistent = true;
  };
}
