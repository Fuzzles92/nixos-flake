#==========================================#
#               Lanzaboote                 #
#==========================================#

{ pkgs, lib, ... }:

{
  # Install sbctl so you can manage keys
  environment.systemPackages = [ pkgs.sbctl ];

  # Lanzaboote replaces systemd-boot
  boot.loader.systemd-boot.enable = lib.mkForce false;

  # Enable Lanzaboote and point to your key bundle
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
}
