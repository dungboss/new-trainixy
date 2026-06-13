# new-trainixy
# Auto Commit And Push

Run this command in the project root:

```bash
bash scripts/auto-commit-push.sh
```

How it works:

- watches the repo for Git changes
- waits until edits are stable for 15 seconds
- runs `git add -A`
- creates a commit automatically
- pushes to `origin`

Useful options:

```bash
AUTO_GIT_DEBOUNCE=30 AUTO_GIT_INTERVAL=3 bash scripts/auto-commit-push.sh
```

- `AUTO_GIT_DEBOUNCE`: seconds to wait after the last file change before commit and push
- `AUTO_GIT_INTERVAL`: how often the watcher checks for changes
- `AUTO_GIT_MESSAGE_PREFIX`: custom commit message prefix
- `AUTO_GIT_REMOTE`: remote name, default is `origin`

Example:

```bash
AUTO_GIT_MESSAGE_PREFIX="shopify-auto" bash scripts/auto-commit-push.sh
```

Notes:

- stop it with `Ctrl+C`
- it will commit everything tracked and untracked in this repo
- if there are files you never want to push, add them to `.gitignore`
