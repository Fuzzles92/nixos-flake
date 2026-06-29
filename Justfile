FLAKE := "/etc/nixos"
HOST := `hostname`

# Sets Default
default: list-recipes

# List all available recipes
list-recipes:
    @just --list

# Git backup configuration
git-backup:
    @echo ""
    @echo -e "\033[1;33m▶ Backing up NixOS configuration...\033[0m"
    cd {{FLAKE}} && git add .
    cd {{FLAKE}} && if ! git diff --cached --quiet; then \
        git commit -m "NixOS Update: $(date '+%Y-%m-%d %H:%M:%S')"; \
    else \
        echo "No changes to commit"; \
    fi
    @echo ""
    @echo -e "\033[1;32m✔ Git Backup Complete\033[0m"

# Push Configurations to GitHub
git-push:
    @echo ""
    @echo -e "\033[1;33m▶ Pushing NixOS configuration...\033[0m"
    cd {{FLAKE}} && git push origin main
    @echo ""
    @echo -e "\033[1;32m✔ Git Push Complete\033[0m"

# Checks GitHub Status
git-status:
    @echo ""
    @echo -e "\033[1;33m▶ Git Status\033[0m"
    cd {{FLAKE}} && git status

# Display system information
sys-info:
    @echo ""
    @echo -e "\033[1;33m▶ System Information\033[0m"
    hostnamectl

# Rebuild for Boot to the current configuration
sys-rebuild-boot:
    @echo ""
    @echo -e "\033[1;33m▶ Rebuilding NixOS for {{HOST}}...\033[0m"
    sudo nixos-rebuild boot --flake {{FLAKE}}#{{HOST}} --show-trace
    @echo ""
    @echo -e "\033[1;32m✔ Rebuild Complete, Reboot Required\033[0m"

# Update flake inputs
flake-update:
    @echo ""
    @echo -e "\033[1;33m▶ Updating Flake Inputs...\033[0m"
    sudo nix flake update --flake {{FLAKE}}
    @echo ""
    @echo -e "\033[1;32m✔ Flake Update Complete\033[0m"

# Validate flake configuration
flake-check:
    @echo ""
    @echo -e "\033[1;33m▶ Checking Flake...\033[0m"
    nix flake check {{FLAKE}}
    @echo ""
    @echo -e "\033[1;32m✔ Flake Check Complete\033[0m"

# Update flake, validate configuration, and rebuild system
sys-update-boot:
    @just git-backup
    @just git-push
    @just flake-update
    @just flake-check
    @just sys-rebuild-boot
    @echo ""
    @echo -e "\033[1;32m✔ System Update Complete + Backed Up\033[0m"

# Update flake, validate configuration, and apply immediately
sys-update-switch:
    @just git-backup
    @just git-push
    @just flake-update
    @just flake-check
    @just sys-switch
    @echo ""
    @echo -e "\033[1;32m✔ System Update Applied + Backed Up\033[0m"

# Preview rebuild without applying changes
sys-dry-run:
    @echo ""
    @echo -e "\033[1;33m▶ Running Dry-run Rebuild...\033[0m"
    sudo nixos-rebuild dry-run --flake {{FLAKE}}#{{HOST}} --show-trace
    @echo ""
    @echo -e "\033[1;32m✔ Dry-run Complete\033[0m"

# Roll back to the previous system generation
sys-rollback:
    @echo ""
    @echo -e "\033[1;33m▶ Rolling Back NixOS...\033[0m"
    sudo nixos-rebuild switch --rollback
    @echo ""
    @echo -e "\033[1;32m✔ Rollback Complete\033[0m"

# Switch to New Build
sys-switch:
    @echo ""
    @echo -e "\033[1;33m▶ Switching to {{HOST}}...\033[0m"
    sudo nixos-rebuild switch --flake {{FLAKE}}#{{HOST}} --show-trace
    
# List all system generations
sys-list-generations:
    @echo ""
    @echo -e "\033[1;33m▶ System Generations:\033[0m"
    sudo nix-env -p /nix/var/nix/profiles/system --list-generations

# Remove old system generations
sys-cleanup-generations:
    @echo ""
    @echo -e "\033[1;33m▶ Removing Old Generations...\033[0m"
    sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old
    @echo -e "\033[0;32m✔ Cleanup Complete\033[0m"
    
# Run Nix garbage collection
sys-garbage-collect:
    @echo ""
    @echo -e "\033[1;33m▶ Running Garbage Collection...\033[0m"
    sudo nix-collect-garbage -d
    @echo ""
    @echo -e "\033[1;32m✔ Garbage Collection Complete\033[0m"

# Remove old generations and run garbage collection
sys-clean-system:
    @just sys-cleanup-generations
    @just sys-garbage-collect
    @echo ""
    @echo -e "\033[1;32m✔ System Cleanup Complete\033[0m"

# Setup SSH for GitHub
ssh-setup:
    @echo ""
    @echo -e "\033[1;33m▶ Checking SSH setup...\033[0m"
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/id_ed25519 2>/dev/null || true
    @if [ -f ~/.ssh/id_ed25519 ]; then \
        echo -e "\033[1;32m✔ SSH key found\033[0m"; \
    else \
        echo -e "\033[1;31m✘ No SSH key found\033[0m"; \
        echo "Create one with:"; \
        echo "ssh-keygen -t ed25519 -C \"matthewsproston92@gmail.com\""; \
    fi
    @echo ""
    @echo -e "\033[1;33m▶ Testing GitHub SSH...\033[0m"
    ssh -T git@github.com || true

# First Time Setup    
sys-bootstrap:
    @just ssh-setup
    @just git-status
    @just flake-check
    @just sys-switch
