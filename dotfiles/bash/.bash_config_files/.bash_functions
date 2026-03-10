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
if [ -f  "${SCRIPT_DIR}/.bash_functions_common" ]; then
  source "${SCRIPT_DIR}/.bash_functions_common"
fi


# -- Source Search functions -------------------------------------------------
if [ -f  "${SCRIPT_DIR}/.bash_functions_search" ]; then
  source "${SCRIPT_DIR}/.bash_functions_search"
fi


# -- Source GIT functions ----------------------------------------------------
if [ -f  "${SCRIPT_DIR}/.bash_functions_git" ]; then
  source "${SCRIPT_DIR}/.bash_functions_git"
fi


# -- Python virtual environment helpers --------------------------------------
# Keep virtualenv from changing PS1 directly; prompt is managed separately.
if [[ -z ${VIRTUAL_ENV_DISABLE_PROMPT+x} ]]; then
  export VIRTUAL_ENV_DISABLE_PROMPT=1
fi

function _env_python_find_local_venv_activate()
{
  local activate_script=""

  if [[ -f "${PWD}/.venv/bin/activate" ]]; then
    activate_script="${PWD}/.venv/bin/activate"
  elif [[ -f "${PWD}/venv/bin/activate" ]]; then
    activate_script="${PWD}/venv/bin/activate"
  fi

  printf '%s\n' "${activate_script}"
} # _env_python_find_local_venv_activate()


function env_python_auto_venv()
{
  local activate_script
  activate_script=$(_env_python_find_local_venv_activate)

  if [[ -z ${VIRTUAL_ENV:-} && -n ${activate_script} ]]; then
    # shellcheck disable=SC1090
    source "${activate_script}"
    __ENV_AUTO_VENV_ROOT="${PWD}"
    export __ENV_AUTO_VENV_ROOT
    return
  fi

  if [[ -n ${VIRTUAL_ENV:-} && -n ${__ENV_AUTO_VENV_ROOT:-} ]]; then
    if [[ ${PWD} != "${__ENV_AUTO_VENV_ROOT}" && ${PWD} != "${__ENV_AUTO_VENV_ROOT}"/* ]]; then
      if declare -F deactivate > /dev/null; then
        deactivate
      fi
      unset __ENV_AUTO_VENV_ROOT
    fi
  fi
} # env_python_auto_venv()


function env_python_auto_venv_hook()
{
  env_python_auto_venv
} # env_python_auto_venv_hook()


# Add auto-venv hook to PROMPT_COMMAND once (interactive shells only)
if [[ $- == *i* ]]; then
  if [[ ${PROMPT_COMMAND:-} != *env_python_auto_venv_hook* ]]; then
    if [[ -n ${PROMPT_COMMAND:-} ]]; then
      PROMPT_COMMAND="env_python_auto_venv_hook; ${PROMPT_COMMAND}"
    else
      PROMPT_COMMAND="env_python_auto_venv_hook"
    fi
  fi
fi


# -- File has been sourced ---------------------------------------------------
FILE_SOURCED_FUNCTIONS=TRUE

# -- End of File  ------------------------------------------------------------
# ----------------------------------------------------------------------------
