FLAKE := "/etc/nixos"
HOST := `hostname`

default: list-recipes

# List all available recipes
list-recipes:
    @just --list

# Git backup configuration
git-backup:
    @echo ""
    @echo -e "\033[1;33m▶ Backing up NixOS configuration...\033[0m"
    cd {{FLAKE}} && git add .
    cd {{FLAKE}} && git commit -m "NixOS Update: $(date '+%Y-%m-%d %H:%M:%S')" || true
    @echo ""
    @echo -e "\033[1;32m✔ Git Backup Complete\033[0m"

# Push configuration to GitHub
git-push:
    @echo ""
    @echo -e "\033[1;33m▶ Pushing NixOS configuration...\033[0m"
    cd {{FLAKE}} && git push
    @echo ""
    @echo -e "\033[1;32m✔ Git Push Complete\033[0m"

# Display system information
system-info:
    @echo ""
    @echo -e "\033[1;33m▶ System Information\033[0m"
    hostnamectl

# Rebuild for Boot to the current configuration
rebuild:
    @echo ""
    @echo -e "\033[1;33m▶ Rebuilding NixOS for {{HOST}}...\033[0m"
    sudo nixos-rebuild boot --flake {{FLAKE}}#{{HOST}} --show-trace
    @echo ""
    @echo -e "\033[1;32m✔ Rebuild Complete, Reboot Required\033[0m"

# Update flake inputs
update:
    @echo ""
    @echo -e "\033[1;33m▶ Updating Flake Inputs...\033[0m"
    sudo nix flake update --flake {{FLAKE}}
    @echo ""
    @echo -e "\033[1;32m✔ Flake Update Complete\033[0m"

# Validate flake configuration
check-flake:
    @echo ""
    @echo -e "\033[1;33m▶ Checking Flake...\033[0m"
    nix flake check {{FLAKE}}
    @echo ""
    @echo -e "\033[1;32m✔ Flake Check Complete\033[0m"

# Update flake, validate configuration, and rebuild system
update-rebuild:
    @just git-backup
    @just git-push
    @just update
    @just check-flake
    @just rebuild
    @echo ""
    @echo -e "\033[1;32m✔ System Update Complete + Backed Up\033[0m"

# Preview rebuild without applying changes
dry-run:
    @echo ""
    @echo -e "\033[1;33m▶ Running Dry-run Rebuild...\033[0m"
    sudo nixos-rebuild dry-run --flake {{FLAKE}}#{{HOST}} --show-trace
    @echo ""
    @echo -e "\033[1;32m✔ Dry-run Complete\033[0m"

# Roll back to the previous system generation
rollback-prev-gen:
    @echo ""
    @echo -e "\033[1;33m▶ Rolling Back NixOS...\033[0m"
    sudo nixos-rebuild switch --rollback
    @echo ""
    @echo -e "\033[1;32m✔ Rollback Complete\033[0m"

switch:
    @echo ""
    @echo -e "\033[1;33m▶ Switching to {{HOST}}...\033[0m"
    sudo nixos-rebuild switch --flake {{FLAKE}}#{{HOST}} --show-trace
    
# List all system generations
list-generations:
    @echo ""
    @echo -e "\033[1;33m▶ System Generations:\033[0m"
    sudo nix-env -p /nix/var/nix/profiles/system --list-generations

# Remove old system generations
cleanup-generations:
    @echo ""
    @echo -e "\033[1;33m▶ Removing Old Generations...\033[0m"
    sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old
    @echo -e "\033[0;32m✔ Cleanup Complete\033[0m"
    
# Run Nix garbage collection
garbage-collect:
    @echo ""
    @echo -e "\033[1;33m▶ Running Garbage Collection...\033[0m"
    sudo nix-collect-garbage -d
    @echo ""
    @echo -e "\033[1;32m✔ Garbage Collection Complete\033[0m"

# Remove old generations and run garbage collection
clean-system:
    @just cleanup-generations
    @just garbage-collect
    @echo ""
    @echo -e "\033[1;32m✔ System Cleanup Complete\033[0m"
