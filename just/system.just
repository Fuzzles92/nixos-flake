#--------------------------------#
#          System Management
#--------------------------------#

# Preview evaluation and required builds; do not activate changes.
sys-dry-run:
    sudo nixos-rebuild dry-build --flake "{{FLAKE}}#{{FLAKE_HOST}}" --show-trace

# Fully build without activating or selecting the generation for boot.
sys-build:
    sudo nixos-rebuild build --flake "{{FLAKE}}#{{FLAKE_HOST}}" --show-trace

# Build and make the new generation the default on next boot.
sys-rebuild-boot:
    sudo nixos-rebuild boot --flake "{{FLAKE}}#{{FLAKE_HOST}}" --show-trace
    @echo "Build complete. Reboot to activate the new configuration."

# Build and activate now.
sys-switch:
    sudo nixos-rebuild switch --flake "{{FLAKE}}#{{FLAKE_HOST}}" --show-trace

# Show host information.
sys-info:
    hostnamectl

# Roll back to the previous generation immediately.
sys-rollback:
    sudo nixos-rebuild switch --rollback

# Check, then build for the next reboot; does NOT update dependencies or push Git.
sys-check-boot: flake-check sys-rebuild-boot

# Check, then switch immediately; does NOT update dependencies or push Git.
sys-check-switch: flake-check sys-switch

# Back up the currently working configuration BEFORE updating flake.lock.
# Then validate/build the new configuration. Git backup does not create NixOS generations.
# Note: failures during updating/building leave the original Git commit intact.
sys-update-boot: git-backup git-push flake-update flake-check sys-rebuild-boot

sys-update-switch: git-backup git-push flake-update flake-check sys-switch
