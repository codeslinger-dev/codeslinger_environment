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

### Performance tuning for slow filesystems

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
- `ENV_GIT_SHOW_DIRTY` (default: `1`) - Shows `*` for unstaged changes, `+` for staged changes. Most expensive check.
- `ENV_GIT_SHOW_UNTRACKED` (default: `0`) - Shows `%` for untracked files.
- `ENV_GIT_SHOW_STASH` (default: `0`) - Shows `$` when stash exists.
- `ENV_GIT_SHOW_UPSTREAM` (default: `"git"`) - Shows `<` (behind), `>` (ahead), `<>` (diverged), `=` (in sync).

Setting `ENV_GIT_SHOW_DIRTY=0` provides the biggest performance improvement while keeping branch name and ahead/behind status.

## Repo layout

- `dotfiles/bash/` → Bash config + modular aliases/functions/prompt/greeting
- `dotfiles/vim/` → Vim config
- `dotfiles/fonts/` → font links/assets
- `dotfiles/create_homedir_symlinks.sh` → installer

---

Maintainer note: keep this README focused on current end-user behavior and installation/update steps.