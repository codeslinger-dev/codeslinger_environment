# Environment Dotfiles

Personal shell environment for Linux-style systems, focused on a curated Bash setup with Git helpers, prompt/greeting customization, Vim config, and terminal fonts.

## What this installs

- Bash: `.bashrc`, `.bash_profile`, `.bash_logout`, and `.bash_config_files/`
- Vim: `.vimrc` and `.vim/`
- Fonts: `.fonts/`
- Optional local overrides: `~/.bash_settings_custom` (preserved)

## Quick install

From this repo:

```bash
cd dotfiles
bash create_homedir_symlinks.sh
```

Then activate:

```bash
source ~/.bashrc
```

## What the installer does

- Creates a timestamped backup in `~/DOTFILE_BACKUPS/...`
- Copies this repo’s `dotfiles/` content to `~/.dotfiles`
- Replaces user config files with symlinks to `~/.dotfiles/...`
- Leaves `~/.bash_settings_custom` in place (if present)

## Updating

1. Pull latest repo changes.
2. Re-run `dotfiles/create_homedir_symlinks.sh`.
3. Run `source ~/.bashrc` (or open a new shell).

## Customization

Use `~/.bash_settings_custom` for machine-specific settings so updates do not overwrite local preferences.

### Performance tuning

**Disable command-not-found helper (Ubuntu/Mint):**

The command-not-found package can be extremely slow (50+ seconds on some systems). To disable:

```bash
# Add to ~/.bash_settings_custom
export ENV_SKIP_COMMAND_NOT_FOUND=1
```

**Disable directory stats in prompt:**

The prompt shows file count and directory size, which can be slow on NFS or large directories:

```bash
# Skip directory stats entirely
export ENV_PROMPT_SKIP_DIR_STATS=1
```

**Git prompt optimization for slow filesystems:**

If you're working on NFS mounts or other slow storage, you can optimize the git prompt by disabling expensive status checks. Add these to `~/.bash_settings_custom` or export before sourcing:

```bash
# Disable git dirty state checking (fastest performance boost)
export ENV_GIT_SHOW_DIRTY=0

# Disable untracked file detection
export ENV_GIT_SHOW_UNTRACKED=0

# Disable stash indicator
export ENV_GIT_SHOW_STASH=0

# Change upstream display (default: "git")
export ENV_GIT_SHOW_UPSTREAM="git"
```

**Available options:**
- `ENV_SKIP_COMMAND_NOT_FOUND` (default: `0`) - Set to `1` to skip slow command-not-found helper on Ubuntu/Mint.
- `ENV_PROMPT_SKIP_DIR_STATS` (default: `0`) - Set to `1` to skip file count/directory size in prompt (faster on NFS).
- `ENV_GIT_SHOW_DIRTY` (default: `1`) - Shows `*` for unstaged changes, `+` for staged changes. Most expensive check.
- `ENV_GIT_SHOW_UNTRACKED` (default: `0`) - Shows `%` for untracked files.
- `ENV_GIT_SHOW_STASH` (default: `0`) - Shows `$` when stash exists.
- `ENV_GIT_SHOW_UPSTREAM` (default: `"git"`) - Shows `<` (behind), `>` (ahead), `<>` (diverged), `=` (in sync).

Setting `ENV_SKIP_COMMAND_NOT_FOUND=1` provides the biggest speedup on Ubuntu/Mint systems (eliminates 50+ second delay).

### Greeting customization

The login greeting displays system information (CPU, RAM, uptime, etc.). Customize it with these environment variables:

```bash
# Disable greeting entirely
export ENV_GREETING_ENABLED=0

# Minimal mode: skip expensive operations (df, lscpu) on slow filesystems
export ENV_GREETING_MINIMAL=1

# Timeout per greeting function (seconds, default: 5)
export ENV_GREETING_TIMEOUT=3
```

**Available options:**
- `ENV_GREETING_ENABLED` (default: `1`) - Set to `0` to disable greeting.
- `ENV_GREETING_MINIMAL` (default: `0`) - Set to `1` to skip filesystem checks on NFS/slow storage.
- `ENV_GREETING_TIMEOUT` (default: `5`) - Maximum seconds per greeting function before timeout.

## Repo layout

- `dotfiles/bash/` → Bash config + modular aliases/functions/prompt/greeting
- `dotfiles/vim/` → Vim config
- `dotfiles/fonts/` → font links/assets
- `dotfiles/create_homedir_symlinks.sh` → installer

---

Maintainer note: keep this README focused on current end-user behavior and installation/update steps.