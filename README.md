# Fuzzles NixOS configuration — setup and maintenance

Modular, flake-based **NixOS 26.05 stable** configuration for an `x86_64-linux` machine with GNOME, Home Manager, Flatpak, gaming, printing, development tools and Lanzaboote Secure Boot. This README describes the **actual files in this repository**.

For the complete recipe reference, see **[JUST-README.md](JUST-README.md)**.

## Directory layout

```text
/etc/nixos/
├── flake.nix                  # Inputs and nixosConfigurations.nixos
├── flake.lock                 # Exact locked input revisions; commit this
├── configuration.nix          # General system configuration
├── hardware-configuration.nix # Machine-specific disks/filesystems
├── Justfile                  # Just entrypoint
├── just/                     # System, flake, git, maintenance, recovery recipes
├── modules/
│   ├── core/                 # Boot, Lanzaboote, Nix, locale, networking
│   ├── desktops/             # GNOME, KDE, COSMIC, Qtile system modules
│   ├── development/default.nix
│   ├── gaming.nix
│   ├── printing.nix
│   └── flatpak.nix
├── home/desktops/            # Per-user desktop Home Manager modules
└── users/
    ├── default.nix           # Imports system user accounts
    └── fuzzles/
        ├── default.nix       # Linux account and groups
        ├── home.nix          # Home Manager configuration
        ├── assets/           # Wallpapers and icons
        ├── qtile/            # Personal Qtile scripts
        └── rofi/             # Personal Rofi styles
```

### Who configures what?

- `flake.nix`: selects which NixOS modules to load and wires **Home Manager for each user**.
- `configuration.nix` and `modules/`: define machine-wide settings and services.
- `users/<name>/default.nix`: defines the system account and group membership.
- `users/<name>/home.nix`: controls that user's Home Manager packages/settings and imports reusable modules from `home/`.
- `home/desktops/`: user-level desktop settings such as GNOME extensions and dconf preferences. This repository's GNOME Home Manager module currently references wallpapers under `users/fuzzles/assets/`, so it is **not fully user-neutral** until those asset paths are changed.
- `Justfile` and `just/`: command shortcuts; `nixjust` is the user-friendly wrapper.

## What is enabled today?

- **NixOS 26.05 stable**, with Home Manager `release-26.05`, and locked dependencies in `flake.lock`.
- **GNOME and GDM**. KDE, COSMIC and Qtile module files exist but are **commented out** in `flake.nix`.
- Home Manager for **`fuzzles`**, including GNOME extensions, wallpaper, user packages, `just`, `fzf` and a `nixjust` launcher.
- **Lanzaboote Secure Boot** using signing material at `/var/lib/sbctl`.
- **nix-flatpak** with Flathub configured and scheduled Flatpak updates.
- **Gaming:** Steam, Lutris, Heroic, GameMode and gaming support packages.
- **Development:** VSCodium, Git, Podman, Distrobox, Distroshelf, Virt-Manager/libvirt, GNOME Boxes.
- **Printing/scanning:** CUPS, printer drivers, Avahi, IPP-over-USB and SANE.
- NetworkManager, PipeWire, Firefox, and other general system settings.

## Regular system management

Run the commands from `/etc/nixos` or use `nixjust` from anywhere:

```bash
cd /etc/nixos
just --list
just flake-check
just sys-dry-run
just sys-build
just sys-rebuild-boot      # Build for next boot
just sys-switch            # Apply immediately
just sys-list-generations
```

With your user wrapper:

```bash
nixjust                   # Interactive recipe selector
nixjust sys-update-boot   # Backup to GitHub, update dependencies, check, build for boot
nixjust git-sync          # Commit/push configuration to GitHub
```

Direct NixOS equivalents:

