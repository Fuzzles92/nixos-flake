#==========================================#
#             Flake
#==========================================#

{
  description = "My Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fresh.url = "github:sinelaw/fresh/v0.1.65";
  };

  outputs = { self, nixpkgs, nix-flatpak, home-manager, lanzaboote, fresh }:
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem
    {
      system = "x86_64-linux";
      specialArgs = { inherit fresh; };
      modules = [
        ./configuration.nix

        # Home Manager as a NixOS module
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.fuzzles = import ./home.nix;

        }

        # Flatpak as a NixOS module
        nix-flatpak.nixosModules.nix-flatpak

        # Lanzaboote (Secure Boot) as a NixOS module
        lanzaboote.nixosModules.lanzaboote
      ];
    };
  };
}
