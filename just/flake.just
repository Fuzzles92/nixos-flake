#--------------------------------#
#          Flake Management
#--------------------------------#

# Validate flake outputs; tracked files must be visible to Git.
flake-check:
    nix flake check "{{FLAKE}}" --show-trace

# Update flake.lock as the regular user, then inspect with git diff.
flake-update:
    nix flake update --flake "{{FLAKE}}"
    @echo "Review dependency changes: git diff -- flake.lock"

# Display currently locked inputs.
flake-info:
    nix flake metadata "{{FLAKE}}"
