#================================#
#            Lanzaboote
#================================#

{ pkgs, lib, ... }:

{
  # Secure Boot management and verification tools
  environment.systemPackages = [
    pkgs.sbctl
  ];

  # Lanzaboote replaces the standard systemd-boot module
  boot.loader.systemd-boot.enable = lib.mkForce false;

  # Secure Boot configuration
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl"; # Signing keys managed by sbctl
  };
}
