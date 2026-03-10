# ----------------------------------------------------------------------------
# -- BASH profile ------------------------------------------------------------
#
#  This script is executed when an interactive BASH login shell is started
#
# ----------------------------------------------------------------------------


# Source common settings
if [ -f  ~/.bashrc ]; then
  source ~/.bashrc
fi

# Timestamp (current)
if [[ -z $TIME_AT_LOGIN ]] ; then
  TIME_AT_LOGIN=$(date '+%F %r')
  export TIME_AT_LOGIN
fi

# User specific environment and startup programs



# -- End of File  ------------------------------------------------------------
# ----------------------------------------------------------------------------
