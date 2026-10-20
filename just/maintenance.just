#--------------------------------#
#          System Maintenance
#--------------------------------#

# Display system generations.
sys-list-generations:
    @printf '\n\033[1;33m▶ NixOS system generations\033[0m\n'
    sudo nix-env -p /nix/var/nix/profiles/system --list-generations
    @printf '\n\033[1;32m✔ NixOS system generations complete\033[0m\n'

# Destructive: require confirmation before deleting old system generations.
# This reduces available rollback options; only run after testing your new system.
sys-cleanup-generations:
    #!/usr/bin/env bash
    set -euo pipefail
    printf '\n\033[1;33m▶ Remove old generations (confirmation required)\033[0m\n'
    echo "WARNING: This removes older system generations and limits rollback options."
    read -r -p "Type DELETE to continue: " confirmation
    if [[ "$confirmation" != "DELETE" ]]; then
    echo "Cancelled; no generations deleted."
    exit 0
    fi
    sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old
    printf '\n\033[1;32m✔ Old generations removed\033[0m\n'

# Conservative GC: keep generations; remove only unreachable store objects.
sys-garbage-collect:
    @printf '\n\033[1;33m▶ Collecting unreachable Nix store paths\033[0m\n'
    sudo nix-collect-garbage
    @printf '\n\033[1;32m✔ Collecting unreachable Nix store paths complete\033[0m\n'

# Safe default cleanup; does not discard previous boot generations.
sys-clean-system:
    @just sys-garbage-collect
    @printf '\n\033[1;33m▶ Safe system cleanup\033[0m\n'
    @printf '\n\033[1;32m✔ Safe system cleanup complete\033[0m\n'

