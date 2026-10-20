# Just / nixjust — NixOS command guide

This guide documents the **actual recipes** in `Justfile` and `just/*.just` in this repository. Your flake lives at `/etc/nixos`, and the flake output is **`nixos`** (`nixosConfigurations.nixos`).

## Running recipes

From `/etc/nixos`:

```bash
cd /etc/nixos
just                # Show available recipes
just --list         # List every recipe
just sys-dry-run    # Run one recipe
```

From **any directory**, use the Home Manager wrapper:

```bash
nixjust                     # Interactive recipe picker (uses just --choose)
nixjust sys-dry-run
nixjust git-status
nixjust sys-update-boot
```

The wrapper is created by `users/fuzzles/home.nix` at `~/.local/bin/nixjust`. It points to `/etc/nixos/Justfile`, and `fzf` is in your Home Manager packages for the interactive chooser. If `nixjust` is not found, check `command -v nixjust` and whether `~/.local/bin` is in your `PATH`; you can always run `just --justfile /etc/nixos/Justfile --list` instead.

**Preview what Just will run** without executing it:

```bash
just --dry-run sys-update-boot
nixjust --dry-run sys-update-switch
```

> `just --dry-run` previews shell commands; `sys-dry-run` actually asks Nix to evaluate the new system with `nixos-rebuild dry-build`. Neither activates it.

## Recipe reference

| Recipe | File | What it does |
| --- | --- | --- |
| `list-recipes` | `Justfile` | Display recipes; also the default when running `just` |
| `sys-info` | `system.just` | Show host details using `hostnamectl` |
| `sys-dry-run` | `system.just` | Evaluate/preview the NixOS build; does not activate |
| `sys-build` | `system.just` | Actually build the system without activating it |
| `sys-rebuild-boot` | `system.just` | Build and select a generation for **next boot** |
| `sys-switch` | `system.just` | Build and activate immediately |
| `sys-rollback` | `system.just` | Switch immediately to the previous system generation |
| `sys-check-boot` | `system.just` | Check flake, then build for next boot |
| `sys-check-switch` | `system.just` | Check flake, then activate |
| `sys-update-boot` | `system.just` | Git commit → push → update lock file → flake check → boot build |
| `sys-update-switch` | `system.just` | Same full update, but activates immediately |
| `flake-check` | `flake.just` | Run `nix flake check` with a trace |
| `flake-update` | `flake.just` | Update pinned inputs in `flake.lock` |
| `flake-info` | `flake.just` | Show flake metadata/locked inputs |
| `git-status` | `git.just` | Inspect working-tree changes |
| `git-backup` | `git.just` | Stage **all** changes and commit if anything is staged |
| `git-push` | `git.just` | Push `main` to GitHub (`origin`) |
| `git-sync` | `git.just` | Commit changes, then push |
| `sys-list-generations` | `maintenance.just` | List available system generations |
| `sys-garbage-collect` | `maintenance.just` | Remove unreachable Nix store paths |
| `sys-clean-system` | `maintenance.just` | Alias for `sys-garbage-collect` |
| `sys-cleanup-generations` | `maintenance.just` | **Destructive:** type `DELETE` to remove old system generations |
| `ssh-setup` | `recovery.just` | Check for SSH key and test GitHub authentication |
| `sys-bootstrap` | `recovery.just` | Git status → flake check → system dry-build |

## Recommended workflows

### After editing a module (no package/input update)

```bash
nixjust git-status
nixjust sys-dry-run
nixjust sys-check-boot    # Build for next reboot (recommended for desktop/boot changes)
# Reboot when ready
nixjust git-sync          # Back up your reviewed changes
```

Use `nixjust sys-check-switch` to apply immediately instead. Neither `sys-check-*` updates `flake.lock` or pushes Git changes.

### Upgrade stable flake inputs (backup **before** update)

```bash
nixjust sys-update-boot
sudo reboot
```

This recipe runs, in order:

1. `git-backup`: stages *all* current files and commits them (if changed).
2. `git-push`: pushes the working configuration to `origin main`.
3. `flake-update`: refreshes locked dependencies.
4. `flake-check`: checks the flake.
5. `sys-rebuild-boot`: builds and sets the next boot generation.

`sys-update-switch` follows the same backup/update/check process but switches the running system. **Neither full-update recipe automatically commits the newly updated `flake.lock` afterward**. After testing the updated system, use `nixjust git-sync` to save that new working version. If the update fails, the earlier commit remains available, but your local lock file may have changed.

**Important:** `git-backup` uses `git add -A`; inspect `nixjust git-status` first and keep secrets out of the repository. If `git-push` fails (e.g. SSH not authorised), the update sequence stops until that is fixed.

### Test without altering system state

```bash
nixjust flake-check
nixjust sys-dry-run
nixjust sys-build        # Stronger test: does the actual build
```

### Git backup without updating

```bash
nixjust git-status
nixjust git-sync
```

### Roll back

```bash
nixjust sys-list-generations
nixjust sys-rollback
```

`sys-rollback` invokes `sudo nixos-rebuild switch --rollback` (immediate switch). If the system cannot boot, select an older generation from the boot menu. A **Git commit restores configuration source**, while a **NixOS generation restores a previously built system**; these are different protections. Rollback options disappear when you delete old generations or garbage-collect their store paths.

### Maintenance

```bash
nixjust sys-list-generations
nixjust sys-clean-system          # Conservative garbage collection
# Only if intentionally sacrificing old rollback generations:
nixjust sys-cleanup-generations
```

Your `modules/core/nix.nix` also enables weekly automatic garbage collection using `--delete-older-than 10d`. **This can remove old generations**, reducing rollback history even if you never manually run `sys-cleanup-generations`. Revisit that setting if keeping long-term rollback points is important to you.

## Working on the Justfile itself

The root `Justfile` imports `just/system.just`, `just/flake.just`, `just/git.just`, `just/maintenance.just`, and `just/recovery.just`. Add or modify a recipe in the appropriate file; you normally do not need to edit the imports.

```bash
cd /etc/nixos
just --list
just --dry-run sys-update-boot
git add Justfile just/
git status
```

`FLAKE := "/etc/nixos"` and `FLAKE_HOST := "nixos"` are defined in the root Justfile. If you rename the flake output, update `FLAKE_HOST` too. You **do not need a NixOS rebuild simply to edit a Just recipe**; run the revised command directly. If you change the `nixjust` wrapper in Home Manager, rebuild to deploy that change.

## First-time or recovery checks

```bash
cd /etc/nixos
nixjust sys-bootstrap
nixjust ssh-setup
ssh -T git@github.com
```

GitHub SSH authentication requires a valid private SSH key on the machine and the corresponding public key registered with GitHub. Keep private keys out of Git. `ssh-setup` checks for a key; it does **not** automatically register a new key with GitHub. If your files came from a GitHub ZIP instead of a clone, the `.git` directory is absent: prefer `git clone` to restore the remote and history.
