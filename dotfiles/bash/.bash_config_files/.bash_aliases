# ----------------------------------------------------------------------------
# -- BASH Aliases ------------------------------------------------------------
#
# This file defines the command aliases to be used in a Bash session.
#
# This file is intended to be "sourced" by .bashrc or equivalent:
#
#    if [ -f "${SCRIPT_DIR}/.bash_aliases" ]; then
#     source "${SCRIPT_DIR}/.bash_aliases"
#    fi
#
# ----------------------------------------------------------------------------

# -- Fetch this file's directory ---------------------------------------------
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


# -- Source Common aliases ---------------------------------------------------
if [ -f  "${SCRIPT_DIR}/.bash_aliases_common" ]; then
  source "${SCRIPT_DIR}/.bash_aliases_common"
fi


# -- Source Git aliases ------------------------------------------------------
if [ -f  "${SCRIPT_DIR}/.bash_aliases_git" ]; then
  source "${SCRIPT_DIR}/.bash_aliases_git"
fi


# -- End of File  ------------------------------------------------------------
# ----------------------------------------------------------------------------
