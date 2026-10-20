#--------------------------------#
#          NixOS Justfile
#--------------------------------#

# The flake configuration is named "nixos" in flake.nix.
# Change FLAKE_HOST if you rename nixosConfigurations.nixos.
FLAKE := "/etc/nixos"
FLAKE_HOST := "nixos"

# Keep commands running inside the NixOS repository.
set working-directory := FLAKE

#--------------------------------#
#          Recipe Imports
#--------------------------------#

import "just/system.just"
import "just/flake.just"
import "just/git.just"
import "just/maintenance.just"
import "just/recovery.just"

#--------------------------------#
#          Recipe Menu
#--------------------------------#

default: list-recipes

list-recipes:
    @just --list
