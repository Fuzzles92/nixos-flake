#--------------------------------#
#          System Maintenance
#--------------------------------#

# Display system generations.
sys-list-generations:
    sudo nix-env -p /nix/var/nix/profiles/system --list-generations

# Destructive: require confirmation before deleting old system generations.
# This reduces available rollback options; only run after testing your new system.
sys-cleanup-generations:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "WARNING: This removes older system generations and limits rollback options."
    read -r -p "Type DELETE to continue: " confirmation
    if [[ "$confirmation" != "DELETE" ]]; then
      echo "Cancelled; no generations deleted."
      exit 0
    fi
    sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old

# Conservative GC: keep generations; remove only unreachable store objects.
sys-garbage-collect:
    sudo nix-collect-garbage

# Safe default cleanup; does not discard previous boot generations.
sys-clean-system: sys-garbage-collect

