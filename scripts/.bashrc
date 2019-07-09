[[ $- == *i* ]] || return

export SHELL=bash
export TERM=linux

clear
USR="builder"
HOSTNAME="module-builder"
export PS1="\[\033[1m\]\[\033[38;5;4m\]$USR\[\033[m\]\[\033[38;5;15m\]@\[\033[m\]\[\033[1m\]\$HOSTNAME\[\033[m\][\W]:\[\033[1m\]"

if [[ $- =~ "i" ]]
then
  cat ~/.motd
  neofetch --ascii_distro Lubuntu --off --color_blocks off --underline off --disable title packages icons theme gpu
fi
shopt -q -s checkwinsize

source ~/.aliases
source /usr/share/bash-completion/bash_completion
