#--------------------------------#
#          Git Management
#--------------------------------#

# Inspect uncommitted changes before publishing.
git-status:
    @printf '\n\033[1;33m▶ Git status\033[0m\n'
    git status
    @printf '\n\033[1;32m✔ Git status complete\033[0m\n'

# Stage and commit configuration changes. Review `git status` first.
git-backup:
    @printf '\n\033[1;33m▶ Backing up NixOS configuration\033[0m\n'
    git add -A
    @if ! git diff --cached --quiet; then git commit -m "NixOS Update: $(date '+%Y-%m-%d %H:%M:%S')"; else echo "No changes to commit"; fi
    @printf '\n\033[1;32m✔ Backing up NixOS configuration complete\033[0m\n'

# Push committed changes to the configured GitHub remote.
git-push:
    @printf '\n\033[1;33m▶ Pushing configuration to GitHub\033[0m\n'
    git push origin main
    @printf '\n\033[1;32m✔ Pushing configuration to GitHub complete\033[0m\n'

# Explicit backup and push without rebuilding.
git-sync:
    @just git-backup
    @just git-push
    @printf '\n\033[1;33m▶ Backing up and pushing to GitHub\033[0m\n'
    @printf '\n\033[1;32m✔ Backing up and pushing to GitHub complete\033[0m\n'

