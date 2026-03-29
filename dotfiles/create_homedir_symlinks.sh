#!/bin/bash
# -----------------------------------------------------------------------------
# -- Create Symlinks to ~/.dotfiles -------------------------------------------
#
# Replaces user configuration files with symlinks to ~/.dotfiles content.
# Backs up existing files before replacement.
#
# Robustness features:
#   - strict mode + fail-fast
#   - portable path handling across Linux/BSD/macOS/Cygwin
#   - preflight validation and post-link verification
#   - modes: --dry-run,
#            --backup-only,
#            --restore-latest
# -----------------------------------------------------------------------------

# -- Strict mode --------------------------------------------------------------
set -euo pipefail

# -- Runtime flags ------------------------------------------------------------
DRY_RUN=0
BACKUP_ONLY=0
RESTORE_LATEST=0

# -- Common settings ----------------------------------------------------------
user="${USER:-}"
homedir="${HOME:-}"
timestamp="$(date +%Y%m%d_%H%M%S)"

# -- Script source and destinations -------------------------------------------
script_path="${BASH_SOURCE[0]}"
script_dir="$(cd -- "$(dirname -- "${script_path}")" && pwd -P)"
config_dirname=".dotfiles"
new_config_location="${homedir}/${config_dirname}"
backup_root="${homedir}/DOTFILE_BACKUPS"
backup_folder_name="${backup_root}/${user}_config_files_${timestamp}"

# -- Color scheme -------------------------------------------------------------
col_gry='\033[0;37m'
col_red='\033[0;91m'
col_grn='\033[0;92m'
col_yel='\033[0;93m'
col_mag='\033[0;95m'
col_cyn='\033[0;96m'
col_off='\033[0m'

# -- Link mapping (target -> destination) -------------------------------------
link_targets=(
  "${new_config_location}/bash/.bashrc"
  "${new_config_location}/bash/.bash_profile"
  "${new_config_location}/bash/.bash_logout"
  "${new_config_location}/bash/.bash_config_files"
  "${new_config_location}/vim/.vimrc"
  "${new_config_location}/vim/.vim"
  "${new_config_location}/fonts/.fonts"
)

link_destinations=(
  "${homedir}/.bashrc"
  "${homedir}/.bash_profile"
  "${homedir}/.bash_logout"
  "${homedir}/.bash_config_files"
  "${homedir}/.vimrc"
  "${homedir}/.vim"
  "${homedir}/.fonts"
)


# -- Utilities ----------------------------------------------------------------
function usage {
  cat <<EOF
Usage: ./create_homedir_symlinks.sh [options]

Options:
  --dry-run         Show actions but do not modify files
  --backup-only     Create backups only; do not install symlinks
  --restore-latest  Restore files from latest backup and exit
  -h, --help        Show this help
EOF
}

function run_cmd {
  if [[ ${DRY_RUN} -eq 1 ]]; then
    printf '[DRY-RUN] '
    printf '%q ' "$@"
    echo ""
    return 0
  fi
  "$@"
}

function exists_path {
  local p="${1}"
  [[ -e "${p}" || -L "${p}" ]]
}

function path_is_symlink_to {
  local dest="${1}"
  local target="${2}"

  if [[ ! -L "${dest}" ]]; then
    return 1
  fi

  [[ "$(readlink "${dest}")" == "${target}" ]]
}

