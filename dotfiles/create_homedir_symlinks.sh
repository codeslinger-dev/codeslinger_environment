#!/bin/bash
# ----------------------------------------------------------------------------
# -- Create Symlinks to ~/.dotfiles ------------------------------------------
#
# This file replaces the user's existing configuration files with those
# contained in this directory (via symbolic links.)
#
# A backup folder is created to store the original files.
#
# ----------------------------------------------------------------------------


# -- Common settings ---------------------------------------------------------
#
user="$USER"
homedir="$HOME"
timestamp=$(date +%Y%m%d_%H%M%S)


# -- Script source and destinations ------------------------------------------
#
script_dir="$(dirname "$(readlink -f "$0")")"
config_dirname=".dotfiles"
new_config_location="${homedir}/${config_dirname}"
backup_folder_name="${homedir}/DOTFILE_BACKUPS/${user}_config_files_${timestamp}"


# -- Color scheme ------------------------------------------------------------
#
col_gry='\033[0;37m'
col_red='\033[0;91m'
col_grn='\033[0;92m'
col_yel='\033[0;93m'
col_mag='\033[0;95m'
col_cyn='\033[0;96m'
col_off='\033[0m'


# -- File commands (move/link) -----------------------------------------------
#
CMD_COPY="cp -rf "
CMD_COPY_DEEP="cp -rfL "
CMD_RM="rm -rf "
CMD_MV="mv -f "
CMD_LINK="ln -sf "


# -- Script Exit-Handler:  Normal exit ---------------------------------------
#
function finish_success {
  echo -e "${col_cyn}-------------------------------------------------------------------${col_off}"
  echo -e "${col_grn} >> SUCCESS${col_off}:  ${col_yel}Complete!${col_off}"
  echo ""
}

# -- Script Exit-Handler:  Abnormal exit -------------------------------------
#
function finish_failed {
  echo -e "${col_cyn}-------------------------------------------------------------------${col_off}"
  echo -e "${col_red} >> ERROR${col_off}:  ${col_yel}Abnormal exit - Incomplete${col_off}"
  echo ""
}

# -- TRAP:  Trap non-0 exits  ------------------------------------------------
#
trap '[ "$?" -eq 0 ] || finish_failed'  EXIT


function display_banner_file {
  local banner_file="${script_dir}/_resources/banner_05.txt"

  if [[ "$(type -t colorize_gradient)" == "function" ]]; then

    cat "${banner_file}" | colorize_gradient

  else

    while IFS= read -r -n 1 -d '' c
    do
      printf '\033[0;%dm%s\e[0m' "$((RANDOM % 7 + 91))" "$c"; 
    done < "${banner_file}"

  fi
}


function display_banner {

  echo ""
  echo -e "${col_yel}Installing..${col_off}"

  display_banner_file

  echo ""
}


# -- Begin Processing  -------------------------------------------------------
#
echo ""
display_banner
echo ""

echo -e "${col_cyn}-------------------------------------------------------------------${col_off}"
echo -e "${col_yel} Replacing [USER=${col_mag}${user}${col_yel}]'s config files..${col_off}"
echo -e "${col_cyn}-------------------------------------------------------------------${col_off}"


# -- STAGE 1:  Backup Existing Files -----------------------------------------
#


# -- Create a backup folder in the user's homedir ----------------------------
#
echo -e " ${col_yel}::${col_off} Creating backup folder :  ${col_cyn}${backup_folder_name}${col_off}"
mkdir -p  "${backup_folder_name}" >& /dev/null


# -- Check for fatal error ---------------------------------------------------
#
if [[ ! -d "${backup_folder_name}" ]]; then
  echo -e "    ${col_red}ERROR${col_off}: Could not create backup folder! [${col_red}fatal${col_off}]"
  exit -1
fi
echo ""


# -- Copy configuration files: .dotfiles -------------------------------------
#
echo -n -e " ${col_yel}::${col_off} Archiving config files :  ${col_cyn}${config_dirname}${col_off} ${col_yel}>>${col_off} "

if [[ -d  "${new_config_location}" ]]; then
  ${CMD_COPY_DEEP}  "${new_config_location}"         "${backup_folder_name}/"
  ${CMD_RM}         "${new_config_location}"
  echo -e "[${col_grn} SUCCESS ${col_off}]"
else
  echo -e "[${col_yel} SKIPPED ${col_off}]"
fi


# -- Copy configuration files: BASH ------------------------------------------
#
echo -n -e " ${col_yel}::${col_off} Archiving config files :  ${col_cyn}Bash${col_off}      ${col_yel}>>${col_off} "

if [[ -f "${homedir}/.bash_settings_custom" ]]; then
  ${CMD_COPY_DEEP}  "${homedir}/.bash_settings_custom" "${backup_folder_name}/"
  # <do not delete custom settings file>
fi

