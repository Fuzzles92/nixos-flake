#--------------------------------#
#          Recovery and Setup
#--------------------------------#

# Check for an SSH key and test GitHub authentication (without hiding errors).
ssh-setup:
    @printf '\n\033[1;33m▶ Checking GitHub SSH access\033[0m\n'
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    @if [ -f "$HOME/.ssh/id_ed25519" ]; then echo "SSH key found"; else echo "No SSH key: run ssh-keygen -t ed25519"; fi
    ssh -T git@github.com || [ "$?" -eq 1 ]
    @printf '\n\033[1;32m✔ Checking GitHub SSH access complete\033[0m\n'

# Initial checks; does not rebuild or change Git history.
sys-bootstrap:
    @just git-status
    @just flake-check
    @just sys-dry-run
    @printf '\n\033[1;33m▶ Running initial setup checks\033[0m\n'
    @printf '\n\033[1;32m✔ Running initial setup checks complete\033[0m\n'

