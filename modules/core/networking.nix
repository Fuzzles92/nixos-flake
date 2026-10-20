#--------------------------------#
#           Networking
#--------------------------------#

{ ... }: {
  #--------------------------------#
  #   Hostname & NetworkManager
  #--------------------------------#
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
}
