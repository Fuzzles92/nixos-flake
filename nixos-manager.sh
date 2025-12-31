#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────────────────────
# Ensure script is run as root
# ─────────────────────────────────────────────────────────────
if [[ "$EUID" -ne 0 ]]; then
  echo "⚠️  Please run as root: sudo ./nixos-manager.sh"
  exit 1
fi

# ─────────────────────────────────────────────────────────────
# Colors
# ─────────────────────────────────────────────────────────────
GREEN="\033[0;32m"
YELLOW="\033[38;2;255;230;0m"
NIX_BLUE="\033[38;2;0;114;198m"
NC="\033[0m"

# ─────────────────────────────────────────────────────────────
# Configuration
# ─────────────────────────────────────────────────────────────
FLAKE_DIR="/etc/nixos"
HOST="${HOSTNAME:-$(hostname)}"

# ─────────────────────────────────────────────────────────────
# Functions
# ─────────────────────────────────────────────────────────────

update_flake() {
    echo -e "\n${NIX_BLUE}▶ Updating flake inputs...${NC}\n"
    nix flake update --flake "$FLAKE_DIR"
    echo -e "\n${GREEN}✔ Flake update complete.${NC}"
}

rebuild_nixos() {
    echo -e "\n${NIX_BLUE}▶ Rebuilding NixOS for $HOST...${NC}\n"
    nixos-rebuild switch --flake "$FLAKE_DIR#$HOST" --show-trace
    echo -e "\n${GREEN}✔ Rebuild complete.${NC}"
    echo
    
    read -rp "$(echo -e "${YELLOW}Reboot now? (Y/N): ${NC}")" reboot_choice
    if [[ "$reboot_choice" =~ ^[Yy]$ ]]; then
        echo -e "${GREEN}Rebooting...${NC}"
        reboot
    fi
}

dry_run_rebuild() {
    echo -e "\n${NIX_BLUE}▶ Running dry-run rebuild...${NC}\n"
    nixos-rebuild dry-run --flake "$FLAKE_DIR#$HOST" --show-trace
    echo -e "\n${GREEN}✔ Dry-run complete. No changes applied.${NC}"
}

