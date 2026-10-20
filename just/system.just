#--------------------------------#
#          System Management
#--------------------------------#

# Preview evaluation and required builds; do not activate changes.
sys-dry-run:
    @printf '\n\033[1;33m▶ Dry-run NixOS build\033[0m\n'
    sudo nixos-rebuild dry-build --flake "{{FLAKE}}#{{FLAKE_HOST}}" --show-trace
    @printf '\n\033[1;32m✔ Dry-run NixOS build complete\033[0m\n'

# Fully build without activating or selecting the generation for boot.
sys-build:
    @printf '\n\033[1;33m▶ Building NixOS (no activation)\033[0m\n'
    sudo nixos-rebuild build --flake "{{FLAKE}}#{{FLAKE_HOST}}" --show-trace
    @printf '\n\033[1;32m✔ Building NixOS (no activation) complete\033[0m\n'

# Build and make the new generation the default on next boot.
sys-rebuild-boot:
    @printf '\n\033[1;33m▶ Building NixOS for next boot\033[0m\n'
    sudo nixos-rebuild boot --flake "{{FLAKE}}#{{FLAKE_HOST}}" --show-trace
    @echo "Build complete. Reboot to activate the new configuration."
    @printf '\n\033[1;32m✔ Building NixOS for next boot complete\033[0m\n'

# Build and activate now.
sys-switch:
    @printf '\n\033[1;33m▶ Switching to new NixOS generation\033[0m\n'
    sudo nixos-rebuild switch --flake "{{FLAKE}}#{{FLAKE_HOST}}" --show-trace
    @printf '\n\033[1;32m✔ Switching to new NixOS generation complete\033[0m\n'

# Show host information.
sys-info:
    @printf '\n\033[1;33m▶ System information\033[0m\n'
    hostnamectl
    @printf '\n\033[1;32m✔ System information complete\033[0m\n'

# Roll back to the previous generation immediately.
sys-rollback:
    @printf '\n\033[1;33m▶ Rolling back NixOS\033[0m\n'
    sudo nixos-rebuild switch --rollback
    @printf '\n\033[1;32m✔ Rolling back NixOS complete\033[0m\n'

#--------------------------------#
#          Checked Rebuilds
#--------------------------------#

# Check, then build for the next reboot; no dependency updates or Git pushes.
sys-check-boot:
    @printf '\n\033[1;33m▶ Checking configuration before boot build...\033[0m\n'
    @just flake-check
    @just sys-rebuild-boot
    @printf '\n\033[1;32m✔ Checked boot build complete\033[0m\n'

# Check, then switch immediately; no dependency updates or Git pushes.
sys-check-switch:
    @printf '\n\033[1;33m▶ Checking configuration before switch...\033[0m\n'
    @just flake-check
    @just sys-switch
    @printf '\n\033[1;32m✔ Checked switch complete\033[0m\n'

#--------------------------------#
#          Full Updates
#--------------------------------#

# Back up your CURRENT configuration before altering flake.lock.
# Important: a Git commit backs up files, whereas NixOS generations enable boot rollback.
sys-update-boot:
    @printf '\n\033[1;33m▶ [1/5] Backing up existing configuration...\033[0m\n'
    @just git-backup
    @printf '\n\033[1;33m▶ [2/5] Pushing backup to GitHub...\033[0m\n'
    @just git-push
    @printf '\n\033[1;33m▶ [3/5] Updating flake inputs...\033[0m\n'
    @just flake-update
    @printf '\n\033[1;33m▶ [4/5] Checking updated flake...\033[0m\n'
    @just flake-check
    @printf '\n\033[1;33m▶ [5/5] Building for next boot...\033[0m\n'
    @just sys-rebuild-boot
    @printf '\n\033[1;32m✔ Update complete! Reboot to activate.\033[0m\n'
    @printf 'Tip: Review and commit the updated flake.lock after testing.\n'

# Same backup-first workflow, but activates the newly built system now.
sys-update-switch:
    @printf '\n\033[1;33m▶ [1/5] Backing up existing configuration...\033[0m\n'
    @just git-backup
    @printf '\n\033[1;33m▶ [2/5] Pushing backup to GitHub...\033[0m\n'
    @just git-push
    @printf '\n\033[1;33m▶ [3/5] Updating flake inputs...\033[0m\n'
    @just flake-update
    @printf '\n\033[1;33m▶ [4/5] Checking updated flake...\033[0m\n'
    @just flake-check
    @printf '\n\033[1;33m▶ [5/5] Building and switching...\033[0m\n'
    @just sys-switch
    @printf '\n\033[1;32m✔ Update complete! New system activated.\033[0m\n'
    @printf 'Tip: Review and commit the updated flake.lock after testing.\n'
