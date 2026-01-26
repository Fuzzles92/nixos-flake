#==========================================#
#        Flake Update
#==========================================#

{ config, pkgs, ... }:

{
  system.autoUpgrade = {
    enable = true;

    # Use flakes
    flake = "/etc/nixos";

    # Pull latest inputs + rebuild
    flags = [
      "--update-input"
      "nixpkgs"
      "--commit-lock-file"
    ];

    # Don’t reboot automatically
    allowReboot = false;

    # Run weekly (safe cadence)
    dates = "Sun 03:00";
  };
}
