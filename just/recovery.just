#--------------------------------#
#          Recovery and Setup
#--------------------------------#

# Check for an SSH key and test GitHub authentication (without hiding errors).
ssh-setup:
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    @if [ -f "$HOME/.ssh/id_ed25519" ]; then echo "SSH key found"; else echo "No SSH key: run ssh-keygen -t ed25519"; fi
    ssh -T git@github.com || [ "$?" -eq 1 ]

# Initial checks; does not rebuild or change Git history.
sys-bootstrap: git-status flake-check sys-dry-run

