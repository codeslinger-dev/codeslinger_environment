# ----------------------------------------------------------------------------
# -- BASH Functions ----------------------------------------------------------
#
# This file defines the command functions to be used in a Bash session.
#
# This file is intended to be "sourced" by .bashrc (or equivalent):
#
#    if [ -f <path>/.bash_functions ]; then
#     source <path>/.bash_functions
#    fi
#
#  Notes:  Bash functions can be defined multiple ways:
#
#           1) A function name with parentheses:
#                  my_function() {
#                    echo "My Function"
#                  }
#
#           2) A function name with parentheses on a single line:
#                  my_function() { echo "My Function"; }
#
#           3) Using the keyword 'function' (parentheses optional):
#                  function my_function() {
#                    echo "My Function"
#                  }
#
#         To view a function's definition, from a bash prompt:
#
#           1) declare -f <function_name>
#
#           2) type <function_name>
#
# ----------------------------------------------------------------------------

# -- Fetch this file's directory ---------------------------------------------
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


# -- Source Common functions -------------------------------------------------
if [ -f  ${SCRIPT_DIR}/.bash_functions_common ]; then
  source ${SCRIPT_DIR}/.bash_functions_common
fi


# -- Source Search functions -------------------------------------------------
if [ -f  ${SCRIPT_DIR}/.bash_functions_search ]; then
  source ${SCRIPT_DIR}/.bash_functions_search
fi


# -- Source GIT functions ----------------------------------------------------
if [ -f  ${SCRIPT_DIR}/.bash_functions_git ]; then
  source ${SCRIPT_DIR}/.bash_functions_git
fi


# -- File has been sourced ---------------------------------------------------
FILE_SOURCED_FUNCTIONS=TRUE

# -- End of File  ------------------------------------------------------------
# ----------------------------------------------------------------------------