garbage_collect() {
    echo -e "${NIX_BLUE}\n🧹 Garbage Collection (keep last 5 generations)...${NC}\n"
    # List all system generations
    mapfile -t gens < <(nix-env --list-generations -p /nix/var/nix/profiles/system | awk '{print $1}')

    # If generations are 6 or more, delete older ones
    if [ ${#gens[@]} -gt 5 ]; then
        del_count=$((${#gens[@]} - 5))
        old_gens=("${gens[@]:0:$del_count}")
        for gen in "${old_gens[@]}"; do
            nix-env -p /nix/var/nix/profiles/system --delete-generations "$gen"
        done
        echo -e "${GREEN}✨ Removed $del_count old generations. Kept last 5.${NC}"
    else
        echo -e "${GREEN}✔ Nothing to delete. You already have 5 or fewer generations.${NC}"
    fi

    echo -e "\n${NIX_BLUE}Running nix-collect-garbage...${NC}"
    nix-collect-garbage --delete-old

    echo -e "${GREEN}\n✔ Done!${NC}"
}

rollback_nixos() {
    echo -e "\n${NIX_BLUE}▶ NixOS Generations:${NC}\n"
    nix-env -p /nix/var/nix/profiles/system --list-generations
    echo

    read -rp "$(echo -e "${YELLOW}Enter a generation number or 'p' for previous: ${NC}")" gen_choice

    if [[ "$gen_choice" == "p" || "$gen_choice" == "P" ]]; then
        echo -e "${NIX_BLUE}\n▶ Rolling back to previous generation...${NC}\n"
        nixos-rebuild switch --rollback
        echo -e "${GREEN}\n✔ Rolled back to previous generation.${NC}\n"
        
        read -rp "$(echo -e "${YELLOW}Reboot now? (Y/N): ${NC}")" reboot_choice
        if [[ "$reboot_choice" =~ ^[Yy]$ ]]; then
            echo -e "${GREEN}Rebooting...${NC}"
            reboot
        fi

    elif [[ "$gen_choice" =~ ^[0-9]+$ ]]; then
        echo -e "${NIX_BLUE}\n▶ Switching to generation $gen_choice...${NC}"
        nix-env -p /nix/var/nix/profiles/system --switch-generation "$gen_choice"
        echo -e "${GREEN}\n✔ Switched to generation $gen_choice.${NC}\n"

        # Ask for reboot
        read -rp "$(echo -e "${YELLOW}Reboot now to apply changes? (Y/N): ${NC}")" reboot_choice
        if [[ "$reboot_choice" =~ ^[Yy]$ ]]; then
            echo -e "${GREEN}Rebooting...${NC}"
            reboot
        else
            echo -e "${YELLOW}⚠️  Remember to reboot later to apply this generation.${NC}"
        fi

    else
        echo -e "${YELLOW}\nInvalid input, returning to menu...${NC}\n"
    fi
}

list_generations() {
    echo -e "\n${NIX_BLUE}▶ Listing NixOS generations...${NC}\n"
    nix-env -p /nix/var/nix/profiles/system --list-generations
}

backup_to_git() {
    GIT_DIR="/home/fuzzles/git/nixos-flake"

    echo -e "\n${NIX_BLUE}==========  BACKUP /etc/nixos → $GIT_DIR  ==========${NC}\n"

    # Ensure source exists
    if [ ! -d "$FLAKE_DIR" ]; then
        echo -e "${YELLOW}⚠️ /etc/nixos not found — aborting.${NC}\n"
        return
    fi

    # Ensure Git repo exists
    if [ ! -d "$GIT_DIR/.git" ]; then
        echo -e "${YELLOW}⚠️ Git repo not found at $GIT_DIR — initializing...${NC}\n"
        mkdir -p "$GIT_DIR"
        git -C "$GIT_DIR" init
    fi

    # Copy nixos folder content
    echo -e "${NIX_BLUE}▶ Copying /etc/nixos → $GIT_DIR${NC}\n"
    rsync -a --delete "$FLAKE_DIR/" "$GIT_DIR/"

    # Commit changes
    cd "$GIT_DIR" || { echo -e "${YELLOW}⚠️ Cannot cd to $GIT_DIR${NC}\n"; return; }
    git add .
    commit_msg="Backup ($HOST): $(date '+%Y-%m-%d %H:%M:%S')"

    if git commit -m "$commit_msg" 2>/dev/null; then
        echo -e "${GREEN}✔ Committed changes → '${commit_msg}'${NC}\n"
    else
        echo -e "${YELLOW}✔ Nothing new to commit — already up to date.${NC}\n"
    fi

    # Push if remote exists
    if git remote get-url origin &>/dev/null; then
        echo -e "${NIX_BLUE}▶ Pushing to remote...${NC}\n"
        git push origin main 2>/dev/null || git push origin master 2>/dev/null || \
            echo -e "${YELLOW}⚠️ Push failed — check remote or branch.${NC}\n"
        echo -e "${GREEN}✔ Backup pushed to remote successfully.${NC}\n"
    else
        echo -e "${YELLOW}⚠️ No remote configured — skipped push.${NC}\n"
    fi

    echo -e "${NIX_BLUE}==========  BACKUP COMPLETE  ==========${NC}\n"
}

# ─────────────────────────────────────────────────────────────
# Main Menu Loop
# ─────────────────────────────────────────────────────────────
while true; do
    clear
    echo -e "${NIX_BLUE}=============================================${NC}"
    echo -e "${NIX_BLUE}               NixOS Manager                 ${NC}"
    echo -e "${NIX_BLUE}=============================================${NC}"
    echo
    echo "System: $HOST"
    echo
    echo "1) Update flake inputs + rebuild"
    echo "2) Rebuild only (no flake update)"
    echo "3) Dry-run rebuild (preview)"
    echo "4) Garbage collect old generations"
    echo "5) Rollback to previous or specific generation"
    echo "6) List system generations"
    echo "7) Backup /etc/nixos to Git"
    echo "8) Exit"
    echo
    read -rp "$(echo -e "${YELLOW}Select an option [1-8]: ${NC}")" choice

    case "$choice" in
        1) update_flake; rebuild_nixos ;;
        2) rebuild_nixos ;;
        3) dry_run_rebuild ;;
        4) garbage_collect ;;
        5) rollback_nixos ;;
        6) list_generations ;;
        7) backup_to_git ;;
        8)
            echo -e "\n${GREEN}✔ Exiting. You can now close!${NC}\n"
            exit 0
            ;;
        *)
            echo -e "${YELLOW}Invalid option, try again...${NC}"
            sleep 1
            ;;
    esac

    echo -e "\n${YELLOW}Press Enter to return to menu...${NC}"
    read -r
done
