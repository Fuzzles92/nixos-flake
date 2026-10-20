#--------------------------------#
#          Flake Management
#--------------------------------#

# Validate flake outputs; tracked files must be visible to Git.
flake-check:
    @printf '\n\033[1;33m▶ Checking flake\033[0m\n'
    nix flake check "{{FLAKE}}" --show-trace
    @printf '\n\033[1;32m✔ Checking flake complete\033[0m\n'

# Update flake.lock as the regular user, then inspect with git diff.
flake-update:
    @printf '\n\033[1;33m▶ Updating flake inputs\033[0m\n'
    nix flake update --flake "{{FLAKE}}"
    @echo "Review dependency changes: git diff -- flake.lock"
    @printf '\n\033[1;32m✔ Updating flake inputs complete\033[0m\n'

# Display currently locked inputs.
flake-info:
    @printf '\n\033[1;33m▶ Flake input information\033[0m\n'
    nix flake metadata "{{FLAKE}}"
    @printf '\n\033[1;32m✔ Flake input information complete\033[0m\n'