```bash
sudo nixos-rebuild dry-build --flake /etc/nixos#nixos --show-trace
sudo nixos-rebuild build --flake /etc/nixos#nixos
sudo nixos-rebuild boot --flake /etc/nixos#nixos
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

The flake output is literally **`nixos`**, not dynamically based on the machine's hostname. When you upgrade packages intentionally, `nix flake update --flake /etc/nixos` updates `flake.lock`. A normal rebuild does **not** update pinned dependencies.

## Adding a new Linux user

Example: add a user named `alice`. You need **both** a system account and a Home Manager entry if you want both managed declaratively.

**1. Create `users/alice/default.nix`:**

```nix
#--------------------------------#
#        Alice Account
#--------------------------------#
{ ... }:
{
  users.users.alice = {
    isNormalUser = true;
    description = "Alice";
    extraGroups = [ "networkmanager" ];
    # Add "wheel" only if Alice should use sudo.
  };
}
```

**2. Create `users/alice/home.nix`:**

```nix
#--------------------------------#
#       Alice Home Manager
#--------------------------------#
{ pkgs, ... }:
{
  home.username = "alice";
  home.homeDirectory = "/home/alice";
  home.stateVersion = "26.05"; # For a brand-new Home Manager user on 26.05

  programs.home-manager.enable = true;
  home.packages = with pkgs; [ firefox ];

  # Add selected modules if desired:
  # imports = [ ../../home/desktops/gnome.nix ];
}
```

**3. Import Alice's system account in `users/default.nix`:**

```nix
{ ... }:
{
  imports = [
    ./fuzzles/default.nix
    ./alice/default.nix
  ];
}
```

**4. Register her Home Manager module in `flake.nix`:**

```nix
home-manager.users = {
  fuzzles = import ./users/fuzzles/home.nix;
  alice = import ./users/alice/home.nix;
};
```

**5. Set a password and test:**

```bash
cd /etc/nixos
git add users/default.nix users/alice/ flake.nix
just sys-dry-run
sudo nixos-rebuild switch --flake .#nixos
sudo passwd alice
```

For additional desktops, avoid importing `home/desktops/gnome.nix` unchanged for another user until you make its hard-coded `users/fuzzles/assets/...` wallpaper source reusable. Alternatively, copy the appropriate wallpaper configuration into Alice's own Home Manager module.

**Important:** Keep existing `system.stateVersion` and `fuzzles`'s `home.stateVersion` at **`25.05`**. These are compatibility baselines, not current-release selectors. New users can use the version appropriate to when their Home Manager profile is first deployed.

## Adding or switching desktops/window managers

System-wide desktop modules live under `modules/desktops/` and are selected in the `modules = [ ... ]` list in `flake.nix`:

```nix
./modules/desktops/gnome.nix
# ./modules/desktops/kde.nix
# ./modules/desktops/cosmic.nix
# ./modules/desktops/qtile.nix
```

For `fuzzles`, Home Manager desktop imports are independently selected in `users/fuzzles/home.nix`:

```nix
imports = [
  ../../home/desktops/gnome.nix
  # ../../home/desktops/kde.nix
];
```

**Both sides matter:** enabling a system desktop module installs the session; importing the Home Manager desktop module applies the user's preferences and packages. You can install multiple sessions, but **do not enable GDM, SDDM and COSMIC greeter indiscriminately together**; choose a compatible display-manager arrangement. Check module conflicts before switching and test via `just sys-dry-run` and `just sys-build`.

## Package location: system vs user

System services and tools for all users belong in `configuration.nix` or `modules/` (e.g. printing, virtualisation, network services). Personal applications belong in `users/fuzzles/home.nix` or reusable `home/` modules. Flatpaks are defined using the `services.flatpak` settings in `modules/flatpak.nix`.

After changing files, **new Git-untracked Nix files must be staged** so the flake can see them:

```bash
cd /etc/nixos
git status
git add flake.nix users/ modules/ home/  # Review staged files before committing
just flake-check
just sys-dry-run
```

You do not have to commit before building; staging the new paths is enough. Because `git-backup` does `git add -A`, be mindful of sensitive files and unintended changes before using it.

## GitHub backup and reinstalling

Your Just recipes use Git's `origin` remote and `main` branch. `git-sync` commits and pushes; `sys-update-boot` deliberately **commits/pushes the existing version before changing `flake.lock`**.

For a new installation, prefer cloning the repository rather than downloading a ZIP: GitHub ZIP archives have **no `.git` folder**, so they lose Git history/remotes. After cloning, use the correct machine's `hardware-configuration.nix`, networking/hostname and boot configuration, and verify Secure Boot signing keys before rebuilding. **Never commit SSH private keys, Secure Boot private signing keys or other credentials.**

Your current config is tailored to one host named `nixos`. To support more machines, add separate `nixosConfigurations.<hostname>` outputs and machine-specific hardware/config modules. Don't blindly reuse disk, firmware or boot settings from another computer.

## Boot, rollback and cleanup

- `just sys-rebuild-boot`: prepares the **next** boot; it does not activate services immediately.
- `just sys-switch`: activates the new generation now.
- `just sys-rollback`: switches back to the previous system generation, if retained.
- If the new generation won't boot, select an earlier generation at boot.
- `just git-sync`: preserves source files/history, **not** the bootable system generation.

**Watch out:** `modules/core/nix.nix` configures:

```nix
nix.gc.automatic = true;
nix.gc.dates = "weekly";
nix.gc.options = "--delete-older-than 10d";
```

This **can delete system generations older than 10 days**, limiting rollback even without running the manually confirmed `sys-cleanup-generations` recipe. If preserving more rollback history is important, consider disabling age-based deletion or increasing its retention period. `just sys-clean-system` runs conservative `nix-collect-garbage` only; `sys-cleanup-generations` explicitly deletes old system generations after confirmation.

Secure Boot uses Lanzaboote rather than ordinary systemd-boot as the effective bootloader; `modules/core/lanzaboote.nix` forces `boot.loader.systemd-boot.enable = false`. On a fresh installation, restoring the Git repo alone does **not** restore `/var/lib/sbctl` signing keys. Plan key backup and enrolment separately before relying on Secure Boot.

## Useful troubleshooting commands

```bash
# Diagnose failed evaluation or build
nix flake check /etc/nixos --show-trace
sudo nixos-rebuild dry-build --flake /etc/nixos#nixos --show-trace

# Search installed system generations
sudo nix-env -p /nix/var/nix/profiles/system --list-generations

# See system-level unit failures
systemctl --failed
journalctl -b -p err

# User-level services
systemctl --user --failed
journalctl --user -b -p err

# Git status and tracked changes
cd /etc/nixos
git status
git diff
git diff --staged

# Current system and flake input details
nixos-version
nix flake metadata /etc/nixos

# Flatpak information
flatpak list
flatpak remotes
```

## Practical checklist before large changes

1. Check `git status`; keep sensitive data out of Git.
2. Back up your **known-working** config (`nixjust git-sync`).
3. Modify modules or deliberately update flake inputs.
4. Stage new files so flakes can read them; run `nixjust flake-check` and `nixjust sys-dry-run`.
5. Build via `nixjust sys-check-boot` or `nixjust sys-build`; reboot and verify.
6. Commit/push the new working state only after verifying it.
7. Retain at least one tested generation for rollback; review the automatic garbage-collection policy.
