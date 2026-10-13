#================================#
#           My Flake
#================================#

{
  description = "Fuzzles92 Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak?ref=v0.6.0";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, lanzaboote, nix-flatpak, home-manager }:
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./configuration.nix            # System Configuration
        ./hardware-configuration.nix   # Hardware Configuration
        ./modules/lanzaboote.nix       # Lanzaboote Module (Secure Boot)
        ./modules/printing.nix         # Printing & Scanning Module
        ./modules/flatpak.nix          # Flatpak Module
        ./modules/gaming.nix           # Gaming Module
        ./modules/developer.nix        # Developer Module
        ./desktop/gnome.nix            # GNOME Desktop
        
        # Lanzaboote (Secure Boot) as a NixOS module
        lanzaboote.nixosModules.lanzaboote

        # Flatpak as a NixOS module
        nix-flatpak.nixosModules.nix-flatpak

        # Home Manager as a NixOS module
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";

          home-manager.users = {
            fuzzles = import ./users/fuzzles/home.nix;
          };
        }
      ];
    };
  };
}
