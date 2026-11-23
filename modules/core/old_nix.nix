#--------------------------------#
#          Nix Settings
#--------------------------------#

{ ... }: {
  #--------------------------------#
  #        Flakes & Nix CLI
  #--------------------------------#
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  #--------------------------------#
  #       Garbage Collection
  #--------------------------------#
  nix.gc = {
  	automatic = true;
  	dates = "weekly";
  	options = "--delete-older-than 10d";
  };

  #--------------------------------#
  #       Store Optimisation
  #--------------------------------#
  nix.optimise.automatic = true;

  #--------------------------------#
  #        Unfree Packages
  #--------------------------------#
  nixpkgs.config.allowUnfree = true;
}
