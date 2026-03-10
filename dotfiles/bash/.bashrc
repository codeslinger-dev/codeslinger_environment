# .bashrc
# ----------------------------------------------------------------------------
# -- BASH Resources Configuration --------------------------------------------
#
#  This file configures the current (interactive) BASH shell.
#
# ----------------------------------------------------------------------------


# -- If not running interactively, don't do anything -------------------------
case $- in
    *i*) ;;
      *) return;;
esac


# -- Source global definitions -----------------------------------------------
if [ -f /etc/bashrc ]; then
      . /etc/bashrc
fi

# -- Local Home Directory ----------------------------------------------------
LOCAL_BASH_PATH=~


# -- History settings --------------------------------------------------------
shopt -s histappend
HISTSIZE=5000
HISTFILESIZE=250000
HISTCONTROL=ignoreboth
HISTTIMEFORMAT="[ %F / %T ]  "

 # --  Put multi-line commands into one history entry ------------------------
shopt -s cmdhist

# -- Correct small errors in directory names given to the `cd` buildtin ------
shopt -s cdspell

# -- Check that hashed commands still exist before running them --------------
shopt -s checkhash

# -- Expand aliases in shell scripts -----------------------------------------
shopt -s expand_aliases

# -- Update the values of LINES and COLUMNS after windows resize -------------
shopt -s checkwinsize


# -- Make less more friendly for non-text input files, see lesspipe(1) -------
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# -- Set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac


# -- Force a color-prompt configuration --------------------------------------
force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
#   if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    if [ -x /usr/bin/tput ] ; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi


# -- Setup git-prompt variables ----------------------------------------------
if [ -f  ${LOCAL_BASH_PATH}/.bash_config_files/.git_prompt ]; then
  source ${LOCAL_BASH_PATH}/.bash_config_files/.git_prompt
fi


# -- Define the Bash prompt --------------------------------------------------
if [ "$color_prompt" = yes ]; then
   if [[ -f  ${LOCAL_BASH_PATH}/.bash_config_files/.bash_prompt ]]; then
      source ${LOCAL_BASH_PATH}/.bash_config_files/.bash_prompt
   else
      PS1="\n\[\033[01;34m\]\w\[\033[00m\]\n[\d \@] \[\033[01;32m\]\u @ \h\[\033[00m\]:  "
   fi
else
    PS1="\n$\u @ \h:\w\$ "
fi

unset color_prompt
unset force_color_prompt


# -- Set preferred editor for local and remote sessions ----------------------
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
elif command -v gvim > /dev/null; then
    export EDITOR='gvim'
elif command -v vim > /dev/null; then
    export EDITOR='vim'
else
    export EDITOR='vi'
fi


# -- Configure less ----------------------------------------------------------
#      F: exit if the entire file can be displayed in one screen
#      R: Show ANSI colors
#      X: Prevent clearing the screen when exiting
export LESS="FRX"


# -- Enable programmable completion features ---------------------------------
if ! shopt -oq posix; then
  if   [ -f /usr/share/bash-completion/bash_completion ]; then
    source  /usr/share/bash-completion/bash_completion
  elif [ -f /usr/local/share/bash-completion/bash_completion ]; then
    source  /usr/local/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source  /etc/bash_completion
  fi
fi


# -- Add user's executable files to PATH -------------------------------------
if [[ -z $PATH_CONTAINS_USER_SCRIPTS ]] ; then
  if [ -d $HOME/scripts ]; then
    PATH="$HOME/scripts:$PATH"
    export PATH_CONTAINS_USER_SCRIPTS=TRUE
  fi
fi

if [[ -z $PATH_CONTAINS_USER_BIN ]] ; then
  if [ -d $HOME/bin ]; then
    PATH="$HOME/bin:$PATH"
    export PATH_CONTAINS_USER_BIN=TRUE
  fi
fi


# -- Merge ~/.Xresources -----------------------------------------------------
if [[ -z $XRESOURCES_MERGED ]] ; then
  if [ -f $HOME/.Xresources ] ; then
    if command -v xrdb > /dev/null; then
      xrdb -merge $HOME/.Xresources
      export XRESOURCES_MERGED=TRUE
    fi
  fi
fi


# -- Source functions --------------------------------------------------------
if [ -f  ${LOCAL_BASH_PATH}/.bash_config_files/.bash_functions ]; then
  source ${LOCAL_BASH_PATH}/.bash_config_files/.bash_functions
fi


# -- Source aliases ----------------------------------------------------------
if [ -f  ${LOCAL_BASH_PATH}/.bash_config_files/.bash_aliases ]; then
  source ${LOCAL_BASH_PATH}/.bash_config_files/.bash_aliases
fi


# -- Source any per-host custom settings -------------------------------------
if [ -f  ${LOCAL_BASH_PATH}/.bash_settings_custom ]; then
  source ${LOCAL_BASH_PATH}/.bash_settings_custom
fi


# -- Remove any duplicate path entries ---------------------------------------
PATH="$(echo "$PATH" | awk 'BEGIN{RS=":";}
{sub(sprintf("%c$",10),"");if(A[$0]){}else{A[$0]=1;
printf(((NR==1)?"":":")$0)}}')";
export PATH


# -- Display login greeting --------------------------------------------------
if [ -f  ${LOCAL_BASH_PATH}/.bash_config_files/.bash_greeting ]; then
  source ${LOCAL_BASH_PATH}/.bash_config_files/.bash_greeting
  display_greeting
fi


# -- Finally, run any pre-defined command (useful for xterm spawns) ----------
if [[ ${INITIAL_CMD} ]] ; then
  echo -e "${TC_CYN}Running initial command${TC_OFF}: '${INITIAL_CMD}'.."
  echo -e ""
  ${INITIAL_CMD}
  unset INITIAL_CMD
fi


# Timestamp (current)
if [[ -z $TIME_AT_LOGIN ]] ; then
  export TIME_AT_LOGIN=`date '+%F %r'`
fi

# -- End of File  ------------------------------------------------------------
# ----------------------------------------------------------------------------
