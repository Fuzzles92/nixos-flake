#--------------------------------#
#          Git Management
#--------------------------------#

# Inspect uncommitted changes before publishing.
git-status:
    git status

# Stage and commit configuration changes. Review `git status` first.
git-backup:
    git add -A
    @if ! git diff --cached --quiet; then git commit -m "NixOS Update: $(date '+%Y-%m-%d %H:%M:%S')"; else echo "No changes to commit"; fi

# Push committed changes to the configured GitHub remote.
git-push:
    git push origin main

# Explicit backup and push without rebuilding.
git-sync: git-backup git-push