function all_symlinks_managed {
  local idx=0
  while [[ ${idx} -lt ${#link_targets[@]} ]]; do
    if ! path_is_symlink_to "${link_destinations[${idx}]}" "${link_targets[${idx}]}"; then
      return 1
    fi
    idx=$((idx + 1))
  done
  return 0
}

function latest_backup_dir {
  ls -1dt "${backup_root}/${user}_config_files_"* 2>/dev/null | head -n 1
}

function finish_success {
  echo -e "${col_cyn}-------------------------------------------------------------------${col_off}"
  echo -e "${col_grn} >> SUCCESS${col_off}:  ${col_yel}Complete!${col_off}"
  echo ""
}

function finish_failed {
  local line_no="${1:-unknown}"
  local backup_hint
  backup_hint="$(latest_backup_dir || true)"

  echo -e "${col_cyn}-------------------------------------------------------------------${col_off}"
  echo -e "${col_red} >> ERROR${col_off}:  ${col_yel}Abnormal exit - Incomplete${col_off}"
  echo -e "${col_red}    Failure at line:${col_off} ${line_no}"
  if [[ -n "${backup_hint}" ]]; then
    echo -e "${col_yel}    Latest backup:${col_off} ${backup_hint}"
    echo -e "${col_yel}    Restore command:${col_off} bash ${script_path} --restore-latest"
  fi
  echo ""
}

function on_error {
  local line_no="${1:-unknown}"
  finish_failed "${line_no}"
  exit 1
}

trap 'on_error "${LINENO}"' ERR

function display_banner_file {
  local banner_file="${script_dir}/_resources/banner_05.txt"

  if [[ -f "${banner_file}" ]]; then
    if [[ "$(type -t colorize_gradient)" == "function" ]]; then
        cat "${banner_file}" | colorize_gradient
    else
        while IFS= read -r -n 1 -d '' c
        do
          printf '\033[0;%dm%s\e[0m' "$((RANDOM % 7 + 91))" "$c"; 
        done < "${banner_file}"
    fi
  fi
}

function display_banner {
  echo ""
  echo -e "${col_yel}Installing..${col_off}"
  display_banner_file
  echo ""
}

function parse_args {
  while [[ $# -gt 0 ]]; do
    case "${1}" in
      --dry-run)
        DRY_RUN=1
        ;;
      --backup-only)
        BACKUP_ONLY=1
        ;;
      --restore-latest)
        RESTORE_LATEST=1
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        echo "Unknown option: ${1}" >&2
        usage
        exit 1
        ;;
    esac
    shift
  done

  if [[ ${BACKUP_ONLY} -eq 1 && ${RESTORE_LATEST} -eq 1 ]]; then
    echo "Options --backup-only and --restore-latest cannot be combined." >&2
    exit 1
  fi
}

function preflight_checks {
  echo -e " ${col_yel}::${col_off} Running preflight checks"

  [[ -n "${user}" ]]       || { echo "USER is not set"                     >&2; exit 1; }
  [[ -n "${homedir}" ]]    || { echo "HOME is not set"                     >&2; exit 1; }
  [[ -d "${homedir}" ]]    || { echo "HOME is not a directory: ${homedir}" >&2; exit 1; }
  [[ -w "${homedir}" ]]    || { echo "HOME is not writable: ${homedir}"    >&2; exit 1; }
  [[ -d "${script_dir}" ]] || { echo "Script dir not found: ${script_dir}" >&2; exit 1; }

  local required_sources=(
    "${script_dir}/bash/.bashrc"
    "${script_dir}/bash/.bash_profile"
    "${script_dir}/bash/.bash_logout"
    "${script_dir}/bash/.bash_config_files"
    "${script_dir}/vim/.vimrc"
    "${script_dir}/vim/.vim"
    "${script_dir}/fonts/.fonts"
  )

  local src
  for src in "${required_sources[@]}"; do
    [[ -e "${src}" ]] || { echo "Missing required source path: ${src}" >&2; exit 1; }
  done
}

function backup_path {
  local path="${1}"
  local remove_after="${2}"

  if ! exists_path "${path}"; then
    return 0
  fi

  run_cmd cp -a "${path}" "${backup_folder_name}/"

  if [[ "${remove_after}" == "1" ]]; then
    run_cmd rm -rf "${path}"
  fi
}

# -- Backup stage functions ------------------------------------------------
function perform_backup_stage {
  echo ""
  echo -e "${col_cyn}-------------------------------------------------------------------${col_off}"
  echo -e "${col_yel} STAGE 1: Backup Existing Files${col_off}"
  echo -e "${col_cyn}-------------------------------------------------------------------${col_off}"

  echo -e " ${col_yel}::${col_off} Creating backup folder : ${col_cyn}${backup_folder_name}${col_off}"
  run_cmd mkdir -p "${backup_folder_name}"

  echo -e " ${col_yel}::${col_off} Archiving preserved file : ${col_cyn}.bash_settings_custom${col_off}"
  backup_path "${homedir}/.bash_settings_custom" "0"

  echo -e " ${col_yel}::${col_off} Archiving + removing managed files"
  backup_path "${new_config_location}" "1"
  backup_path "${homedir}/.bashrc" "1"
  backup_path "${homedir}/.bash_profile" "1"
  backup_path "${homedir}/.bash_logout" "1"
  backup_path "${homedir}/.bash_config_files" "1"
  backup_path "${homedir}/.vimrc" "1"
  backup_path "${homedir}/.vim" "1"
  backup_path "${homedir}/.fonts" "1"

  echo -e " ${col_grn}:: Backup stage complete${col_off}"
}

# -- Install stage functions ------------------------------------------------
function sync_config_repo {
  local script_dir_real
  local new_config_parent

  script_dir_real="$(cd "${script_dir}" && pwd -P)"
  new_config_parent="$(dirname "${new_config_location}")"

  if [[ "${script_dir_real}" == "${new_config_location}" ]]; then
    echo -e " ${col_yel}::${col_off} Skipping copy to ${config_dirname}; source is already ${new_config_location}"
    return
  fi

  run_cmd mkdir -p "${new_config_parent}"
  run_cmd rm -rf "${new_config_location}"
  run_cmd mkdir -p "${new_config_location}"
  run_cmd cp -a "${script_dir}/." "${new_config_location}/"
}

function ensure_symlink {
  local target="${1}"
  local dest="${2}"

  if path_is_symlink_to "${dest}" "${target}"; then
    return 0
  fi

  if exists_path "${dest}"; then
    run_cmd rm -rf "${dest}"
  fi

  run_cmd ln -s "${target}" "${dest}"
}

function perform_install_stage {
  echo ""
  echo -e "${col_cyn}-------------------------------------------------------------------${col_off}"
  echo -e "${col_yel} STAGE 2: Install Symlinks${col_off}"
  echo -e "${col_cyn}-------------------------------------------------------------------${col_off}"

  echo -e " ${col_yel}::${col_off} Syncing ${config_dirname} content to ${col_cyn}${new_config_location}${col_off}"
  sync_config_repo

  echo -e " ${col_yel}::${col_off} Creating symlinks"
  local idx=0
  while [[ ${idx} -lt ${#link_targets[@]} ]]; do
    ensure_symlink "${link_targets[${idx}]}" "${link_destinations[${idx}]}"
    idx=$((idx + 1))
  done

  echo -e " ${col_grn}:: Install stage complete${col_off}"
}

# -- Verification functions ------------------------------------------------
function verify_symlinks {
  echo -e " ${col_yel}::${col_off} Verifying installed symlinks"

  local idx=0
  while [[ ${idx} -lt ${#link_targets[@]} ]]; do
    if ! path_is_symlink_to "${link_destinations[${idx}]}" "${link_targets[${idx}]}"; then
      echo "Symlink verification failed: ${link_destinations[${idx}]} -> ${link_targets[${idx}]}" >&2
      exit 1
    fi
    idx=$((idx + 1))
  done

  echo -e " ${col_grn}:: Verification complete${col_off}"
}

# -- Restore stage functions ------------------------------------------------
function restore_latest_backup {
  local backup_dir
  backup_dir="$(latest_backup_dir || true)"

  if [[ -z "${backup_dir}" || ! -d "${backup_dir}" ]]; then
    echo "No backup directory found under ${backup_root}" >&2
    exit 1
  fi

  echo -e "${col_cyn}-------------------------------------------------------------------${col_off}"
  echo -e "${col_yel} RESTORE: Restoring from latest backup${col_off}"
  echo -e "${col_yel} Source:${col_off} ${backup_dir}"
  echo -e "${col_cyn}-------------------------------------------------------------------${col_off}"

  local restored=0
  local entry
  while IFS= read -r -d '' entry; do
    local base
    local dest
    base="$(basename "${entry}")"
    dest="${homedir}/${base}"

    if exists_path "${dest}"; then
      run_cmd rm -rf "${dest}"
    fi
    run_cmd cp -a "${entry}" "${homedir}/"
    restored=$((restored + 1))
  done < <(find "${backup_dir}" -mindepth 1 -maxdepth 1 -print0)

  if [[ ${restored} -eq 0 ]]; then
    echo "Backup directory is empty: ${backup_dir}" >&2
    exit 1
  fi

  echo -e " ${col_grn}:: Restore complete (${restored} entries)${col_off}"
}


# -- Main --------------------------------------------------------------------
parse_args "$@"
preflight_checks

echo ""
display_banner

echo -e "${col_cyn}-------------------------------------------------------------------${col_off}"
echo -e "${col_yel} Managing [USER=${col_mag}${user}${col_yel}] configuration files${col_off}"
echo -e "${col_cyn}-------------------------------------------------------------------${col_off}"

if [[ ${RESTORE_LATEST} -eq 1 ]]; then
  restore_latest_backup
  finish_success
  exit 0
fi

perform_backup_stage

if [[ ${BACKUP_ONLY} -eq 1 ]]; then
  echo -e " ${col_mag}:: Backup-only mode enabled; install stage skipped${col_off}"
  finish_success
  exit 0
fi

perform_install_stage
verify_symlinks

echo ""
echo -e " ${col_yel}::${col_off} Activating config files: ${col_cyn}Bash${col_off}      ${col_yel}>>${col_off} [${col_mag}Enter 'source ~/.bashrc' to activate${col_off}]"
echo -e " ${col_yel}::${col_off} Activating config files: ${col_cyn}Vim${col_off}       ${col_yel}>>${col_off} [${col_yel}SKIPPED${col_off}]"
echo -e " ${col_yel}::${col_off} Activating config files: ${col_cyn}Fonts${col_off}     ${col_yel}>>${col_off} [${col_yel}SKIPPED${col_off}]"

finish_success

# -- End of File --------------------------------------------------------------
