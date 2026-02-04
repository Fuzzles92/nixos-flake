#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────────────────────
# Ensure script is run as root
# ─────────────────────────────────────────────────────────────
if [[ "$EUID" -ne 0 ]]; then
  echo "⚠️  Please run as root: sudo ./nixos-helper.sh"
  exit 1
fi

# ─────────────────────────────────────────────────────────────
# Colors
# ─────────────────────────────────────────────────────────────
GREEN="\033[0;32m"
YELLOW="\033[38;2;255;230;0m"
LUNA_PURPLE=""
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

useful_commands() {
    echo -e "\n${NIX_BLUE}▶ Useful Commands${NC}\n"
    echo -e "\n${NIX_BLUE}# ─────────────────────────────────────────────────────────────${NC}\n"
    echo -e "\n${NIX_BLUE}Test Build a Version - ${NC} nix build github:sinelaw/fresh/v0.1.65\n"
    echo -e "\n${NIX_BLUE}# ─────────────────────────────────────────────────────────────${NC}\n"
    echo -e "\n${NIX_BLUE}Build Flake - ${NC} sudo nixos-rebuild switch --flake '/etc/nixos#nixos'\n"
    echo -e "\n${NIX_BLUE}# ─────────────────────────────────────────────────────────────${NC}\n"
    echo ""
    echo -e "\n${NIX_BLUE}# ─────────────────────────────────────────────────────────────${NC}\n"
}

cleanup_generations() {
    echo -e "\n${NIX_BLUE}▶ Cleaning up old NixOS generations...${NC}\n"

    echo -e "${YELLOW}Current system generations:${NC}\n"
    nix-env -p /nix/var/nix/profiles/system --list-generations
    echo

    read -rp "$(echo -e "${YELLOW}Delete ALL old generations except the current one? (Y/N): ${NC}")" confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Cleanup cancelled.${NC}"
        return
    fi

    echo -e "\n${NIX_BLUE}▶ Deleting old generations...${NC}\n"
    nix-env -p /nix/var/nix/profiles/system --delete-generations old

    echo -e "\n${GREEN}✔ Old generations removed.${NC}\n"

    read -rp "$(echo -e "${YELLOW}Run garbage collection to free disk space? (Y/N): ${NC}")" gc_confirm
    if [[ "$gc_confirm" =~ ^[Yy]$ ]]; then
        echo -e "\n${NIX_BLUE}▶ Running nix-collect-garbage...${NC}\n"
        nix-collect-garbage -d
        echo -e "\n${GREEN}✔ Garbage collection complete.${NC}"
    else
        echo -e "${YELLOW}Skipping garbage collection.${NC}"
    fi
}


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

# ─────────────────────────────────────────────────────────────
# Main Menu Loop
# ─────────────────────────────────────────────────────────────
while true; do
    clear
    echo -e "${NIX_BLUE}=============================================${NC}"
    echo -e "${NIX_BLUE}               NixOS Helper                   ${NC}"
    echo -e "${NIX_BLUE}=============================================${NC}"
    echo
    echo "System Name: $HOST"
    echo
    echo "1) Update flake inputs + rebuild"
    echo "2) Rebuild only (no flake update)"
    echo "3) Dry-run rebuild (preview)"
    echo "4) Rollback to previous or specific generation"
    echo "5) List system generations"
    echo "6) Useful Commands"
    echo "7) Cleanup Generations"
    echo "8) Exit"
    echo
    read -rp "$(echo -e "${YELLOW}Select an option [1-8]: ${NC}")" choice

    case "$choice" in
        1) update_flake; rebuild_nixos ;;
        2) rebuild_nixos ;;
        3) dry_run_rebuild ;;
        4) rollback_nixos ;;
        5) list_generations ;;
        6) useful_commands ;;
        7) cleanup_generations ; rebuild_nixos ;;
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
