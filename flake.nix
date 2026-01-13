{
  description = "Fuzzles Flake";

  nixConfig.experimental-features = [ "nix-command" "flakes" ];

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fresh.url = "github:sinelaw/fresh/v0.1.65";
  };
  
  #outputs = { self, nixpkgs, lanzaboote, nix-flatpak }: 
  outputs = { self, nixpkgs, lanzaboote, nix-flatpak, fresh }: 
  {
    nixosConfigurations.Layla = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit fresh; };

      modules = [
        ./configuration.nix
        ./modules/secure-boot.nix
        ./modules/flatpak.nix
        lanzaboote.nixosModules.lanzaboote
        nix-flatpak.nixosModules.nix-flatpak
      ];
    };
  };
}