if [[ -f "${homedir}/.bashrc" ]]; then
  ${CMD_COPY_DEEP}  "${homedir}/.bashrc"               "${backup_folder_name}/"
  ${CMD_RM}         "${homedir}/.bashrc"

  ${CMD_COPY_DEEP}  "${homedir}/.bash_profile"         "${backup_folder_name}/"
  ${CMD_RM}         "${homedir}/.bash_profile"

  ${CMD_COPY_DEEP}  "${homedir}/.bash_logout"          "${backup_folder_name}/"
  ${CMD_RM}         "${homedir}/.bash_logout"

  ${CMD_COPY_DEEP}  "${homedir}/.bash_config_files"    "${backup_folder_name}/"
  ${CMD_RM}         "${homedir}/.bash_config_files"

  echo -e "[${col_grn} SUCCESS ${col_off}]"
else
  echo -e "[${col_yel} SKIPPED ${col_off}]"
fi


# -- Copy configuration files: VIM -------------------------------------------
#
echo -n -e " ${col_yel}::${col_off} Archiving config files :  ${col_cyn}Vim${col_off}       ${col_yel}>>${col_off} "

if [[ -f "${homedir}/.vimrc" ]]; then
  ${CMD_COPY_DEEP}  "${homedir}/.vimrc"              "${backup_folder_name}/"
  ${CMD_RM}         "${homedir}/.vimrc"

  ${CMD_COPY_DEEP}  "${homedir}/.vim"                "${backup_folder_name}/"
  ${CMD_RM}         "${homedir}/.vim"
  echo -e "[${col_grn} SUCCESS ${col_off}]"
else
  echo -e "[${col_yel} SKIPPED ${col_off}]"
fi


# -- Copy configuration files: FONTS ------------------------------------------
#
echo -n -e " ${col_yel}::${col_off} Archiving config files :  ${col_cyn}Fonts${col_off}     ${col_yel}>>${col_off} "
if [[ -d "${homedir}/.fonts" ]]; then
  ${CMD_COPY_DEEP}  "${homedir}/.fonts"              "${backup_folder_name}/"
  echo -e "[${col_grn} SUCCESS ${col_off}]"
else
  echo -e "[${col_yel} SKIPPED ${col_off}]"
fi

# DEBUG
#read -p "Press [Enter] key to continue..."


# -- STAGE 2:  Replace Files -------------------------------------------------
#
echo ""


# -- Replace configuration files: .dotfiles ----------------------------------
#
echo -n -e " ${col_yel}::${col_off} Replacing config files :  ${col_cyn}${config_dirname}${col_off} ${col_yel}>>${col_off} "

#  echo "executing:  ${CMD_COPY}  ${script_dir}   ${new_config_location}"
  ${CMD_COPY_DEEP}  "${script_dir}"                             "${new_config_location}"
  echo -e "[${col_grn} SUCCESS ${col_off}]"


# -- Replace configuration files: BASH ---------------------------------------
#
echo -n -e " ${col_yel}::${col_off} Replacing config files :  ${col_cyn}Bash${col_off}      ${col_yel}>>${col_off} "

  ${CMD_LINK}  "${new_config_location}/bash/.bashrc"            "${homedir}/"
  ${CMD_LINK}  "${new_config_location}/bash/.bash_profile"      "${homedir}/"
  ${CMD_LINK}  "${new_config_location}/bash/.bash_logout"       "${homedir}/"
  ${CMD_LINK}  "${new_config_location}/bash/.bash_config_files" "${homedir}/"
  echo -e "[${col_grn} SUCCESS ${col_off}]"


# -- Replace configuration files: VIM ----------------------------------------
#
echo -n -e " ${col_yel}::${col_off} Replacing config files :  ${col_cyn}Vim${col_off}       ${col_yel}>>${col_off} "

  ${CMD_LINK}  "${new_config_location}/vim/.vimrc"              "${homedir}/"
  ${CMD_LINK}  "${new_config_location}/vim/.vim"                "${homedir}/"
  echo -e "[${col_grn} SUCCESS ${col_off}]"


# -- Replace configuration files: FONTS --------------------------------------
#
echo -n -e " ${col_yel}::${col_off} Replacing config files :  ${col_cyn}Fonts${col_off}     ${col_yel}>>${col_off} "

  ${CMD_LINK}  "${new_config_location}/fonts/.fonts"            "${homedir}/"
  echo -e "[${col_grn} SUCCESS ${col_off}]"



# -- STAGE 3:  Activate config ------------------------------------------------
#
echo ""


# -- Activate config: BASH ---------------------------------------------------
#
echo -n -e " ${col_yel}::${col_off} Activating config files:  ${col_cyn}Bash${col_off}      ${col_yel}>>${col_off} "

  echo -e "[${col_mag} Enter 'source ~/.bashrc' to activate ${col_off}]"


# -- Activate config: VIM ----------------------------------------------------
#
echo -n -e " ${col_yel}::${col_off} Activating config files:  ${col_cyn}Vim${col_off}       ${col_yel}>>${col_off} "

  echo -e "[${col_yel} SKIPPED ${col_off}]"



# -- Activate config: FONTS --------------------------------------------------
#
echo -n -e " ${col_yel}::${col_off} Activating config files:  ${col_cyn}Fonts${col_off}     ${col_yel}>>${col_off} "

  echo -e "[${col_yel} SKIPPED ${col_off}]"


# -- Finished Processing (normally) ------------------------------------------
#
finish_success



# -- End of File  ------------------------------------------------------------
#" ----------------------------------------------------------------------------
