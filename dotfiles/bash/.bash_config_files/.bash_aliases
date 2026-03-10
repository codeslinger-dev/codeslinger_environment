# ----------------------------------------------------------------------------
# -- BASH Aliases ------------------------------------------------------------
#
# This file defines the command aliases to be used in a Bash session.
#
# This file is intended to be "sourced" by .bashrc or equivalent:
#
#    if [ -f /<path>/.bash_aliases ]; then
#     source /<path>/.bash_aliases
#    fi
#
# ----------------------------------------------------------------------------


# -- Use color, if supported -------------------------------------------------
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

  # Common commands
  alias    ls='ls --color=auto'
  alias  grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
  alias  diff='diff --color=auto'

  # GCC output:
  #
  #       error=01;31  |  error markers         |  Bold Red
  #     warning=01;35  |  warning markers       |  Bold Magenta
  #        note=01;36  |  note markers          |  Bold Cyan
  #       caret=01;32  |  caret line            |  Bold Green
  #       locus=01     |  location information  |  Bold
  #       quote=01     |  quoted text           |  Bold
  #
  export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

fi

# Alias for function that displays the
# ANSI-terminal color palette codes
alias print-terminal-colors='print_ansi_colors'

# Move up directories
alias  ..='cd ..'
alias ...='cd ../..'

# Some more 'ls' aliases
#  - groups dot-files together
alias  l='LC_COLLATE=C ls  -lF'
alias ll='LC_COLLATE=C ls -AlF'
alias la='LC_COLLATE=C ls -alF'

# Bash shortcuts
alias  s='source ~/.bashrc'
alias  h='history'
alias hs='history | grep'

# VIM/GVIM shortcuts
if command -v gvim > /dev/null; then
  alias    e='gvim'
  alias edit='gvim'
elif command -v vim > /dev/null; then
  alias    e='vim'
  alias edit='vim'
else
  alias    e='vi'
  alias edit='vi'
fi

# Force 'less' to interpret terminal color codes by default
alias less='less -R'

# Show just my running processes
alias psme="ps -aef | grep ${USER}"

# Type "please" to re-run your previous command under 'sudo'
alias please='sudo $(fc -ln -1)'

# Launch Web Browser (w/ params):  Mozilla Firefox
alias ffox='function _ffox()
{
  firefox "$@" &> /dev/null &
}; _ffox'

# Launch Web Browser (w/ params):  Google Chrome
alias chrome='function _chrome()
{
  google-chrome "$@" &> /dev/null &
}; _chrome'

# Launch Application (w/ params):  Spyder (Python IDE)
alias spyder='function _spyder()
{
  \spyder "$@" &> /dev/null &
}; _spyder'


# Search aliases (defined in .bash_functions)
alias   f='func_find'
alias  fs='func_find_stats'
alias  fu='func_find_undecorated'

alias  ff='func_find_follow'
alias ffs='func_find_follow_stats'
alias ffu='func_find_follow_undecorated'

# Enables simple aliases to be sudo'ed.
#  - ref: http://www.gnu.org/software/bash/manual/bashref.html#Aliases
alias sudo='sudo ';

# Use colordiff, if available
if type 'colordiff' &> /dev/null; then
  alias diff='colordiff'
fi

# tail (display all of file + monitor for updates)
alias tailf='tail -n +1 -f'

# Modify the xterm title prior to running ssh or su
alias ssh='xterm_invoke_ssh'
alias  su='xterm_invoke_su'

# Display the contents of PATH variable (line-by-line)
alias display-path='echo "" ; echo $PATH | tr : "\n" ; echo ""'

# Gather system hardware specs and dump them to a local HTML file
alias dump-hw-specs='sudo lshw -html > ./hardware_specs.html; echo "Created file => ./hardware_specs.html"'

# Have GCC dump its PreProcessor macros and settings
alias gcc_show_defines='echo | gcc -dM -E -'
alias gcc_show_native_defines='echo | gcc -dM -march=native -E -'

# xterm
alias   x='xterm_with_color "white"'
alias  x1='xterm_with_color "red"'
alias  x2='xterm_with_color "blue"'
alias  x3='xterm_with_color "green"'
alias  xc='xterm_with_color'

# watch
alias watch='watch --color'


# -- Source GIT aliases ------------------------------------------------------
if [ -f  ~/.bash_config_files/.bash_aliases_git ]; then
  source ~/.bash_config_files/.bash_aliases_git
fi


# -- End of File  ------------------------------------------------------------
# ----------------------------------------------------------------------------
