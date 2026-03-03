#==========================================#
#        Flake Auto Upgrade
#==========================================#

# Last Update was 2nd Mar 2026
# No. Gens are 10

{ config, pkgs, ... }:

{
  system.autoUpgrade = {
    enable = true;
    flake = "/etc/nixos";
    flags = [
      "--update-input"
      "nixpkgs"
    ];
    dates = "weekly";
    allowReboot = false;
    persistent = true;
  };
}
